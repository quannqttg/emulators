@echo off
setlocal enabledelayedexpansion

:: Create log file
set "logFile=C:\Users\%USERNAME%\Desktop\anime\bandwidth.log"
echo Starting bandwidth monitor on %date% %time% >> "!logFile!"

:: Download qos_bandwidth_manager.py if it doesn't exist
set "bandwidthScript=C:\Users\%USERNAME%\Desktop\anime\qos_bandwidth_manager.py"
if not exist "!bandwidthScript!" (
    echo Downloading qos_bandwidth_manager.py... >> "!logFile!"
    curl -L -o "!bandwidthScript!" https://github.com/quannqttg/emulators/raw/main/qos_bandwidth_manager.py
    if %ERRORLEVEL% neq 0 (
        echo Failed to download qos_bandwidth_manager.py. Exiting... >> "!logFile!"
        exit /b 1
    )
    echo qos_bandwidth_manager.py downloaded successfully. >> "!logFile!"
)

:: Run qos_bandwidth_manager.py in a new window
start cmd /k "python "!bandwidthScript!""

echo Bandwidth monitor started successfully. >> "!logFile!"
endlocal
exit /b 0
