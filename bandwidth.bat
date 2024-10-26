@echo off
setlocal enabledelayedexpansion

:: Check for Admin privileges
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Please run as administrator.
    powershell -command "Start-Process cmd -ArgumentList '/c %~f0' -Verb RunAs"
    exit /b
)

:: Create log file
set "logFile=C:\Users\%USERNAME%\Desktop\anime\bandwidth.log"
echo Starting script execution on %date% %time% >> "!logFile!"

:: Variables
set PYTHON_INSTALLER=https://github.com/quannqttg/emulators/raw/main/python-3.1.2.msi
set PSUTIL_INSTALLER=python -m pip install psutil
set BANDWIDTH_MONITOR=https://github.com/quannqttg/emulators/raw/main/bandwidth_monitor.py

:: Download Python installer
echo Downloading Python installer... >> "!logFile!"
curl -L -o python-installer.msi %PYTHON_INSTALLER%
if %ERRORLEVEL% neq 0 (
    echo Failed to download Python installer. >> "!logFile!"
    exit /b 1
)

:: Install Python
echo Installing Python... >> "!logFile!"
msiexec /i python-installer.msi /quiet
if %ERRORLEVEL% neq 0 (
    echo Python installation failed. >> "!logFile!"
    exit /b 1
)

:: Install psutil
echo Installing psutil... >> "!logFile!"
%PSUTIL_INSTALLER%
if %ERRORLEVEL% neq 0 (
    echo Failed to install psutil. >> "!logFile!"
    exit /b 1
)

:: Download bandwidth_monitor.py
echo Downloading bandwidth_monitor.py... >> "!logFile!"
curl -L -o bandwidth_monitor.py %BANDWIDTH_MONITOR%
if %ERRORLEVEL% neq 0 (
    echo Failed to download bandwidth_monitor.py. >> "!logFile!"
    exit /b 1
)

:: Run bandwidth_monitor.py
echo Running bandwidth_monitor.py... >> "!logFile!"
python bandwidth_monitor.py
if %ERRORLEVEL% neq 0 (
    echo Failed to run bandwidth_monitor.py. >> "!logFile!"
    exit /b 1
)

echo All operations completed successfully. >> "!logFile!"
endlocal
exit /b 0
