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

:: Call delete and download routine
call :deleteAndDownload
exit /b

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
