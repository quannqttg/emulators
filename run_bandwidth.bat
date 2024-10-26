@echo off
setlocal enabledelayedexpansion

:: Create log file
set "logFile=C:\Users\%USERNAME%\Desktop\anime\bandwidth.log"
echo Starting bandwidth monitor on %date% %time% >> "!logFile!"

:: Run bandwidth_monitor.py in a new window
start cmd /k "python C:\Users\%USERNAME%\Desktop\anime\bandwidth_monitor.py"

echo Bandwidth monitor started successfully. >> "!logFile!"
endlocal
exit /b 0
