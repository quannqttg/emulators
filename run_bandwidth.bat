@echo off
setlocal enabledelayedexpansion

:: Set log file path
set "logFile=C:\Users\%USERNAME%\Desktop\anime\bandwidth.log"
echo Log started on %date% %time% > "!logFile!"

:: Display menu
:Menu
cls
echo ============================================
echo              Bandwidth Monitor
echo ============================================
echo.
echo Select an option:
echo [1] Download and Install Python (install_py.bat)
echo [2] Download and Run Bandwidth Monitor (qos_bandwidth_manager.py)
echo [X] Exit
echo.
set /p "choice=Enter your choice (1, 2, or X to exit): "

if /i "!choice!"=="1" goto :InstallPython
if /i "!choice!"=="2" goto :RunBandwidthMonitor
if /i "!choice!"=="X" goto :ExitScript

echo Invalid choice. Please try again.
timeout /t 2 >nul
goto :Menu

:InstallPython
:: Download install_py.bat if it doesn't exist
set "installScript=C:\Users\%USERNAME%\Desktop\anime\install_py.bat"

if not exist "!installScript!" (
    echo Downloading install_py.bat... >> "!logFile!"
    curl -L -o "!installScript!" https://github.com/quannqttg/emulators/raw/main/install_py.bat
    if !errorlevel! neq 0 (
        echo Failed to download install_py.bat. Exiting... >> "!logFile!"
        pause
        goto :Menu
    )
    echo install_py.bat downloaded successfully. >> "!logFile!"
)

:: Run install_py.bat
call "!installScript!"
if !errorlevel! neq 0 (
    echo install_py.bat execution failed. >> "!logFile!"
    pause
    goto :Menu
)

echo Python installation completed successfully on %date% %time%. >> "!logFile!"
pause
goto :Menu

:RunBandwidthMonitor
echo Starting bandwidth monitor on %date% %time% >> "!logFile!"

:: Check if Python is installed
echo Checking if Python is installed... >> "!logFile!"
where python >nul 2>&1
if !errorlevel! neq 0 (
    echo Python is not installed. Please install Python first. >> "!logFile!"
    echo Please install Python first.
    pause
    goto :Menu
)

:: Download qos_bandwidth_manager.py if it doesn't exist
set "bandwidthScript=C:\Users\%USERNAME%\Desktop\anime\qos_bandwidth_manager.py"

if not exist "!bandwidthScript!" (
    echo Downloading qos_bandwidth_manager.py... >> "!logFile!"
    curl -L -o "!bandwidthScript!" https://github.com/quannqttg/emulators/raw/main/qos_bandwidth_manager.py
    if !errorlevel! neq 0 (
        echo Failed to download qos_bandwidth_manager.py. >> "!logFile!"
        pause
        goto :Menu
    )
    echo qos_bandwidth_manager.py downloaded successfully. >> "!logFile!"
)

:: Run qos_bandwidth_manager.py in a new window with a title
start "Running Bandwidth Monitor" cmd /k python "!bandwidthScript!"

echo Bandwidth monitor started successfully. >> "!logFile!"
pause
goto :Menu

:ExitScript
endlocal
exit /b 0
