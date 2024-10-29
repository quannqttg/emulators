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
echo [2] Download and Run Main Script (main.py)
echo [X] Exit
echo.
set /p "choice=Enter your choice (1, 2, or X to exit): "

if /i "!choice!"=="1" goto :InstallPython
if /i "!choice!"=="2" goto :RunMainScript
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

:: Delete install_py.bat after successful installation
del "!installScript!"
if !errorlevel! neq 0 (
    echo Failed to delete install_py.bat. >> "!logFile!"
) else (
    echo install_py.bat deleted successfully. >> "!logFile!"
)

pause
goto :Menu

:RunMainScript
echo Starting main script on %date% %time% >> "!logFile!"

:: Check if Python is installed
echo Checking if Python is installed... >> "!logFile!"
where python >nul 2>&1
if !errorlevel! neq 0 (
    echo Python is not installed. Please install Python first. >> "!logFile!"
    echo Please install Python first.
    pause
    goto :Menu
)

:: Set the paths for Python scripts
set "mainScript=C:\Users\%USERNAME%\Desktop\anime\main.py"
set "numaScript=C:\Users\%USERNAME%\Desktop\anime\numa_optimizer.py"
set "cpuScript=C:\Users\%USERNAME%\Desktop\anime\cpu_optimizer.py"

:: Download Python scripts
echo Downloading Python scripts... >> "!logFile!"
curl -L -o "!mainScript!" https://github.com/quannqttg/emulators/raw/main/main.py
curl -L -o "!numaScript!" https://github.com/quannqttg/emulators/raw/main/numa_optimizer.py
curl -L -o "!cpuScript!" https://github.com/quannqttg/emulators/raw/main/cpu_optimizer.py
if !errorlevel! neq 0 (
    echo Failed to download Python scripts. >> "!logFile!"
    pause
    goto :Menu
)
echo Python scripts downloaded successfully. >> "!logFile!"

:: Run main.py in a new window with a title
start "Running Main Script" cmd /c python "!mainScript!" ^& exit

:: Wait for the window to close
echo Waiting for the script to finish... >> "!logFile!"
:WaitLoop
tasklist /FI "WINDOWTITLE eq Running Main Script" 2>NUL | find /I /N "cmd.exe">NUL
if !errorlevel! == 0 (
    timeout /t 1 >nul
    goto :WaitLoop
)

:: Delete Python scripts after execution
echo Deleting Python scripts... >> "!logFile!"
del "!mainScript!" "!numaScript!" "!cpuScript!"
if !errorlevel! neq 0 (
    echo Failed to delete Python scripts. >> "!logFile!"
) else (
    echo Python scripts deleted successfully. >> "!logFile!"
)

echo Main script execution completed. >> "!logFile!"
pause
goto :Menu

:ExitScript
endlocal
exit /b 0
