@echo off
setlocal enabledelayedexpansion

:: Set the current username and define paths for anime directory and log file
set "userDir=%USERNAME%"
set "animeDir=C:\Users\%userDir%\Desktop\anime"
set "logFile=%animeDir%\killmumu.log"

echo Starting disk space check and recloning process...
echo %date% %time% - killmumu.bat is running >> "%logFile%"

REM Check for administrative privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting administrative privileges... >> "%logFile%"
    powershell -command "Start-Process cmd -ArgumentList '/c %~f0' -Verb RunAs"
    exit /b
) else (
    echo Admin privileges confirmed. >> "%logFile%"
)

REM Check for PowerShell presence
where powershell >nul 2>&1
if errorlevel 1 (
    echo PowerShell not found. Exiting... >> "%logFile%"
    exit /b 1
) else (
    echo PowerShell is available. >> "%logFile%"
)

:askConfirmation
:: Ask for user confirmation to proceed with file deletion and related tasks
set /p confirm="Do you want to proceed with file deletion and related tasks? (y/n/x): "
if /i "%confirm%"=="y" goto proceed
if /i "%confirm%"=="n" goto skipDelete
if /i "%confirm%"=="x" (
    echo User chose to exit. Exiting... >> "%logFile%"
    exit /b 0
)
echo Invalid input. Please enter 'y', 'n', or 'x'.
goto askConfirmation

:proceed
echo [DEBUG] Proceeding with file deletion and download... >> "%logFile%"

:: Perform deletion of specific folders and files
set "targetDir=C:\Program Files\Netease\MuMuPlayerGlobal-12.0\vms"
if exist "!targetDir!" (
    echo Deleting contents in "!targetDir!"... >> "%logFile%"
    REM Loop through directories in the target directory
    for /d %%i in ("!targetDir!\*") do (
        if /i not "%%~nxi"=="MuMuPlayerGlobal-12.0-base" if /i not "%%~nxi"=="MuMuPlayerGlobal-12.0-0" (
            echo Deleting folder %%i... >> "%logFile%"
            rmdir /s /q "%%i"
        )
    )
    REM Loop through files in the target directory
    for %%i in ("!targetDir!\*") do (
        echo Deleting file %%i... >> "%logFile%"
        del /q "%%i"
    )
) else (
    echo Target directory does not exist. Exiting... >> "%logFile%"
    exit /b 1
)

:: Download emulators.json file from GitHub
set "jsonSource=https://raw.githubusercontent.com/quannqttg/emulators/main/emulators.json"
set "jsonDest=%animeDir%\data\emulators.json"
echo Downloading emulators.json from GitHub... >> "%logFile%"
curl -L -o "!jsonDest!" "!jsonSource!"
if errorlevel 1 (
    echo Failed to download emulators.json. Exiting... >> "%logFile%"
    exit /b 1
)

goto delayAndRun

:skipDelete
echo Skipping deletion. Proceeding to delay and auto run... >> "%logFile%"
goto delayAndRun

:delayAndRun
:: Add a 10-second countdown before running autoRelaunch_mumu.bat
echo Waiting for 10 seconds before running autoRelaunch_mumu.bat... >> "%logFile%"
for /L %%i in (10,-1,1) do (
    echo Starting in %%i seconds...
    timeout /t 1 >nul
)
echo Proceeding to run autoRelaunch_mumu.bat... >> "%logFile%"

:: Navigate to the anime directory and run autoRelaunch_mumu.bat
cd "%animeDir%" || exit /b 1
if not exist "autoRelaunch_mumu.bat" (
    echo File autoRelaunch_mumu.bat does not exist. Exiting... >> "%logFile%"
    exit /b 1
)
echo Running autoRelaunch_mumu.bat... >> "%logFile%"
call autoRelaunch_mumu.bat || exit /b 1
echo All operations completed successfully! >> "%logFile%"
goto end

:end
pause
exit
