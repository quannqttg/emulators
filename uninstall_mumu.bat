@echo off

REM Set user directory and anime directory variables
set "userDir=%USERNAME%"
set "animeDir=C:\Users\%userDir%\Desktop\anime"
set "logFile=%animeDir%\uninstall.txt"

REM Check if the anime directory exists, if not, create it
if not exist "%animeDir%" (
    echo Creating anime directory at: %animeDir%
    mkdir "%animeDir%"
)

REM Create log file if it doesn't exist
if not exist "%logFile%" (
    echo Creating log file at: %logFile%
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

:: Run the uninstaller
echo Running uninstall.exe... >> "%logFile%"
start "" "uninstall.exe"
if %errorlevel% neq 0 (
    echo Failed to start uninstall.exe. >> "%logFile%"
    exit /b
) else (
    echo Uninstall process started successfully. >> "%logFile%"
)

REM Log script completion
echo Script completed successfully. >> "%logFile%"
