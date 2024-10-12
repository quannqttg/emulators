@echo off
:: Check for Admin privileges
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Please run as administrator.
    powershell -command "Start-Process cmd -ArgumentList '/c %~f0' -Verb RunAs"
    exit /b
)

:: Check and enable Windows Time service
echo Checking if Windows Time service is running...
sc query w32time | find "RUNNING" >nul 2>&1
if %errorlevel% neq 0 (
    echo Windows Time service is not running. Attempting to enable the service...
    sc config w32time start= auto
    net start w32time
    if errorlevel 1 (
        echo Failed to start Windows Time service. Please enable it manually in services.msc.
        exit /b
    ) else (
        echo Windows Time service started successfully.
    )
) else (
    echo Windows Time service is already running.
)

:: Configure time server
echo Configuring time server...
w32tm /config /manualpeerlist:"time.google.com,0x1" /syncfromflags:manual /reliable:YES /update
if errorlevel 1 (
    echo Failed to configure the time server. Please check the command syntax and try again.
    exit /b
)

:: Restart the time service
net stop w32time
net start w32time

:: Enable automatic time synchronization
echo Enabling automatic time synchronization...
w32tm /resync
if %errorlevel% neq 0 (
    echo Failed to synchronize time. Please check your network connection and time service settings.
    exit /b
) else (
    echo Time synchronization completed successfully.
)

:: Check the time after synchronization
for /f "tokens=1-4 delims=:" %%a in ('wmic os get localdatetime ^| find "."') do (
    set "CurrentTime=%%a:%%b:%%c"
)

echo Current time is: %CurrentTime%

:: Create a log file
set "logFile=C:\Users\%USERNAME%\Desktop\anime\script_log.txt"
echo Starting script execution on %date% %time% >> "!logFile!"

:: Download nircmd.exe
set "nircmdUrl=https://raw.githubusercontent.com/quannqttg/emulators/main/nircmd.exe"
set "nircmdPath=C:\Users\%USERNAME%\Desktop\anime\nircmd.exe"

echo Downloading nircmd.exe to "!nircmdPath!"... >> "!logFile!"
curl -L -o "!nircmdPath!" "!nircmdUrl!"
if errorlevel 1 (
    echo Failed to download nircmd.exe. Check the URL and your network connection. >> "!logFile!"
    exit /b
)
echo nircmd.exe downloaded successfully to "!nircmdPath!" >> "!logFile!"

:: Set display resolution to 1920x1080 using NirCmd
echo Setting display resolution to 1920x1080...
"!nircmdPath!" setdisplay 1920 1080 32
if errorlevel 1 (
    echo Failed to set display resolution. >> "!logFile!"
) else (
    echo Display resolution set to 1920x1080 successfully. >> "!logFile!"
)

:: End the script
echo Script execution completed on %date% %time% >> "!logFile!"
exit /b
