@echo off
setlocal enabledelayedexpansion

REM Set user variable to the current username
set "userr=%USERNAME%"

REM Set log file name
set "logFile=play.log"
SET KEY="HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters"

REM Step 1: Check for administrative privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [DEBUG] No admin privileges detected. Requesting administrative privileges...
    echo Requesting administrative privileges... >> "%logFile%"
    powershell -command "Start-Process cmd -ArgumentList '/c %~f0' -Verb RunAs"
    exit /b
) else (
    echo [DEBUG] Admin privileges confirmed.
    echo Admin privileges confirmed. >> "%logFile%"
)

REM Check if network is stable
ping -n 4 8.8.8.8 > nul
if %errorlevel% == 0 (
    echo Network appears stable. >> "%logFile%"
    
    REM Download checknetwork.bat using curl
    echo Downloading checknetwork.bat... >> "%logFile%"
    curl -L -o checknetwork.bat https://raw.githubusercontent.com/quannqttg/emulators/main/checknetwork.bat
    if %ERRORLEVEL% neq 0 (
        echo Failed to download checknetwork.bat. >> "%logFile%"
        exit /b
    )

    REM Run checknetwork.bat in hidden mode using PowerShell
    echo Running checknetwork.bat in hidden mode at %date% %time% >> "%logFile%"
    start "" powershell -WindowStyle Hidden -Command "Start-Process 'cmd.exe' -ArgumentList '/c checknetwork.bat';"

) else (
    echo Network still unstable. >> "%logFile%"
)

REM Pause for 10 seconds before running autoRelaunch_mumu.bat
echo Pausing for 10 seconds before running autoRelaunch_mumu.bat at %date% %time% >> "%logFile%"
TIMEOUT /T 10

REM Log the time of running autoRelaunch_mumu.bat
echo Running autoRelaunch_mumu.bat at %date% %time% >> "%logFile%"
start cmd /c "autoRelaunch_mumu.bat"

REM End of script and close play.bat
echo Script completed at %date% %time% >> "%logFile%"
exit /b
