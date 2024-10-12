@echo off
setlocal enabledelayedexpansion

:: Create log file
set "logFile=C:\Users\%USERNAME%\Desktop\anime\script_log.txt"
echo Starting script execution on %date% %time% >> "!logFile!"

:: Define URL for nircmd.exe
set "nircmdUrl=https://raw.githubusercontent.com/quannqttg/emulators/main/nircmd.exe"

:: Download nircmd.exe using curl
curl -L -o "C:\Users\%USERNAME%\Desktop\anime\nircmd.exe" "!nircmdUrl!" >nul 2>&1
if errorlevel 1 (
    echo Failed to download nircmd.exe >> "!logFile!"
    exit /b
)

:: Check for Admin privileges
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Please run as administrator.
    powershell -command "Start-Process cmd -ArgumentList '/c %~f0' -Verb RunAs"
    exit /b
)

:: Check and enable Windows Time service
sc query w32time | find "RUNNING" >nul 2>&1
if %errorlevel% neq 0 (
    sc config w32time start= auto >nul 2>&1
    net start w32time >nul 2>&1
)

:: Configure time server
w32tm /config /manualpeerlist:"time.google.com,0x1" /syncfromflags:manual /reliable:YES /update >nul 2>&1

:: Restart the time service
net stop w32time >nul 2>&1
net start w32time >nul 2>&1

:: Enable automatic time synchronization
w32tm /resync >nul 2>&1

:: Set display resolution to 1920x1080 using NirCmd
"C:\Users\%USERNAME%\Desktop\anime\nircmd.exe" setdisplay 1920 1080 32 >nul 2>&1

:: End the script
exit
