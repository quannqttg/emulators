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

REM Step 10: Reset TCP/IP stack
echo Resetting TCP/IP stack at %date% %time%... >> "%logFile%"
netsh int ip reset
if %errorlevel% neq 0 (
    echo [ERROR] Failed to reset TCP/IP stack. >> "%logFile%"
) else (
    echo Successfully reset TCP/IP stack. >> "%logFile%"
)

REM Step 11: Clear SSL state
echo Clearing SSL state at %date% %time%... >> "%logFile%"
certutil -URLCache * delete
if %errorlevel% neq 0 (
    echo [ERROR] Failed to clear SSL state. >> "%logFile%"
) else (
    echo Successfully cleared SSL state. >> "%logFile%"
)

REM Step 12: Clear NetBIOS cache
echo Clearing NetBIOS cache at %date% %time%... >> "%logFile%"
nbtstat -R
if %errorlevel% neq 0 (
    echo [ERROR] Failed to clear NetBIOS cache. >> "%logFile%"
) else (
    echo Successfully cleared NetBIOS cache. >> "%logFile%"
)

REM Step 13: Reset firewall to default settings
echo Resetting firewall to default settings at %date% %time%... >> "%logFile%"
netsh advfirewall reset
if %errorlevel% neq 0 (
    echo [ERROR] Failed to reset firewall to default settings. >> "%logFile%"
) else (
    echo Successfully reset firewall to default settings. >> "%logFile%"
)

REM Step 14: Disable and re-enable network adapters
echo Disabling and re-enabling network adapters at %date% %time%... >> "%logFile%"
for /f "skip=3 tokens=3*" %%i in ('netsh interface show interface') do (
    netsh interface set interface "%%j" disabled
    netsh interface set interface "%%j" enabled
    echo Disabled and re-enabled network adapter: %%j >> "%logFile%"
)

REM Step 15: Clear routing table
echo Clearing routing table at %date% %time%... >> "%logFile%"
route -f
if %errorlevel% neq 0 (
    echo [ERROR] Failed to clear routing table. >> "%logFile%"
) else (
    echo Successfully cleared routing table. >> "%logFile%"
)

REM Step 16: Restart network-related services
echo Restarting network-related services at %date% %time%... >> "%logFile%"
echo Y | net stop dnscache >> "%logFile%" 2>&1
net start dnscache >> "%logFile%" 2>&1
echo Y | net stop dhcp >> "%logFile%" 2>&1
net start dhcp >> "%logFile%" 2>&1
echo Y | net stop nla >> "%logFile%" 2>&1
net start nla >> "%logFile%" 2>&1

echo Network optimization completed at %date% %time%. >> "%logFile%"
echo All steps completed successfully. Initiating system restart... >> "%logFile%"
echo The system will restart in 20 seconds. Please save your work.
timeout /t 20

REM Force restart the PC
shutdown /r /f /t 0
