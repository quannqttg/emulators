@echo off
set "logFile=C:\Users\%USERNAME%\Desktop\anime\close_chrome_log.txt"

REM Create log file if it doesn't exist
if not exist "%logFile%" (
    echo Creating log file at: %logFile%
    type nul > "%logFile%"
)

:: Check if Chrome is running and close it
tasklist /FI "IMAGENAME eq chrome.exe" | find /I "chrome.exe" >nul
if %errorlevel% == 0 (
    echo Chrome is running. Attempting to close it... >> "%logFile%"
    taskkill /F /IM chrome.exe
    if %errorlevel% == 0 (
        echo Chrome closed successfully. >> "%logFile%"
    ) else (
        echo Failed to close Chrome. >> "%logFile%"
    )
) else (
    echo Chrome is not running. >> "%logFile%"
)

REM Log script completion
echo Script completed successfully. >> "%logFile%"
