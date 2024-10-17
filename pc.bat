@echo off
setlocal enabledelayedexpansion

:: Lấy tên người dùng hiện tại từ biến môi trường USERNAME
set "userDir=%USERNAME%"
set "animeDir=C:\Users\%userDir%\Desktop\anime"
set "logFile=%animeDir%\reclone.log"

echo Starting disk space check and recloning process...
echo %date% %time% - reclone.bat is running >> "%logFile%"
echo [DEBUG] Log entry created. >> "%logFile%"

REM Step 1: Check for administrative privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [DEBUG] No admin privileges detected. Requesting administrative privileges...
    echo Requesting administrative privileges... >> "%logFile%"
    powershell -command "Start-Process cmd -ArgumentList '/c %~f0' -Verb RunAs"
    exit /b
) else (
    echo [DEBUG] Admin privileges confirmed.
    echo Admin privileges confirmed. >> "%logFile%"
)

REM Check for PowerShell availability
where powershell >nul 2>&1
if errorlevel 1 (
    echo [DEBUG] PowerShell not found. Exiting...
    echo PowerShell not found. Exiting... >> "%logFile%"
    exit /b 1
) else (
    echo [DEBUG] PowerShell is available.
    echo PowerShell is available. >> "%logFile%"
)

REM Step 2: Check free space on C: drive
for /f "usebackq delims=" %%a in (`powershell -command "Get-PSDrive C | Select-Object -ExpandProperty Free"`) do (
    set "freeSpace=%%a"
)
if "%freeSpace%"=="" (
    echo [DEBUG] Failed to retrieve free space. Exiting...
    echo Failed to retrieve free space. Exiting... >> "%logFile%"
    exit /b 2
) else (
    echo [DEBUG] Retrieved free space: !freeSpace! bytes
    echo Retrieved free space: !freeSpace! bytes >> "%logFile%"
)

REM Verify freeSpace is a valid number
for /f "delims=0123456789" %%i in ("!freeSpace!") do (
    echo [DEBUG] Invalid free space value retrieved: "!freeSpace!". Exiting...
    echo Invalid free space value retrieved: "!freeSpace!". Exiting... >> "%logFile%"
    exit /b 3
)

set "minRequiredSpace=42949672960"
echo [DEBUG] Required minimum space: !minRequiredSpace! bytes
echo Required minimum space: !minRequiredSpace! bytes >> "%logFile%"

REM Compare free space using PowerShell
powershell -command "exit ([long]$env:freeSpace -lt [long]$env:minRequiredSpace)"
if %errorlevel% equ 1 (
    echo [DEBUG] Not enough free space on C: drive. Proceeding with cleanup...
    echo Not enough free space on C: drive. Proceeding with cleanup... >> "%logFile%"

    REM Countdown for 10 seconds
    for /l %%i in (10,-1,1) do (
        echo [DEBUG] %%i seconds remaining...
        echo %%i seconds remaining... >> "%logFile%"
        timeout /t 1 >nul
    )
    
    set "targetDir=C:\Program Files\Netease\MuMuPlayerGlobal-12.0\vms"
    if exist "!targetDir!" (
        echo [DEBUG] Target directory exists. Starting deletion process.
        echo Target directory exists. Starting deletion process. >> "%logFile%"
        for /d %%i in ("!targetDir!\*") do (
            if /i not "%%~nxi"=="MuMuPlayerGlobal-12.0-base" if /i not "%%~nxi"=="MuMuPlayerGlobal-12.0-0" (
                echo Deleting folder %%i...
                rmdir /s /q "%%i" && (
                    echo Successfully deleted folder %%i.
                    echo Successfully deleted folder %%i. >> "%logFile%"
                ) || (
                    echo Failed to delete folder %%i.
                    echo Failed to delete folder %%i. >> "%logFile%"
                )
            )
        )
        for %%i in ("!targetDir!\*") do (
            echo Deleting file %%i...
            del /q "%%i" && (
                echo Successfully deleted file %%i.
                echo Successfully deleted file %%i. >> "%logFile%"
            ) || (
                echo Failed to delete file %%i.
                echo Failed to delete file %%i. >> "%logFile%"
            )
        )
    ) else (
        echo [DEBUG] Target directory does not exist. Exiting...
        echo Target directory does not exist. Exiting... >> "%logFile%"
        exit /b 1
    )

    REM Download emulators.json from GitHub
    set "jsonSource=https://raw.githubusercontent.com/quannqttg/emulators/main/emulators.json"
    set "jsonDest=%animeDir%\data\emulators.json"
    echo [DEBUG] Downloading emulators.json from !jsonSource! to !jsonDest!...
    echo Downloading emulators.json from !jsonSource! to !jsonDest!... >> "%logFile%"
    curl -L -o "!jsonDest!" "!jsonSource!"
    if errorlevel 1 (
        echo [DEBUG] Failed to download emulators.json. Exiting...
        echo Failed to download emulators.json. Exiting... >> "%logFile%"
        exit /b 1
    )

    cd "%animeDir%" || exit /b 1
    if not exist "autoRelaunch_mumu.bat" (
        echo [DEBUG] File autoRelaunch_mumu.bat does not exist. Exiting...
        echo File autoRelaunch_mumu.bat does not exist. Exiting... >> "%logFile%"
        exit /b 1
    )

    echo [DEBUG] Running autoRelaunch_mumu.bat...
    echo Running autoRelaunch_mumu.bat... >> "%logFile%"
    call autoRelaunch_mumu.bat || exit /b 1
    echo [DEBUG] All operations completed successfully!
    echo All operations completed successfully! >> "%logFile%"
) else (
    echo [DEBUG] Sufficient free space on C: drive. Free space is !freeSpace! bytes.
    echo Sufficient free space on C: drive. Free space is !freeSpace! bytes >> "%logFile%"

    REM Countdown for 10 seconds
    for /l %%i in (10,-1,1) do (
        echo [DEBUG] %%i seconds remaining...
        echo %%i seconds remaining... >> "%logFile%"
        timeout /t 1 >nul
    )

    cd "%animeDir%" || exit /b 1
    if not exist "autoRelaunch_mumu.bat" (
        echo [DEBUG] File autoRelaunch_mumu.bat does not exist. Exiting...
        echo File autoRelaunch_mumu.bat does not exist. Exiting... >> "%logFile%"
        exit /b 1
    )

    echo [DEBUG] Running autoRelaunch_mumu.bat...
    echo Running autoRelaunch_mumu.bat... >> "%logFile%"
    call autoRelaunch_mumu.bat || exit /b 1
    echo [DEBUG] All operations completed successfully!
    echo All operations completed successfully! >> "%logFile%"
)

REM Ensure the script does not close immediately
pause
exit
