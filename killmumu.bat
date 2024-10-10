@echo off
setlocal enabledelayedexpansion

:: Lấy tên người dùng hiện tại và thiết lập đường dẫn cho thư mục anime và file log
set "userDir=%USERNAME%"
set "animeDir=C:\Users\%userDir%\Desktop\anime"
set "logFile=%animeDir%\killmumu.log"

echo Starting disk space check and recloning process...
echo %date% %time% - killmumu.bat is running >> "%logFile%"

REM Kiểm tra quyền Admin
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting administrative privileges... >> "%logFile%"
    powershell -command "Start-Process cmd -ArgumentList '/c %~f0' -Verb RunAs"
    exit /b
) else (
    echo Admin privileges confirmed. >> "%logFile%"
)

REM Kiểm tra sự hiện diện của PowerShell
where powershell >nul 2>&1
if errorlevel 1 (
    echo PowerShell not found. Exiting... >> "%logFile%"
    exit /b 1
) else (
    echo PowerShell is available. >> "%logFile%"
)

:askConfirmation
set /p confirm="Do you want to proceed with file deletion and related tasks? (y/n): "
if /i "%confirm%"=="y" goto proceed
if /i "%confirm%"=="n" goto cancel
echo Invalid input. Please enter 'y' for yes or 'n' for no.
goto askConfirmation

:proceed
echo [DEBUG] User confirmed to proceed with the operation.
echo User confirmed to proceed with the operation. >> "%logFile%"

:: Đếm ngược 10 giây
for /l %%i in (10,-1,1) do (
    echo [DEBUG] %%i seconds remaining...
    timeout /t 1 >nul
)

:: Thực hiện xóa các thư mục và file
set "targetDir=C:\Program Files\Netease\MuMuPlayerGlobal-12.0\vms"
if exist "!targetDir!" (
    for /d %%i in ("!targetDir!\*") do (
        if /i not "%%~nxi"=="MuMuPlayerGlobal-12.0-base" if /i not "%%~nxi"=="MuMuPlayerGlobal-12.0-0" (
            echo Deleting folder %%i...
            rmdir /s /q "%%i"
        )
    )
    for %%i in ("!targetDir!\*") do (
        echo Deleting file %%i...
        del /q "%%i"
    )
) else (
    echo Target directory does not exist. Exiting... >> "%logFile%"
    exit /b 1
)

:: Tải về file emulators.json từ GitHub
set "jsonSource=https://raw.githubusercontent.com/quannqttg/emulators/main/emulators.json"
set "jsonDest=%animeDir%\data\emulators.json"
curl -L -o "!jsonDest!" "!jsonSource!"
if errorlevel 1 (
    echo Failed to download emulators.json. Exiting... >> "%logFile%"
    exit /b 1
)

:: Chạy file autoRelaunch_mumu.bat
cd "%animeDir%" || exit /b 1
if not exist "autoRelaunch_mumu.bat" (
    echo File autoRelaunch_mumu.bat does not exist. Exiting... >> "%logFile%"
    exit /b 1
)
echo Running autoRelaunch_mumu.bat... >> "%logFile%"
call autoRelaunch_mumu.bat || exit /b 1
echo All operations completed successfully! >> "%logFile%"
goto end

:cancel
echo [DEBUG] User canceled the operation.
echo User canceled the operation. >> "%logFile%"
exit /b 0

:end
pause
exit
