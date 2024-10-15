@echo off
:: Check for Admin privileges
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Please run as administrator.
    powershell -command "Start-Process cmd -ArgumentList '/c %~f0' -Verb RunAs"
    exit /b
)

:: Create log file
set "logFile=C:\Users\%USERNAME%\Desktop\anime\update_log.txt"
echo Starting script execution on %date% %time% >> "!logFile!"

:: Define URL for the new file to download from GitHub
set "configsUrl=https://raw.githubusercontent.com/quannqttg/emulators/main/emulators.json"

setlocal enabledelayedexpansion

:: Check for user directory
set "userDir=%USERNAME%"
set "animeDir=C:\Users\%userDir%\Desktop\anime"
set "dataDir=C:\Users\%userDir%\Desktop\anime\data"  :: Define the destination directory for emulators.json
echo Checking for user directory: !userDir! >> "!logFile!"
echo Anime directory path: !animeDir! >> "!logFile!"
echo Data directory path: !dataDir! >> "!logFile!"

if exist "!animeDir!" (
    echo User directory "!userDir!" exists: "!animeDir!" >> "!logFile!"

    :: Download emulators.json
    echo Downloading emulators.json to "!animeDir!"... >> "!logFile!"
    curl -L -o "!animeDir!\emulators.json" "!configsUrl!"
    if errorlevel 1 (
        echo Failed to download emulators.json. Check the URL and your network connection. >> "!logFile!"
        goto :SkipToNext
    )
    echo File downloaded successfully to "!animeDir!\emulators.json". >> "!logFile!"

    :: Move emulators.json to the data directory
    if not exist "!dataDir!" (
        echo Data directory does not exist. Creating it... >> "!logFile!"
        mkdir "!dataDir!"
    )
    echo Moving emulators.json to "!dataDir!"... >> "!logFile!"
    move "!animeDir!\emulators.json" "!dataDir!" >nul
    if errorlevel 1 (
        echo Failed to move emulators.json to data directory. >> "!logFile!"
        goto :SkipToNext
    )
    echo emulators.json moved successfully to "!dataDir!". >> "!logFile!"

    :: Run installer_mumu.exe in a new window
    echo Running installer_mumu.exe... >> "!logFile!"
    start "" cmd /c "!animeDir!\installer_mumu.exe"
    if errorlevel 1 (
        echo Failed to run installer_mumu.exe. >> "!logFile!"
        goto :SkipToNext
    )
    echo installer_mumu.exe is running. >> "!logFile!"

    :: Wait for the installer to finish (you can adjust the timeout as needed)
    echo Waiting for installer_mumu.exe to finish... >> "!logFile!"
    timeout /t 5 /nobreak >nul

    :: Run import_mumu_data.bat in a new window
    echo Running import_mumu_data.bat... >> "!logFile!"
    start "" cmd /c "!animeDir!\import_mumu_data.bat"
    if errorlevel 1 (
        echo Failed to run import_mumu_data.bat. >> "!logFile!"
        goto :SkipToNext
    )
    echo import_mumu_data.bat executed successfully. >> "!logFile!"

) else (
    echo User directory "!userDir!" does not exist or Desktop\anime not found. Skipping to next user... >> "!logFile!"
)

:SkipToNext
echo Script execution completed on %date% %time% >> "!logFile!"
endlocal
exit
