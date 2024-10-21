@echo off
setlocal enabledelayedexpansion

:: Set the current username and define paths for anime directory and log file
set "userDir=%USERNAME%"
set "animeDir=C:\Users\%userDir%\Desktop\anime"
set "logFile=%animeDir%\killmumu.log"

echo Starting disk space check and recloning process...
echo %date% %time% - killmumu.bat is running >> "%logFile%"

REM Check for administrative privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting administrative privileges... >> "%logFile%"
    powershell -command "Start-Process cmd -ArgumentList '/c %~f0' -Verb RunAs"
    exit /b
) else (
    echo Admin privileges confirmed. >> "%logFile%"
)

REM Check for PowerShell presence
where powershell >nul 2>&1
if errorlevel 1 (
    echo PowerShell not found. Exiting... >> "%logFile%"
    exit /b 1
) else (
    echo PowerShell is available. >> "%logFile%"
)

:menu
cls
echo.
echo ===============================
echo         MAIN MENU
echo ===============================
echo 1. Delete the files and proceed with the download
echo 2. Skip deletion, run autoRelaunch_mumu.bat after countdown
echo 3. Exit the script
echo ===============================
set /p choice="Please select an option (1-3): "

if "%choice%"=="1" (
    goto proceed
) else if "%choice%"=="2" (
    goto delayAndRun
) else if "%choice%"=="3" (
    echo Exiting... >> "%logFile%"
    pause
    exit
) else (
    echo Invalid option, please try again. >> "%logFile%"
    goto menu
)

:proceed
echo [DEBUG] Proceeding with file deletion and Temp cleanup... >> "%logFile%"

:: Delete all files in Temporary Files folder
set "tempFolder=%temp%"
echo Deleting all files in Temp folder... >> "%logFile%"
echo Deleting all files in Temp folder...
cd /d "%temp%"
del /f /s /q *.* >nul 2>&1
for /d %%i in (*) do rmdir /s /q "%%i" >> "%logFile%" 2>&1
echo Temp folder cleaned. >> "%logFile%"

:: Perform deletion of specific folders and files
set "targetDir=C:\Program Files\Netease\MuMuPlayerGlobal-12.0\vms"
if exist "!targetDir!" (
    echo Deleting contents in "!targetDir!"... >> "%logFile%"
    echo Deleting contents in "!targetDir!"...
    
    REM Loop through directories in the target directory
    for /d %%i in ("!targetDir!\*") do (
        if /i not "%%~nxi"=="MuMuPlayerGlobal-12.0-base" if /i not "%%~nxi"=="MuMuPlayerGlobal-12.0-0" (
            echo Deleting folder %%i... >> "%logFile%"
            echo Deleting folder %%i...
            rmdir /s /q "%%i"
            echo Deleted folder %%i >> "%logFile%"
        )
    )
    
    REM Loop through files in the target directory
    for %%i in ("!targetDir!\*") do (
        echo Deleting file %%i... >> "%logFile%"
        echo Deleting file %%i...
        del /q "%%i"
        echo Deleted file %%i >> "%logFile%"
    )
) else (
    echo Target directory does not exist. Exiting... >> "%logFile%"
    exit /b 1
)

:: Download emulators.json file from GitHub
set "jsonSource=https://raw.githubusercontent.com/quannqttg/emulators/main/emulators.json"
set "jsonDest=%animeDir%\data\emulators.json"
if not exist "%animeDir%\data" (
    mkdir "%animeDir%\data" >> "%logFile%"
    echo Created data directory. >> "%logFile%"
)

echo Downloading emulators.json from GitHub... >> "%logFile%"
echo Downloading emulators.json from GitHub...
curl -L -o "!jsonDest!" "!jsonSource!"
if errorlevel 1 (
    echo Failed to download emulators.json. Exiting... >> "%logFile%"
    exit /b 1
)
echo Download completed successfully! >> "%logFile%"
echo Download completed successfully!

:: Return to menu after processing
goto menu

:delayAndRun
:: Add a 10-second countdown before running autoRelaunch_mumu.bat
echo Waiting for 10 seconds before running autoRelaunch_mumu.bat... >> "%logFile%"
echo Waiting for 10 seconds before running autoRelaunch_mumu.bat...
for /L %%i in (10,-1,1) do (
    echo Starting in %%i seconds...
    timeout /t 1 >nul
)
echo Proceeding to run autoRelaunch_mumu.bat... >> "%logFile%"
echo Proceeding to run autoRelaunch_mumu.bat...

:: Navigate to the anime directory and run autoRelaunch_mumu.bat
cd "%animeDir%" || exit /b 1
if not exist "autoRelaunch_mumu.bat" (
    echo File autoRelaunch_mumu.bat does not exist. Exiting... >> "%logFile%"
    exit /b 1
)
echo Running autoRelaunch_mumu.bat... >> "%logFile%"
call autoRelaunch_mumu.bat || exit /b 1
echo All operations completed successfully! >> "%logFile%"

:: Return to menu after running the batch file
goto menu

:exitScript
echo Exiting the script as per user request... >> "%logFile%"
exit
