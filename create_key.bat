@echo off
setlocal

:: Define paths for files
set "userDir=%USERNAME%"
set "animeDir=C:\Users\%userDir%\Desktop\anime"
set "logfile=create_key.log"

:: Check if key.json exists and delete it if it does
if exist "%animeDir%\key.json" (
    echo [%date% %time%] key.json exists. Deleting... >> %logfile%
    del "%animeDir%\key.json"
    if %errorlevel% neq 0 (
        echo [%date% %time%] Error: Failed to delete key.json. >> %logfile%
    ) else (
        echo [%date% %time%] key.json deleted successfully. >> %logfile%
    )
)

:: Download allkey.json using curl
echo [%date% %time%] Downloading allkey.json... >> %logfile%
curl -L -o "%animeDir%\allkey.json" https://raw.githubusercontent.com/quannqttg/emulators/main/allkey.json
if %errorlevel% neq 0 (
    echo [%date% %time%] Error: Failed to download allkey.json. >> %logfile%
    exit /b
)

echo [%date% %time%] Download successful. >> %logfile%

echo Please choose an option (1 to 100):
set /p choice=

:: Validate that the choice is a number between 1 and 100
if %choice% lss 1 (
    echo [%date% %time%] Invalid choice: %choice%. Please enter a number between 1 and 100. >> %logfile%
    echo Invalid choice. Please enter a number between 1 and 100.
    exit /b
) else if %choice% gtr 100 (
    echo [%date% %time%] Invalid choice: %choice%. Please enter a number between 1 and 100. >> %logfile%
    echo Invalid choice. Please enter a number between 1 and 100.
    exit /b
)

:: Build the key dynamically based on the choice
set "jsonKey=key%choice%"

:: Extract the device_key from allkey.json using PowerShell
echo [%date% %time%] Extracting device_key for %jsonKey%... >> %logfile%
for /f "delims=" %%A in ('powershell -NoProfile -Command "(Get-Content '%animeDir%\allkey.json' | ConvertFrom-Json).%jsonKey%.device_key"') do set deviceKey=%%A

:: Check if deviceKey was retrieved successfully
if "%deviceKey%"=="" (
    echo [%date% %time%] Error: Could not retrieve device key for %jsonKey%. >> %logfile%
    echo Error: Could not retrieve device key for %jsonKey%.
    exit /b
)

:: Output the retrieved device key
echo [%date% %time%] Selected device key: %deviceKey% >> %logfile%
echo Selected device key: %deviceKey%

:: Create a new key.json file with the selected device_key
(
    echo {
    echo     "device_key": "%deviceKey%"
    echo }
) > "%animeDir%\key.json"

:: Confirmation message
echo [%date% %time%] key.json has been created with the selected device key. >> %logfile%
echo key.json has been created with the selected device key.

:: Delete allkey.json
del "%animeDir%\allkey.json"
if %errorlevel% neq 0 (
    echo [%date% %time%] Error: Failed to delete allkey.json. >> %logfile%
) else (
    echo [%date% %time%] Deleted allkey.json successfully. >> %logfile%
)

endlocal
exit /b
