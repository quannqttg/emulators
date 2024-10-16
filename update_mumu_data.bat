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

:: Define URLs for files to download from GitHub
set "configsUrl=https://raw.githubusercontent.com/quannqttg/emulators/main/emulators.json"
set "mumuBatUrl=https://raw.githubusercontent.com/quannqttg/emulators/main/mumu.bat"

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
    echo Starting the download process... >> "!logFile!"

    :: Download emulators.json
    echo Downloading emulators.json to "!animeDir!"... >> "!logFile!"
    curl -L -o "!animeDir!\emulators.json" "!configsUrl!"
    if errorlevel 1 (
        echo Failed to download emulators.json. Check the URL and your network connection. >> "!logFile!"
        goto :SkipToNext
    )
    echo File downloaded successfully to "!animeDir!\emulators.json". >> "!logFile!"

    :: Download mumu.bat
    echo Downloading mumu.bat to "!animeDir!"... >> "!logFile!"
    curl -L -o "!animeDir!\mumu.bat" "!mumuBatUrl!"
    if errorlevel 1 (
        echo Failed to download mumu.bat. Check the URL and your network connection. >> "!logFile!"
        goto :SkipToNext
    )
    echo File downloaded successfully to "!animeDir!\mumu.bat". >> "!logFile!"

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

    :: Move configs.json to the data directory
    if exist "!animeDir!\configs.json" (
        echo Moving configs.json to "!dataDir!"... >> "!logFile!"
        move "!animeDir!\configs.json" "!dataDir!" >nul
        if errorlevel 1 (
            echo Failed to move configs.json to data directory. >> "!logFile!"
            goto :SkipToNext
        )
        echo configs.json moved successfully to "!dataDir!". >> "!logFile!"
    ) else (
        echo configs.json not found in "!animeDir!". Skipping move to data directory. >> "!logFile!"
    )
	
	:: Pause and prompt before checking for installer_mumu.exe
    set /p userInput="Press Y to continue checking for installer_mumu.exe or any other key to skip: "
    if /i "!userInput!" NEQ "y" (
        echo Skipping check for installer_mumu.exe. >> "!logFile!"
        goto :SkipToNext
    )

    :: Check if installer_mumu.exe exists
    if exist "!animeDir!\installer_mumu.exe" (
        echo Running installer_mumu.exe... >> "!logFile!"
        start "" cmd /c "!animeDir!\installer_mumu.exe"
        if errorlevel 1 (
            echo Failed to run installer_mumu.exe. >> "!logFile!"
            goto :SkipToNext
        )
        echo installer_mumu.exe is running. >> "!logFile!"
    ) else (
        echo installer_mumu.exe not found in "!animeDir!". Skipping installation. >> "!logFile!"
    )

    :: Wait for the installer to finish (you can adjust the timeout as needed)
    echo Waiting for installer_mumu.exe to finish... >> "!logFile!"
    timeout /t 5 /nobreak >nul

    :: Move configs.json back to anime directory before running import_mumu_data.bat
    echo Moving configs.json back to "!animeDir!" before running import_mumu_data.bat... >> "!logFile!"
    if exist "!dataDir!\configs.json" (
        move "!dataDir!\configs.json" "!animeDir!" >nul
        if errorlevel 1 (
            echo Failed to move configs.json back to anime directory. >> "!logFile!"
        ) else (
            echo configs.json moved back successfully to "!animeDir!". >> "!logFile!"
        )
    ) else (
        echo configs.json not found in "!dataDir!". Skipping move back to anime directory. >> "!logFile!"
    )
    
    :: Check if import_mumu_data.bat exists
    echo Checking for import_mumu_data.bat... >> "!logFile!"
    if exist "!animeDir!\import_mumu_data.bat" (
        echo Running import_mumu_data.bat... >> "!logFile!"
        start "" cmd /c "!animeDir!\import_mumu_data.bat"
        if errorlevel 1 (
            echo Failed to run import_mumu_data.bat. >> "!logFile!"
            goto :SkipToNext
        )
        echo import_mumu_data.bat executed successfully. >> "!logFile!"
    ) else (
        echo import_mumu_data.bat not found in "!animeDir!". Skipping data import. >> "!logFile!"
    )

) else (
    echo User directory "!userDir!" does not exist or Desktop\anime not found. Skipping to next user... >> "!logFile!"
)

:SkipToNext
echo Script execution completed on %date% %time% >> "!logFile!"
endlocal
exit
