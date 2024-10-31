@echo off
setlocal enabledelayedexpansion

REM Set log file name
set "logFile=checknetwork.log"

REM Set user variable to the current username
set "userr=%USERNAME%"

REM Check for Administrative Privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [DEBUG] No admin privileges detected. Requesting administrative privileges...
    echo Requesting administrative privileges... >> "%logFile%"
    powershell -command "Start-Process cmd -ArgumentList '/c %~f0' -Verb RunAs"
    echo [WARNING] Unable to acquire admin privileges, continuing without them. >> "%logFile%"
) else (
    echo [DEBUG] Admin privileges confirmed.
    echo Admin privileges confirmed. >> "%logFile%"
)

REM Begin Network Optimization Steps
echo Running optimization steps... >> "%logFile%"

REM Step 1: Optimize Network Settings Using DHCP
echo Optimizing network settings... >> "%logFile%"
netsh interface ip set address "Ethernet" dhcp
netsh interface ip set dns "Ethernet" dhcp

REM Step 2: Release Current IP Address
echo Releasing current IP address at %date% %time% >> "%logFile%"
ipconfig /release

REM Step 3: Renew IP Address
echo Renewing IP address at %date% %time% >> "%logFile%"
ipconfig /renew

REM Step 4: Flush DNS Cache
echo Flushing DNS cache at %date% %time% >> "%logFile%"
ipconfig /flushdns

REM Step 5: Reset Winsock
echo Resetting Winsock at %date% %time% >> "%logFile%"
netsh winsock reset

REM Step 6: Check WinHTTP Proxy Settings
echo Checking WinHTTP proxy settings... >> "%logFile%"
netsh winhttp show proxy | findstr "Direct" >> "%logFile%"

REM Step 7: Flush ARP Cache
echo Flushing ARP cache at %date% %time% >> "%logFile%"
arp -d *

echo Optimization steps completed at %date% %time% >> "%logFile%"

REM Exit the script successfully
exit /b
