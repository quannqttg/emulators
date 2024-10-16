@echo off
setlocal enabledelayedexpansion

:: Set the current username and define paths for anime directory and log file
set "userDir=%USERNAME%"
set "animeDir=C:\Users\%userDir%\Desktop\anime"
set "logFile=%animeDir%\get_device_key.log"
set "key_file=key.txt"
set "config_file=configs.json"

echo Starting the process to get device key...
echo %date% %time% - get_device_key.bat is running >> "%logFile%"

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

REM Check if configs.json exists
if not exist "%config_file%" (
    echo %date% %time% - configs.json not found. Exiting... >> "%logFile%"
    exit /b 1
)

REM Read the device key from configs.json
for /f "tokens=2 delims=:" %%A in ('findstr /r /c:"\"device_key\"" "%config_file%"') do (
    set "device_key=%%~A"
)

REM Remove any surrounding quotes and spaces
set "device_key=%device_key:~2,-2%"
set "device_key=%device_key: =%"  REM Remove any spaces

REM Write the device key to key.txt
echo "device_key": "%device_key%" >> "%key_file%"

echo Device key saved to %key_file%
endlocal

