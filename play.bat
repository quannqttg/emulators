@echo off
setlocal enabledelayedexpansion

REM Set user variable to the current username
set "userr=%USERNAME%"

REM Set log file name
set "logFile=play.log"
SET KEY="HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters"

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

REM Step 2: Grant full control permission on the registry key
echo Granting full control to %userr% on %KEY% >> "%logFile%"

REM Check if PowerShell is available
powershell -Command "if (-not (Get-Command -Name 'Set-Acl' -ErrorAction SilentlyContinue)) { exit 1 }"

if %ERRORLEVEL% neq 0 (
    echo PowerShell is not available on this system. >> "%logFile%"
    pause
    exit /b
)

REM Use PowerShell to set permissions on the registry key
powershell -Command ^ 
    "$path = 'Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters'; " ^ 
    "$acl = Get-Acl -Path $path; " ^ 
    "$accessRule = New-Object System.Security.AccessControl.RegistryAccessRule('%userr%', 'FullControl', 'Allow'); " ^ 
    "$acl.AddAccessRule($accessRule); " ^ 
    "Set-Acl -Path $path -AclObject $acl;"

if %ERRORLEVEL% == 0 (
    echo Permissions successfully updated. >> "%logFile%"
) else (
    echo Failed to update permissions. Check if you have the necessary rights. >> "%logFile%"
)

REM Optimize network settings
echo Optimizing network settings... >> "%logFile%"
netsh interface ip set address "Ethernet" dhcp
netsh interface ip set dns "Ethernet" dhcp

REM Log the time of releasing current IP address
echo Releasing current IP address at %date% %time% >> "%logFile%"
ipconfig /release

REM Log the time of renewing IP address
echo Renewing IP address at %date% %time% >> "%logFile%"
ipconfig /renew

REM Step 3: Flush the DNS cache
echo Flushing DNS cache at %date% %time% >> "%logFile%"
ipconfig /flushdns

REM Step 4: Reset Winsock
echo Resetting Winsock at %date% %time% >> "%logFile%"
netsh winsock reset

REM Step 5: Reset IP configuration and log the result
echo Resetting IP configuration at %date% %time% >> "%logFile%"
netsh int ip reset
if errorlevel 1 (
    echo [WARNING] IP reset failed. >> "%logFile%"
) else (
    echo IP reset successful. >> "%logFile%"
)

REM Step 6: Check WinHTTP proxy settings
echo Checking WinHTTP proxy settings... >> "%logFile%"
netsh winhttp show proxy | findstr "Direct" >> "%logFile%"

REM Flush the ARP cache
echo Flushing ARP cache at %date% %time% >> "%logFile%"
arp -d *

REM Check if network is stable
ping -n 4 8.8.8.8 > nul
if %errorlevel% == 0 (
    echo Network appears stable. >> "%logFile%"
    
    REM Download checknetwork.bat using curl
    echo Downloading checknetwork.bat... >> "%logFile%"
    curl -L -o checknetwork.bat https://raw.githubusercontent.com/quannqttg/emulators/main/checknetwork.bat

    REM Run CheckNetwork.bat in hidden mode using PowerShell
    echo Running checknetwork.bat in hidden mode at %date% %time% >> "%logFile%"
    start "" powershell -WindowStyle Hidden -Command "Start-Process 'cmd.exe' -ArgumentList '/c checknetwork.bat';"

) else (
    echo Network still unstable. >> "%logFile%"
)

REM Step 7: Pause for 10 seconds before running autoRelaunch_mumu.bat
echo Pausing for 10 seconds before running autoRelaunch_mumu.bat at %date% %time% >> "%logFile%"
TIMEOUT /T 10

REM Log the time of running autoRelaunch_mumu.bat
echo Running autoRelaunch_mumu.bat at %date% %time% >> "%logFile%"
start cmd /c "autoRelaunch_mumu.bat"

REM End of script and close pc.bat
echo Script completed at %date% %time% >> "%logFile%"
exit /b
