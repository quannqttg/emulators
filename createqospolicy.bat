@echo off
setlocal enabledelayedexpansion

:: Define download URLs and paths
set "setTcreateqospolicy=https://raw.githubusercontent.com/quannqttg/emulators/main/createqospolicy.ps1"
set "setcreateqospolicy.ps1Path=C:\Users\%USERNAME%\Desktop\anime\createqospolicy.ps1"
set "setTdeleteallqos=https://raw.githubusercontent.com/quannqttg/emulators/main/deleteallqos.ps1"
set "setdeleteallqos.ps1Path=C:\Users\%USERNAME%\Desktop\anime\deleteallqos.ps1"
set "logFile=createqospolicy.log"

:: Check for anime directory
if not exist "C:\Users\%USERNAME%\Desktop\anime" (
    echo Anime directory not found, creating directory...
    mkdir "C:\Users\%USERNAME%\Desktop\anime"
)

:MENU
cls
echo 1. Set QoS (Run createqospolicy.ps1) - Download Link: %setTcreateqospolicy%
echo 2. Delete All QoS (Run deleteallqos.ps1) - Download Link: %setTdeleteallqos%
echo 3. Exit
set /p choice="Please choose an option (1-3): "

if "%choice%"=="1" (
    echo [DEBUG] Downloading createqospolicy.ps1...
    curl -L -o "%setcreateqospolicy.ps1Path%" %setTcreateqospolicy%
    echo [DEBUG] Download completed.
    
    REM Step 1: Check for administrative privileges
    net session >nul 2>&1
    if %errorlevel% neq 0 (
        echo [DEBUG] No admin privileges detected. Requesting administrative privileges...
        echo [LOG] Requesting administrative privileges... >> "%logFile%"
        powershell -command "Start-Process cmd -ArgumentList '/c %~f0' -Verb RunAs"
        exit /b
    ) else (
        echo [DEBUG] Admin privileges confirmed.
        echo [LOG] Admin privileges confirmed. >> "%logFile%"
    )

    REM Step 2: Set code page to UTF-8 for proper character display
    chcp 65001 >nul
    echo [DEBUG] Creating QoS Policy with DSCP Value = 20 and Throttle Rate = 500 Kbps for all applications...
    echo [LOG] Creating QoS Policy with DSCP Value = 20 and Throttle Rate = 500 Kbps for all applications... >> "%logFile%"

    REM Step 3: Run PowerShell script to create QoS policy
    powershell -ExecutionPolicy Bypass -File "%setcreateqospolicy.ps1Path%" >> "%logFile%" 2>&1

    REM Step 4: Completion message
    echo [DEBUG] QoS Policy creation completed.
    echo [LOG] QoS Policy creation completed. >> "%logFile%"
    echo Completed.
    
    REM Delete the downloaded file
    del "%setcreateqospolicy.ps1Path%"
    echo [DEBUG] Deleted createqospolicy.ps1.
    
    pause
    goto MENU
) else if "%choice%"=="2" (
    echo [DEBUG] Downloading deleteallqos.ps1...
    curl -L -o "%setdeleteallqos.ps1Path%" %setTdeleteallqos%
    echo [DEBUG] Download completed.

    REM Step 1: Check for administrative privileges
    net session >nul 2>&1
    if %errorlevel% neq 0 (
        echo [DEBUG] No admin privileges detected. Requesting administrative privileges...
        echo [LOG] Requesting administrative privileges... >> "%logFile%"
        powershell -command "Start-Process cmd -ArgumentList '/c %~f0' -Verb RunAs"
        exit /b
    ) else (
        echo [DEBUG] Admin privileges confirmed.
        echo [LOG] Admin privileges confirmed. >> "%logFile%"
    )

    REM Step 2: Run PowerShell script to delete all QoS policies
    powershell -ExecutionPolicy Bypass -File "%setdeleteallqos.ps1Path%" >> "%logFile%" 2>&1

    REM Step 3: Completion message
    echo [DEBUG] All QoS policies deletion completed.
    echo [LOG] All QoS policies deletion completed. >> "%logFile%"
    echo Completed.
    
    REM Delete the downloaded file
    del "%setdeleteallqos.ps1Path%"
    echo [DEBUG] Deleted deleteallqos.ps1.
    
    pause
    goto MENU
) else if "%choice%"=="3" (
    echo Exiting...
    exit /b
) else (
    echo Invalid choice. Please select 1, 2, or 3.
    pause
    goto MENU
)
