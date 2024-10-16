@echo off
setlocal enabledelayedexpansion

REM Set the current username and define paths for anime directory and log file
set "userDir=%USERNAME%"
set "animeDir=C:\Users\%userDir%\Desktop\anime"
set "logFile=%animeDir%\set_key.log"
set "key_file=%animeDir%\key.json"
set "config_file=%animeDir%\configs.json"

echo Starting the process to set device key...
echo %date% %time% - set_key.bat is running >> "%logFile%"

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

REM Check if key.json exists
if not exist "%key_file%" (
    echo %date% %time% - key.json not found. Exiting... >> "%logFile%"
    exit /b 1
)

REM Read the device key from key.json
for /f "tokens=2 delims=: " %%A in ('findstr /r /c:"\"device_key\"" "%key_file%"') do (
    set "device_key=%%~A"
)

REM Remove any surrounding quotes
set "device_key=%device_key:~1,-2%"

REM Check if the device_key is empty
if "%device_key%"=="" (
    echo %date% %time% - Device key extraction failed. Exiting... >> "%logFile%"
    exit /b 1
)

REM Update configs.json with the new device key
powershell -Command "(Get-Content %config_file%) -replace '\"device_key\": \"\"', '\"device_key\": \"%device_key%\"' | Set-Content %config_file%"

echo Configs.json updated with new device key: %device_key% >> "%logFile%"

endlocal
exit
