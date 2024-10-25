@echo off
setlocal enabledelayedexpansion

REM Set log file name
set "logFile=createqospolicy.log"

REM Set user variable to the current username
set "userr=%USERNAME%"

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
powershell -ExecutionPolicy Bypass -File "%~dp0createqospolicy.ps1" >> "%logFile%" 2>&1

REM Step 4: Completion message
echo [DEBUG] QoS Policy creation completed.
echo [LOG] QoS Policy creation completed. >> "%logFile%"
echo Completed.
pause
exit /b
