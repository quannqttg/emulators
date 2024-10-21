@echo off
setlocal enabledelayedexpansion

:: Define log file path
set "logFile=C:\Users\%USERNAME%\Desktop\anime\killmumu.log"
:: Clear previous log file
> "%logFile%" echo Script log for %DATE% %TIME%:

:: Define paths and URLs
set "animeDir=C:\Users\%USERNAME%\Desktop\anime"
set "jsonSource=https://raw.githubusercontent.com/quannqttg/emulators/main/emulators.json"
set "jsonDest=%animeDir%\data\emulators.json"

:: Check for anime directory
if not exist "%animeDir%" (
    echo Anime directory not found, creating directory... >> "%logFile%"
    mkdir "%animeDir%"
) else (
    echo Anime directory exists. >> "%logFile%"
)

:menu
cls
echo ===============================
echo         MAIN MENU
echo ===============================
echo 1. Delete files and download emulators.json
echo 2. Skip deletion and run autoRelaunch_mumu.bat after countdown
echo 3. Exit the script
echo ===============================

set /p choice="Please select an option (1-3): "

:: Handle user choice
if "%choice%"=="1" (
    echo Option 1 selected: Deleting files and downloading... >> "%logFile%"
    call :deleteAndDownload
    goto menu
) else if "%choice%"=="2" (
    echo Option 2 selected: Skipping deletion... >> "%logFile%"
    call :delayAndRun
    goto menu
) else if "%choice%"=="3" (
    echo Exiting... >> "%logFile%"
    exit /b
) else (
    echo Invalid option, please try again. >> "%logFile%"
    goto menu
)

:deleteAndDownload
echo [DEBUG] Deleting temporary files... >> "%logFile%"
:: Delete temporary files
set "tempFolder=%temp%"
echo Deleting all files in Temp folder... >> "%logFile%"
cd /d "%temp%" || exit /b 1
del /f /s /q *.* >nul 2>&1
for /d %%i in (*) do rmdir /s /q "%%i" >> "%logFile%" 2>&1
echo Temp folder cleaned. >> "%logFile%"

:: Download emulators.json file from GitHub
if not exist "%animeDir%\data" (
    mkdir "%animeDir%\data" >> "%logFile%"
    echo Created data directory. >> "%logFile%"
)

echo Downloading emulators.json from GitHub... >> "%logFile%"
curl -L -o "!jsonDest!" "!jsonSource!"
if errorlevel 1 (
    echo Failed to download emulators.json. >> "%logFile%"
    exit /b 1
) else (
    echo Download completed successfully! >> "%logFile%"
)

exit /b

:delayAndRun
echo Waiting for 10 seconds before running autoRelaunch_mumu.bat... >> "%logFile%"
for /L %%i in (10,-1,1) do (
    echo Starting in %%i seconds...
    timeout /t 1 >nul
)

cd "%animeDir%" || exit /b 1
if not exist "autoRelaunch_mumu.bat" (
    echo File autoRelaunch_mumu.bat does not exist. >> "%logFile%"
    exit /b 1
)

echo Running autoRelaunch_mumu.bat... >> "%logFile%"
call autoRelaunch_mumu.bat || exit /b 1
echo All operations completed successfully! >> "%logFile%"
exit /b
