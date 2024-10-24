@echo off
setlocal enabledelayedexpansion

REM Set log file name
set "logFile=play.log"

REM Set user variable to the current username
set "userr=%USERNAME%"

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

REM Start infinite loop for network check
:Start
echo Starting network stability check at %date% %time% >> "%logFile%"

REM Pinging 8.8.8.8 1000 times with a 1-second interval
for /l %%i in (1,1,1000) do (
    ping -n 1 8.8.8.8 > nul
    timeout /t 1 > nul
)

REM Check if network is stable
if %errorlevel% == 0 (
    echo Network appears stable after 1000 pings. >> "%logFile%"
) else (
    echo Network is unstable or lost. Running optimization steps... >> "%logFile%"

    REM Step 3: Optimize network settings by using DHCP for IP and DNS
    echo Optimizing network settings... >> "%logFile%"
    netsh interface ip set address "Ethernet" dhcp
    netsh interface ip set dns "Ethernet" dhcp

    REM Log the time of releasing current IP address
    echo Releasing current IP address at %date% %time% >> "%logFile%"
    ipconfig /release

    REM Log the time of renewing IP address
    echo Renewing IP address at %date% %time% >> "%logFile%"
    ipconfig /renew

    REM Step 4: Flush the DNS cache
    echo Flushing DNS cache at %date% %time% >> "%logFile%"
    ipconfig /flushdns

    REM Step 5: Reset Winsock
    echo Resetting Winsock at %date% %time% >> "%logFile%"
    netsh winsock reset

    REM Step 6: Reset IP configuration and log the result
    echo Resetting IP configuration at %date% %time% >> "%logFile%"
    netsh int ip reset
    if errorlevel 1 (
        echo [WARNING] IP reset failed. >> "%logFile%"
    ) else (
        echo IP reset successful. >> "%logFile%"
    )

    REM Step 7: Check WinHTTP proxy settings
    echo Checking WinHTTP proxy settings... >> "%logFile%"
    netsh winhttp show proxy | findstr "Direct" >> "%logFile%"
    
    REM Flush the ARP cache
    echo Flushing ARP cache at %date% %time% >> "%logFile%"
    arp -d *
)

REM Wait for 1800 seconds (30 minutes) before checking again
echo Waiting for 1800 seconds before the next check... >> "%logFile%"
timeout /t 1800 > nul
goto Start
