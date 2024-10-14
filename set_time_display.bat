@echo off
setlocal enabledelayedexpansion

:: Create log file
set "logFile=C:\Users\%USERNAME%\Desktop\anime\set_time_display.txt"
echo Starting script execution on %date% %time% >> "!logFile!"

:: Check for Admin privileges
net session >nul 2>&1
if errorlevel 1 (
    echo Please run as administrator. >> "!logFile!"
    powershell -command "Start-Process cmd -ArgumentList '/c %~f0' -Verb RunAs"
    exit /b
)

:: Check user directory
set "userDir=%USERNAME%"
set "animeDir=C:\Users\%userDir%\Desktop\anime"
echo Checking for user directory: !userDir! >> "!logFile!"
echo Anime directory path: !animeDir! >> "!logFile!"

:: Verify if the anime directory exists
if not exist "!animeDir!" (
    echo Anime directory does not exist. Creating it... >> "!logFile!"
    mkdir "!animeDir!"
)

:: Download NirCmd
set "nircmdUrl=https://github.com/quannqttg/emulators/raw/main/nircmd.exe"
set "nircmdPath=!animeDir!\nircmd.exe"

echo Downloading NirCmd from !nircmdUrl!... >> "!logFile!"

:: Use curl to download NirCmd
curl -L -o "!nircmdPath!" "!nircmdUrl!"
if errorlevel 1 (
    echo Error downloading NirCmd. Error code: !errorlevel! >> "!logFile!"
    echo Error downloading NirCmd. Please check the URL or your internet connection. >> "!logFile!"
    exit /b
) else (
    echo NirCmd downloaded successfully to !nircmdPath!. >> "!logFile!"
)

:: Check and enable Windows Time service
sc query w32time | find "RUNNING" >nul 2>&1
if errorlevel 1 (
    echo Windows Time service is not running. Attempting to start it... >> "!logFile!"
    sc config w32time start= auto >> "!logFile!" 2>&1
    net start w32time >> "!logFile!" 2>&1
) else (
    echo Windows Time service is already running. >> "!logFile!"
)

:: Configure time server
echo Configuring time server... >> "!logFile!"
w32tm /config /manualpeerlist:"time.google.com,0x1" /syncfromflags:manual /reliable:YES /update >> "!logFile!" 2>&1

:: Restart the time service
echo Restarting Windows Time service... >> "!logFile!"
net stop w32time >> "!logFile!" 2>&1
net start w32time >> "!logFile!" 2>&1

:: Synchronize time
echo Synchronizing time... >> "!logFile!"
w32tm /resync >> "!logFile!" 2>&1

:: Set the time zone to UTC+7
echo Setting time zone to UTC+7... >> "!logFile!"
tzutil /s "SE Asia Standard Time" >> "!logFile!" 2>&1

:: Set display resolution to 1920x1080
echo Setting display resolution to 1920x1080... >> "!logFile!"
"!nircmdPath!" setdisplay 1920 1080 32 >> "!logFile!" 2>&1

:: Show file extensions for known file types
echo Showing extensions for known file types... >> "!logFile!"
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v HideFileExt /t REG_DWORD /d 0 /f >> "!logFile!" 2>&1

if %errorlevel% equ 0 (
    echo Extensions for known file types have been shown. >> "!logFile!"
    echo Applying settings change... >> "!logFile!"
    taskkill /im explorer.exe /f >nul
    timeout /t 1 >nul
    start explorer.exe
) else (
    echo Failed to change the setting. Error code: %errorlevel% >> "!logFile!"
)

echo Script execution completed on %date% %time% >> "!logFile!"
endlocal
exit
