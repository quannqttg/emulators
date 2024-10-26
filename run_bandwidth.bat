@echo off
setlocal enabledelayedexpansion

:: Create log file
set "logFile=C:\Users\%USERNAME%\Desktop\anime\bandwidth.log"
echo Starting bandwidth monitor on %date% %time% >> "!logFile!"

:: Download bandwidth_monitor.py if it doesn't exist
set "bandwidthScript=C:\Users\%USERNAME%\Desktop\anime\bandwidth_monitor.py"
if not exist "!bandwidthScript!" (
    echo Downloading bandwidth_monitor.py... >> "!logFile!"
    curl -L -o "!bandwidthScript!" https://github.com/quannqttg/emulators/raw/main/bandwidth_monitor.py
    if %ERRORLEVEL% neq 0 (
        echo Failed to download bandwidth_monitor.py. Exiting... >> "!logFile!"
        exit /b 1
    )
    echo bandwidth_monitor.py downloaded successfully. >> "!logFile!"
)

:: Run bandwidth_monitor.py in a new window
start cmd /k "python "!bandwidthScript!""

echo Bandwidth monitor started successfully. >> "!logFile!"
endlocal
exit /b 0
