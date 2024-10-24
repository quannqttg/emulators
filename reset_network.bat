@echo off
setlocal enabledelayedexpansion

REM Set log file name
set "logFile=reset_network.log"

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

REM Step 2: Optimize network settings by setting IP and DNS to DHCP
echo Optimizing network settings (Switching to DHCP)... >> "%logFile%"
netsh interface ip set address "Ethernet" dhcp
netsh interface ip set dns "Ethernet" dhcp
if %errorlevel% neq 0 (
    echo [ERROR] Failed to set network to DHCP. >> "%logFile%"
) else (
    echo Successfully set network to DHCP. >> "%logFile%"
)

REM Step 3: Release current IP address
echo Releasing current IP address at %date% %time%... >> "%logFile%"
ipconfig /release
if %errorlevel% neq 0 (
    echo [ERROR] Failed to release IP address. >> "%logFile%"
) else (
    echo Successfully released IP address. >> "%logFile%"
)

REM Step 4: Renew IP address
echo Renewing IP address at %date% %time%... >> "%logFile%"
ipconfig /renew
if %errorlevel% neq 0 (
    echo [ERROR] Failed to renew IP address. >> "%logFile%"
) else (
    echo Successfully renewed IP address. >> "%logFile%"
)

REM Step 5: Flush the DNS cache
echo Flushing DNS cache at %date% %time%... >> "%logFile%"
ipconfig /flushdns
if %errorlevel% neq 0 (
    echo [ERROR] Failed to flush DNS cache. >> "%logFile%"
) else (
    echo Successfully flushed DNS cache. >> "%logFile%"
)

REM Step 6: Reset Winsock
echo Resetting Winsock at %date% %time%... >> "%logFile%"
netsh winsock reset
if %errorlevel% neq 0 (
    echo [ERROR] Winsock reset failed. >> "%logFile%"
) else (
    echo Winsock reset successful. >> "%logFile%"
)

REM Step 7: Reset IP configuration
echo Resetting IP configuration at %date% %time%... >> "%logFile%"
netsh int ip reset
if %errorlevel% neq 0 (
    echo [ERROR] IP reset failed. >> "%logFile%"
) else (
    echo IP reset successful. >> "%logFile%"
)

REM Step 8: Check WinHTTP proxy settings
echo Checking WinHTTP proxy settings at %date% %time%... >> "%logFile%"
netsh winhttp show proxy | findstr "Direct" >> "%logFile%"
if %errorlevel% neq 0 (
    echo [ERROR] Failed to check or reset WinHTTP proxy. >> "%logFile%"
) else (
    echo WinHTTP proxy settings are correctly set. >> "%logFile%"
)

REM Step 9: Flush ARP cache
echo Flushing ARP cache at %date% %time%... >> "%logFile%"
arp -d *
if %errorlevel% neq 0 (
    echo [ERROR] Failed to flush ARP cache. >> "%logFile%"
) else (
    echo Successfully flushed ARP cache. >> "%logFile%"
)

echo Network optimization completed at %date% %time%. >> "%logFile%"
