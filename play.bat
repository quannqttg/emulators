@echo off
setlocal enabledelayedexpansion

REM Set log file name
set "logFile=play.log"
SET KEY="HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters"
SET "USER=cc"

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
echo Granting full control to %USER% on %KEY% >> "%logFile%"

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
    "$accessRule = New-Object System.Security.AccessControl.RegistryAccessRule('%USER%', 'FullControl', 'Allow'); " ^
    "$acl.AddAccessRule($accessRule); " ^
    "Set-Acl -Path $path -AclObject $acl;"

if %ERRORLEVEL% == 0 (
    echo Permissions successfully updated. >> "%logFile%"
) else (
    echo Failed to update permissions. Check if you have the necessary rights. >> "%logFile%"
)

REM Start infinite loop for Step 7
:Start
echo Starting Step 7 >> "%logFile%"

REM Step 3: Flush DNS cache
echo Flushing DNS cache at %date% %time% >> "%logFile%"
ipconfig /flushdns

REM Step 4: Reset Winsock
echo Resetting Winsock... >> "%logFile%"
netsh winsock reset
if errorlevel 1 (
    echo [WARNING] Winsock reset failed. Access denied or another issue. >> "%logFile%"
) else (
    echo Winsock reset completed. A restart may be required. >> "%logFile%"
)

REM Step 5: Reset IP configuration and log the result
echo Resetting IP configuration... >> "%logFile%"
netsh int ip reset
if errorlevel 1 (
    echo [WARNING] IP reset failed. >> "%logFile%"
) else (
    echo IP reset successful. >> "%logFile%"
)

REM Step 6: Check WinHTTP proxy settings
echo Checking WinHTTP proxy settings... >> "%logFile%"
netsh winhttp show proxy | findstr "Direct" >> "%logFile%"

REM Check if network is stable
ping -n 4 8.8.8.8 > nul
if %errorlevel% == 0 (
    echo Network appears stable. >> "%logFile%"
    REM Không thoát khỏi vòng lặp mà chỉ tiếp tục
) else (
    echo Network still unstable. Continuing to next iteration... >> "%logFile%"
)

REM Step 7: Pause for 5 seconds before running installer_mumu.exe
echo Pausing for 5 seconds before running installer_mumu.exe at %date% %time% >> "%logFile%"
TIMEOUT /T 5

REM Log the time of running installer_mumu.exe
echo Running installer_mumu.exe at %date% %time% >> "%logFile%"
installer_mumu.exe

REM Log the time of running client_mumu.exe
echo Running client_mumu.exe at %date% %time% >> "%logFile%"
client_mumu.exe

REM Log the time before pausing
echo Pausing for 30 seconds at %date% %time% >> "%logFile%"
TIMEOUT /T 30

REM Go back to the Start label for continuous execution
GOTO:Start

:EOF
echo Script completed at %date% %time% >> "%logFile%"
echo Press any key to exit...
pause > nul
endlocal
