@echo off
setlocal enabledelayedexpansion

:: Set the current username and define paths for anime directory and log file
set "userDir=%USERNAME%"
set "animeDir=C:\Users\%userDir%\Desktop\anime"
set "logFile=%animeDir%\get_device_key.log"
set "key_file=%animeDir%\key.json"
set "config_file=%animeDir%\configs.json"
set "output_file=%animeDir%\shared_folder.json"

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

REM Log the raw device_key variable for debugging
echo Found device_key: %device_key% >> "%logFile%"

REM Remove any surrounding quotes and spaces
set "device_key=%device_key:~2,-2%"
set "device_key=%device_key: =%"  REM Remove any spaces

REM Check if the device_key is empty
if "%device_key%"=="" (
    echo %date% %time% - Device key extraction failed. Exiting... >> "%logFile%"
    exit /b 1
)

REM Write the device key to key.json
echo "device_key": "%device_key%" >> "%key_file%"
echo Device key saved to %key_file% >> "%logFile%"

:: Start the extraction of shared_folder from configs.json
echo %date% %time% - Starting extraction of shared_folder... >> "%logFile%"

:: Check if the JSON file exists
if not exist "%config_file%" (
    echo JSON file does not exist. Exiting... >> "%logFile%"
    echo JSON file does not exist. Exiting...
    exit /b 1
)

:: Extract shared_folder from the JSON file
for /f "tokens=1,* delims=:" %%A in ('findstr /r /c:"\"shared_folder\"" "%config_file%"') do (
    set "shared_folder=%%B"
    echo Temporary value found: !shared_folder! >> "%logFile%"  REM Log the temporary value
    echo Temporary value found: !shared_folder!  REM Output to CMD
)

:: Remove surrounding quotes and spaces
set "shared_folder=!shared_folder:~2,-2!"
set "shared_folder=!shared_folder: =!"

:: Check if the shared_folder is empty
if "!shared_folder!"=="" (
    echo Failed to extract shared_folder. Exiting... >> "%logFile%"
    echo Failed to extract shared_folder. Exiting...
    exit /b 1
)

:: Write the value to shared_folder.json with the specified format
echo "shared_folder": "!shared_folder!" > "%output_file%"
echo Shared folder written to %output_file% >> "%logFile%"
echo Shared folder written to %output_file%  REM Output to CMD

endlocal
exit /b 0
