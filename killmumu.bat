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
set "killBatURL=https://raw.githubusercontent.com/quannqttg/emulators/main/kill.bat"
set "recallAutoBatURL=https://raw.githubusercontent.com/quannqttg/emulators/main/recall_auto.bat"
set "killBatDest=%animeDir%\kill.bat"
set "recallAutoBatDest=%animeDir%\recall_auto.bat"

:: Check for anime directory
if not exist "%animeDir%" (
    echo Anime directory not found, creating directory... >> "%logFile%"
    mkdir "%animeDir%"
) else (
    echo Anime directory exists. >> "%logFile%"
)

:menu
cls
:: Log menu options
echo ======================= >> "%logFile%"
echo 1. Delete files, download emulators.json, and download kill.bat >> "%logFile%"
echo 2. Skip deletion and run autoRelaunch_mumu.bat after countdown, also download recall_auto.bat >> "%logFile%"
echo 3. Exit >> "%logFile%"
echo ======================= >> "%logFile%"
echo. >> "%logFile%"

echo ===============================
echo         MAIN MENU
echo ===============================
echo 1. Delete files, download emulators.json, and download kill.bat
echo 2. Skip deletion and run autoRelaunch_mumu.bat after countdown, also download recall_auto.bat
echo 3. Exit the script
echo ===============================

set /p choice="Please select an option (1-3): "

:: Handle user choice
if "%choice%"=="1" (
    echo Option 1 selected: Downloading and executing kill.bat >> "%logFile%"

    :: Download kill.bat
    echo Downloading kill.bat... >> "%logFile%"
    curl -L -o "%killBatDest%" "%killBatURL%"

    :: Check if the file was downloaded successfully
    if errorlevel 1 (
        echo Failed to download kill.bat. >> "%logFile%"
    ) else (
        echo kill.bat downloaded successfully to: %killBatDest% >> "%logFile%"
        start "" /wait cmd /c "%killBatDest%"
        del "%killBatDest%"
        echo kill.bat executed and deleted. >> "%logFile%"
    )
    goto menu

) else if "%choice%"=="2" (
    echo Option 2 selected: Downloading and executing recall_auto.bat >> "%logFile%"

    :: Download recall_auto.bat
    echo Downloading recall_auto.bat... >> "%logFile%"
    curl -L -o "%recallAutoBatDest%" "%recallAutoBatURL%"

    :: Check if the file was downloaded successfully
    if errorlevel 1 (
        echo Failed to download recall_auto.bat. >> "%logFile%"
    ) else (
        echo recall_auto.bat downloaded successfully to: %recallAutoBatDest% >> "%logFile%"
        start "" /wait cmd /c "%recallAutoBatDest%"
        del "%recallAutoBatDest%"
        echo recall_auto.bat executed and deleted. >> "%logFile%"
    )
    goto menu

) else if "%choice%"=="3" (
    echo Exiting the script... >> "%logFile%"
    exit /b

) else (
    echo Invalid option. Please try again. >> "%logFile%"
    goto menu
)
