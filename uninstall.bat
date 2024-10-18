@echo off
setlocal

:: Define download URLs and paths
set "UninstallMuMUUrl=https://raw.githubusercontent.com/quannqttg/emulators/main/uninstall_mumu.bat"
set "UninstallMuMUPath=C:\Users\%USERNAME%\Desktop\anime\uninstall_mumu.bat"
set "CloseChromeUrl=https://raw.githubusercontent.com/quannqttg/emulators/main/close_chrome.bat"
set "CloseChromePath=C:\Users\%USERNAME%\Desktop\anime\close_chrome.bat"

:: Log file setup
set "logFile=C:\Users\%USERNAME%\Desktop\anime\script_log.txt"
echo Script started at %date% %time% >> "%logFile%"
echo User profile: %USERPROFILE% >> "%logFile%"

:: Check for anime directory
if not exist "C:\Users\%USERNAME%\Desktop\anime" (
    echo Anime directory not found, creating directory... >> "%logFile%"
    mkdir "C:\Users\%USERNAME%\Desktop\anime"
    echo Anime directory created successfully. >> "%logFile%"
) else (
    echo Anime directory already exists. >> "%logFile%"
)

:: Log directories
echo Anime directory set to: C:\Users\%USERNAME%\Desktop\anime >> "%logFile%"

:: Check for administrative privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting administrative privileges... >> "%logFile%"
    powershell -command "Start-Process cmd -ArgumentList '/c %~f0' -Verb RunAs"
    echo Administrative privileges requested. >> "%logFile%"
    exit /b
) else (
    echo Admin privileges confirmed. >> "%logFile%"
)

:: Download uninstall_mumu.bat
echo Downloading uninstall_mumu.bat... >> "%logFile%"
curl -L -o "%UninstallMuMUPath%" "%UninstallMuMUUrl%"
if %errorlevel% neq 0 (
    echo Failed to download uninstall_mumu.bat. Exiting... >> "%logFile%"
    exit /b
) else (
    echo uninstall_mumu.bat downloaded successfully to: %UninstallMuMUPath% >> "%logFile%"
)

:: Execute uninstall_mumu.bat in a new window
echo Executing uninstall_mumu.bat... >> "%logFile%"
start "" "%UninstallMuMUPath%"
echo uninstall_mumu.bat has been started. Continuing with main script... >> "%logFile%"

:: Delay before downloading close_chrome.bat
echo Waiting for 10 seconds before downloading close_chrome.bat... >> "%logFile%"
timeout /t 10 /nobreak >nul

:: Download close_chrome.bat
echo Downloading close_chrome.bat... >> "%logFile%"
curl -L -o "%CloseChromePath%" "%CloseChromeUrl%"
if %errorlevel% neq 0 (
    echo Failed to download close_chrome.bat. Exiting... >> "%logFile%"
    exit /b
) else (
    echo close_chrome.bat downloaded successfully to: %CloseChromePath% >> "%logFile%"
)

:: Log the time before executing close_chrome.bat
set "currentTime=%date% %time%"
echo Executing close_chrome.bat at %currentTime% >> "%logFile%"
cmd /c "%CloseChromePath%"
echo close_chrome.bat has been started. Exiting main script. >> "%logFile%"

:: Final log statement
echo Script completed successfully at %date% %time% >> "%logFile%"
exit /b
