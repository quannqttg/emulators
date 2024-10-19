@echo off
setlocal enabledelayedexpansion

:: Set the paths to the config files
set configFile=configs.json
set keyFile=allkey.json

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
    echo [DEBUG] Invalid choice: Input is empty.
    echo Invalid choice. Please enter a number between 1 and 100.
    exit /b
)

:: Check if the user choice is a valid number between 1 and 100
for /f "delims=0123456789" %%A in ("%choiceNum%") do (
    echo [DEBUG] Invalid choice: Not a number.
    echo Invalid choice. Please enter a number between 1 and 100.
    exit /b
)

set /a choiceNum=choiceNum
if %choiceNum% geq 1 if %choiceNum% leq 100 (
    echo [DEBUG] Valid choice detected: %choice%

    :: Use choiceNum for referencing the key
    for /f "delims=" %%A in ('powershell -NoProfile -Command "(Get-Content %keyFile% | ConvertFrom-Json).key%choiceNum%.device_key"') do (
        set deviceKey=%%A
        echo [DEBUG] Device key retrieved: !deviceKey!
    )

    :: Debugging: Check if deviceKey is set
    if defined deviceKey (
        echo [DEBUG] Device key successfully retrieved: !deviceKey!
    ) else (
        echo [DEBUG] Error: Device key not found for Key%choice%.
        exit /b
    )
) else (
    echo [DEBUG] Invalid choice: %choice%
    echo Invalid choice. Please enter a number between 1 and 100.
    exit /b
)

:: Update the configs.json file with the selected device key
echo [DEBUG] Updating configs.json with device key...
powershell -NoProfile -Command "(Get-Content '%configFile%' | ConvertFrom-Json | ForEach-Object { $_.device_key = '%deviceKey%'; $_ } | ConvertTo-Json | Set-Content '%configFile%')"

echo configs.json has been updated with the selected device key.
pause
