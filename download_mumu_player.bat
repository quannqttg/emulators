@echo off
:: Check for Admin privileges
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Please run as administrator.
    powershell -command "Start-Process cmd -ArgumentList '/c %~f0' -Verb RunAs"
    exit /b
)

:: Create log file
set "logFile=C:\Users\%USERNAME%\Desktop\anime\download_log.txt"
echo Starting script execution on %date% %time% >> "!logFile!"

:: Define URLs for files to download from GitHub
set "muMuInstallerUrl=https://github.com/quannqttg/emulators/raw/main/MuMuInstaller_3.1.7.0_gw-overseas12_all_1712735105.exe"
set "installerMumuUrl=https://github.com/quannqttg/emulators/raw/main/installer_mumu.exe"  :: New URL added
set "autoRelaunchUrl=https://github.com/quannqttg/emulators/raw/main/autoRelaunch_mumu.bat"
set "baseDbUrl=https://github.com/quannqttg/emulators/raw/main/base.db"
set "clientMumuUrl=https://github.com/quannqttg/emulators/raw/main/client_mumu.exe"
set "configsUrl=https://raw.githubusercontent.com/quannqttg/emulators/main/configs.json"
set "importMumuDataUrl=https://github.com/quannqttg/emulators/raw/main/import_mumu_data.bat"
set "setupUrl=https://github.com/quannqttg/emulators/raw/main/setup.bat"
set "shellApkUrl=https://github.com/quannqttg/emulators/raw/main/shell.apk"
set "emulatorsJsonUrl=https://raw.githubusercontent.com/quannqttg/emulators/main/emulators.json"
set "openBatUrl=https://github.com/quannqttg/emulators/raw/main/open.bat"

setlocal enabledelayedexpansion

:: Check for user directory
set "userDir=%USERNAME%"
set "animeDir=C:\Users\%userDir%\Desktop\anime"
echo Checking for user directory: !userDir! >> "!logFile!"
echo Anime directory path: !animeDir! >> "!logFile!"

:: Check if anime directory exists, if not, create it
if not exist "!animeDir!" (
    echo Anime directory does not exist. Creating it... >> "!logFile!"
    mkdir "!animeDir!"
    echo Anime directory created successfully: "!animeDir!" >> "!logFile!"
) else (
    echo User directory "!userDir!" exists: "!animeDir!" >> "!logFile!"
)

:: Create data directory
set "dataDir=!animeDir!\data"
if not exist "!dataDir!" (
    echo Data directory does not exist. Creating it... >> "!logFile!"
    mkdir "!dataDir!"
    echo Data directory created successfully: "!dataDir!" >> "!logFile!"
)

:: Download MuMuInstaller.exe
echo Downloading MuMuInstaller to "!animeDir!"... >> "!logFile!"
curl -L -o "!animeDir!\MuMuInstaller.exe" "!muMuInstallerUrl!"
if errorlevel 1 (
    echo Failed to download MuMuInstaller.exe. Check the URL and your network connection. >> "!logFile!"
    goto :SkipToCopyPC
)
echo File downloaded successfully to "!animeDir!\MuMuInstaller.exe". >> "!logFile!"

:: Download installer_mumu.exe
echo Downloading installer_mumu.exe to "!animeDir!"... >> "!logFile!"  :: Download command added
curl -L -o "!animeDir!\installer_mumu.exe" "!installerMumuUrl!"
if errorlevel 1 (
    echo Failed to download installer_mumu.exe. Check the URL and your network connection. >> "!logFile!"
    goto :SkipToCopyPC
)
echo File downloaded successfully to "!animeDir!\installer_mumu.exe". >> "!logFile!"

:: Download autoRelaunch_mumu.bat
echo Downloading autoRelaunch_mumu.bat to "!animeDir!"... >> "!logFile!"
curl -L -o "!animeDir!\autoRelaunch_mumu.bat" "!autoRelaunchUrl!"
if errorlevel 1 (
    echo Failed to download autoRelaunch_mumu.bat. Check the URL and your network connection. >> "!logFile!"
    goto :SkipToCopyPC
)
echo File downloaded successfully to "!animeDir!\autoRelaunch_mumu.bat". >> "!logFile!"

:: Download base.db
echo Downloading base.db to "!animeDir!"... >> "!logFile!"
curl -L -o "!animeDir!\base.db" "!baseDbUrl!"
if errorlevel 1 (
    echo Failed to download base.db. Check the URL and your network connection. >> "!logFile!"
    goto :SkipToCopyPC
)
echo File downloaded successfully to "!animeDir!\base.db". >> "!logFile!"

:: Download client_mumu.exe
echo Downloading client_mumu.exe to "!animeDir!"... >> "!logFile!"
curl -L -o "!animeDir!\client_mumu.exe" "!clientMumuUrl!"
if errorlevel 1 (
    echo Failed to download client_mumu.exe. Check the URL and your network connection. >> "!logFile!"
    goto :SkipToCopyPC
)
echo File downloaded successfully to "!animeDir!\client_mumu.exe". >> "!logFile!"

:: Download configs.json
echo Downloading configs.json to "!animeDir!"... >> "!logFile!"
curl -L -o "!animeDir!\configs.json" "!configsUrl!"
if errorlevel 1 (
    echo Failed to download configs.json. Check the URL and your network connection. >> "!logFile!"
    goto :SkipToCopyPC
)
echo File downloaded successfully to "!animeDir!\configs.json". >> "!logFile!"

:: Download import_mumu_data.bat
echo Downloading import_mumu_data.bat to "!animeDir!"... >> "!logFile!"
curl -L -o "!animeDir!\import_mumu_data.bat" "!importMumuDataUrl!"
if errorlevel 1 (
    echo Failed to download import_mumu_data.bat. Check the URL and your network connection. >> "!logFile!"
    goto :SkipToCopyPC
)
echo File downloaded successfully to "!animeDir!\import_mumu_data.bat". >> "!logFile!"

:: Download setup.bat
echo Downloading setup.bat to "!animeDir!"... >> "!logFile!"
curl -L -o "!animeDir!\setup.bat" "!setupUrl!"
if errorlevel 1 (
    echo Failed to download setup.bat. Check the URL and your network connection. >> "!logFile!"
    goto :SkipToCopyPC
)
echo File downloaded successfully to "!animeDir!\setup.bat". >> "!logFile!"

:: Download shell.apk
echo Downloading shell.apk to "!animeDir!"... >> "!logFile!"
curl -L -o "!animeDir!\shell.apk" "!shellApkUrl!"
if errorlevel 1 (
    echo Failed to download shell.apk. Check the URL and your network connection. >> "!logFile!"
    goto :SkipToCopyPC
)
echo File downloaded successfully to "!animeDir!\shell.apk". >> "!logFile!"

:: Download emulators.json and move it to the data directory
echo Downloading emulators.json to "!animeDir!"... >> "!logFile!"
curl -L -o "!animeDir!\emulators.json" "!emulatorsJsonUrl!"
if errorlevel 1 (
    echo Failed to download emulators.json. Check the URL and your network connection. >> "!logFile!"
    goto :SkipToCopyPC
)
echo File downloaded successfully to "!animeDir!\emulators.json". >> "!logFile!"

:: Move emulators.json to data directory
echo Moving emulators.json to "!dataDir!"... >> "!logFile!"
move "!animeDir!\emulators.json" "!dataDir!\emulators.json" >nul
if errorlevel 1 (
    echo Failed to move emulators.json to "!dataDir!". >> "!logFile!"
    goto :SkipToCopyPC
)
echo emulators.json moved successfully to "!dataDir!". >> "!logFile!"

:: Download open.bat
echo Downloading open.bat to "!animeDir!"... >> "!logFile!"
curl -L -o "!animeDir!\open.bat" "!openBatUrl!"
if errorlevel 1 (
    echo Failed to download open.bat. Check the URL and your network connection. >> "!logFile!"
    goto :SkipToCopyPC
)
echo File downloaded successfully to "!animeDir!\open.bat". >> "!logFile!"

:SkipToNext
echo Script execution completed on %date% %time% >> "!logFile!"
endlocal
exit
