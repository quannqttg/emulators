@echo off

REM Set user directory and anime directory variables
set "userDir=%USERNAME%"
set "animeDir=C:\Users\%userDir%\Desktop\anime"
set "logFile=%animeDir%\uninstall_log.txt"

REM Check if the anime directory exists, if not, create it
if not exist "%animeDir%" (
    echo Creating anime directory at: %animeDir% >> "%logFile%"
    mkdir "%animeDir%"
)

REM Create log file if it doesn't exist
if not exist "%logFile%" (
    echo Creating log file at: %logFile% >> "%logFile%"
    type nul > "%logFile%"
)

REM Log directories
echo Current user directory: %userDir% >> "%logFile%"
echo Anime directory set to: %animeDir% >> "%logFile%"

REM Check for administrative privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting administrative privileges... >> "%logFile%"
    powershell -command "Start-Process cmd -ArgumentList '/c %~f0' -Verb RunAs"
    exit /b
) else (
    echo Admin privileges confirmed. >> "%logFile%"
)

:: Log the beginning of the uninstallation process
echo Starting MuMu Player uninstallation process... >> "%logFile%"

:: Navigate to the MuMu Player directory
cd "C:\Program Files\Netease\MuMuPlayerGlobal-12.0"
if %errorlevel% neq 0 (
    echo Failed to navigate to MuMu Player directory. >> "%logFile%"
    exit /b
) else (
    echo Navigated to MuMu Player directory: C:\Program Files\Netease\MuMuPlayerGlobal-12.0 >> "%logFile%"
)

:: Run the uninstaller silently (check for silent option)
echo Running uninstall.exe silently... >> "%logFile%"
start /B "MuMu Uninstaller" "uninstall.exe" /S

:: Wait for the uninstallation process to complete
:checkProcess
timeout /t 5 >nul
tasklist | find /I "uninstall.exe" >nul
if %errorlevel% == 0 (
    echo Uninstallation is still running... >> "%logFile%"
    goto checkProcess
)

echo Uninstallation completed successfully. >> "%logFile%"
exit /b
