@echo off
setlocal enabledelayedexpansion

REM Define paths for files
set "userDir=%USERNAME%"
set "animeDir=C:\Users\%userDir%\Desktop\anime"
set "logFile=%animeDir%\addnewkey.log"
set "shared_folder_file=%animeDir%\shared_folder.json"
set "config_file=%animeDir%\configs.json"
set "allkey_file=%animeDir%\allkey.json"
set "upconfig_file=%animeDir%\configs.json"

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
curl -L -o "%upconfig_file%" "https://raw.githubusercontent.com/quannqttg/emulators/main/upconfigs.json"
if errorlevel 1 (
    echo %date% %time% - Failed to download configs.json. Exiting... >> "%logFile%"
    echo Failed to download configs.json. Exiting...
    exit /b 1
)

REM Download allkey.json from GitHub using curl
echo Downloading allkey.json from GitHub...
curl -L -o "%allkey_file%" "https://raw.githubusercontent.com/quannqttg/emulators/main/allkey.json"
if errorlevel 1 (
    echo %date% %time% - Failed to download allkey.json. Exiting... >> "%logFile%"
    echo Failed to download allkey.json. Exiting...
    exit /b 1
)

:: Set the paths to the config files
set "configFile=%animeDir%\configs.json"
set "keyFile=%animeDir%\allkey.json"

:: Prompt the user to select a key
echo Choose a key to use:
for /L %%i in (1, 1, 100) do (
    echo %%i. Key%%i
)
set /p choice="Enter your choice (1 to 100): "

:: Debugging: Check the user choice
echo [DEBUG] User choice: %choice%

:: Validate user input
set choiceNum=%choice%
if "%choiceNum%"=="" (
    echo [DEBUG] Invalid choice: Input is empty. >> "%logFile%"
    echo Invalid choice. Please enter a number between 1 and 100.
    exit /b
)

:: Check if the user choice is a valid number between 1 and 100
for /f "delims=0123456789" %%A in ("%choiceNum%") do (
    echo [DEBUG] Invalid choice: Not a number. >> "%logFile%"
    echo Invalid choice. Please enter a number between 1 and 100.
    exit /b
)

set /a choiceNum=choiceNum
if %choiceNum% geq 1 if %choiceNum% leq 100 (
    echo [DEBUG] Valid choice detected: %choice%

    :: Use choiceNum for referencing the key
    for /f "delims=" %%A in ('powershell -NoProfile -Command "(Get-Content '%keyFile%' | ConvertFrom-Json).key%choiceNum%.device_key"') do (
        set deviceKey=%%A
        echo [DEBUG] Device key retrieved: !deviceKey!
    )

    :: Debugging: Check if deviceKey is set
    if defined deviceKey (
        echo [DEBUG] Device key successfully retrieved: !deviceKey!
    ) else (
        echo [DEBUG] Error: Device key not found for Key%choice%. >> "%logFile%"
        exit /b
    )
) else (
    echo [DEBUG] Invalid choice: %choice% >> "%logFile%"
    echo Invalid choice. Please enter a number between 1 and 100.
    exit /b
)

:: Update the configs.json file with the selected device key
echo [DEBUG] Updating configs.json with device key...
powershell -NoProfile -Command "(Get-Content '%configFile%' | ConvertFrom-Json | ForEach-Object { $_.device_key = '%deviceKey%'; $_ } | ConvertTo-Json | Set-Content '%configFile%')"

echo configs.json has been updated with the selected device key.
pause

