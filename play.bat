@echo off
setlocal

REM Set log file name
set "logFile=play.log"

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

REM Set user directory and anime directory
set "userDir=%USERNAME%"
set "animeDir=C:\Users\%userDir%\Desktop\anime"

REM Check if the anime directory exists
if not exist "%animeDir%" (
    echo The directory %animeDir% does not exist. Creating directory...
    mkdir "%animeDir%"
)

echo The anime directory is located at: %animeDir% >> "%logFile%"

:Start
REM Log the time of releasing current IP address
echo Releasing current IP address at %date% %time% >> "%logFile%"
ipconfig /release

REM Log the time of renewing IP address
echo Renewing IP address at %date% %time% >> "%logFile%"
ipconfig /renew

REM Log the time of flushing the DNS cache
echo Flushing DNS cache at %date% %time% >> "%logFile%"
ipconfig /flushdns

REM Resetting Winsock
echo Resetting Winsock at %date% %time% >> "%logFile%"
netsh winsock reset

REM Log the time of resetting IP configuration
echo Resetting IP configuration at %date% %time% >> "%logFile%"
netsh int ip reset 

REM Optimize network settings by using DHCP for IP and DNS
echo Optimizing network settings... >> "%logFile%"
netsh interface ip set address "Ethernet" dhcp
netsh interface ip set dns "Ethernet" dhcp

REM Flush the ARP cache
echo Flushing ARP cache at %date% %time% >> "%logFile%"
arp -d *

REM Pause for 5 seconds before running installer_mumu.exe
echo Pausing for 5 seconds before running installer_mumu.exe at %date% %time% >> "%logFile%"
TIMEOUT /T 5

REM Log the time of running installer_mumu.exe
echo Running installer_mumu.exe at %date% %time% >> "%logFile%"
installer_mumu.exe

REM Log the time of running client_mumu.exe
echo Running client_mumu.exe at %date% %time% >> "%logFile%"
client_mumu.exe

REM Log the time before pausing
echo Pausing for 5 seconds at %date% %time% >> "%logFile%"
TIMEOUT /T 5

REM Go back to the Start label
GOTO:Start

endlocal
