@echo off
setlocal enabledelayedexpansion

REM Define paths for files
set "userDir=%USERNAME%"
set "animeDir=C:\Users\%userDir%\Desktop\anime"
set "logFile=%animeDir%\update_shared_folder.log"
set "shared_folder_file=%animeDir%\shared_folder.json"
set "config_file=%animeDir%\configs.json"
set "key_file=%animeDir%\key.json"

echo Starting the process to update shared_folder and device_key...
echo %date% %time% - update_shared_folder.bat is running >> "%logFile%"

REM Check if configs.json exists and delete it if it does
if exist "%config_file%" (
    echo %date% %time% - configs.json found. Deleting it... >> "%logFile%"
    del "%config_file%"
    if errorlevel 1 (
        echo %date% %time% - Failed to delete configs.json. Exiting... >> "%logFile%"
        echo Failed to delete configs.json. Exiting...
        exit /b 1
    )
    echo %date% %time% - configs.json deleted successfully. >> "%logFile%"
)

REM Download configs.json from GitHub using curl
echo Downloading configs.json from GitHub...
curl -L -o "%config_file%" "https://raw.githubusercontent.com/quannqttg/emulators/blob/main/upconfigs.json"
if errorlevel 1 (
    echo %date% %time% - Failed to download configs.json. Exiting... >> "%logFile%"
    echo Failed to download configs.json. Exiting...
    exit /b 1
)

REM Check if shared_folder.json exists
if not exist "%shared_folder_file%" (
    echo %date% %time% - shared_folder.json not found. Exiting... >> "%logFile%"
    echo shared_folder.json does not exist. Exiting...
    exit /b 1
)

REM Print the path to shared_folder_file for debugging
echo The path to shared_folder_file is: %shared_folder_file%

REM Print the content of shared_folder.json for debugging
type "%shared_folder_file%"

REM Read shared_folder value from shared_folder.json
set "shared_folder="
for /f "delims=" %%A in ('findstr /r /c:"\"shared_folder\"" "%shared_folder_file%"') do (
    set "line=%%A"
    REM Extract the value from the line by removing unwanted parts
    set "line=!line:*: =!"
    set "line=!line:~1,-1!"  REM Remove leading and trailing quotes
    set "shared_folder=!line!"
)

REM Check if shared_folder is empty
if "!shared_folder!"=="" (
    echo %date% %time% - Shared folder extraction failed. Exiting... >> "%logFile%"
    echo Failed to extract shared_folder value. Exiting...
    exit /b 1
)

REM Update configs.json with the new shared_folder
powershell -Command "(Get-Content %config_file%) -replace '\"shared_folder\": \"\"', '\"shared_folder\": \"!shared_folder!\"' | Set-Content %config_file%"

echo Configs.json updated with new shared_folder: !shared_folder! >> "%logFile%"
echo Configs.json successfully updated with shared_folder: !shared_folder!

REM Check if key.json exists
if not exist "%key_file%" (
    echo %date% %time% - key.json not found. Exiting... >> "%logFile%"
    echo key.json does not exist. Exiting...
    exit /b 1
)

REM Print the path to key_file for debugging
echo The path to key_file is: %key_file%

REM Read device_key value from key.json
set "device_key="
for /f "tokens=2 delims=: " %%A in ('findstr /r /c:"\"device_key\"" "%key_file%"') do (
    set "line=%%A"
    REM Extract the value from the line by removing unwanted parts
    set "line=!line:*: =!"
    set "line=!line:~1,-1!"  REM Remove leading and trailing quotes
    set "device_key=!line!"
)

REM Check if device_key is empty
if "!device_key!"=="" (
    echo %date% %time% - Device key extraction failed. Exiting... >> "%logFile%"
    echo Failed to extract device_key value. Exiting...
    exit /b 1
)

REM Update configs.json with the new device_key
powershell -Command "(Get-Content %config_file%) -replace '\"device_key\": \"\"', '\"device_key\": \"!device_key!\"' | Set-Content %config_file%"

echo Configs.json updated with new device_key: !device_key! >> "%logFile%"
echo Configs.json successfully updated with device_key: !device_key!

endlocal
exit /b 0
