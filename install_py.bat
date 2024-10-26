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
set "logFile=C:\Users\%USERNAME%\Desktop\anime\install.log"
echo Starting Python installation on %date% %time% >> "!logFile!"

:: Variables
set PYTHON_INSTALLER=https://www.python.org/ftp/python/3.12.7/python-3.12.7-amd64.exe
set PSUTIL_INSTALLER=python -m pip install psutil

:: Download Python installer
echo Downloading Python installer... >> "!logFile!"
curl -L -o python-installer.exe %PYTHON_INSTALLER%
if %ERRORLEVEL% neq 0 (
    echo Failed to download Python installer. Exiting... >> "!logFile!"
    exit /b 1
)

:: Install Python
echo Installing Python... >> "!logFile!"
start /wait python-installer.exe /quiet InstallAllUsers=1 PrependPath=1 Include_test=0
set INSTALL_EXIT_CODE=%ERRORLEVEL%
if %INSTALL_EXIT_CODE% neq 0 (
    echo Python installation failed with exit code %INSTALL_EXIT_CODE%. Exiting... >> "!logFile!"
    exit /b 1
)

:: Verify Python installation
echo Verifying Python installation... >> "!logFile!"
python --version >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo Python is not accessible. Exiting... >> "!logFile!"
    exit /b 1
)

:: Install pip if not already available
echo Checking for pip installation... >> "!logFile!"
python -m ensurepip >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo Pip installation failed. Exiting... >> "!logFile!"
    exit /b 1
)

:: Upgrade pip to the latest version
echo Upgrading pip... >> "!logFile!"
python -m pip install --upgrade pip >> "!logFile!" 2>&1
if %ERRORLEVEL% neq 0 (
    echo Failed to upgrade pip. Exiting... >> "!logFile!"
    exit /b 1
)

:: Install psutil
echo Installing psutil... >> "!logFile!"
%PSUTIL_INSTALLER% >> "!logFile!" 2>&1
if %ERRORLEVEL% neq 0 (
    echo Failed to install psutil. Exiting... >> "!logFile!"
    exit /b 1
)

echo Python and required modules installed successfully. >> "!logFile!"
endlocal
exit /b 0
