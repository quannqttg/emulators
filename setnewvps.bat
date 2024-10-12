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

:: Set display resolution to 1920x1080 using NirCmd
echo Setting display resolution to 1920x1080...
nircmd.exe setdisplay 1920 1080 32
if errorlevel 1 (
    echo Failed to set display resolution. >> "!logFile!"
) else (
    echo Display resolution set to 1920x1080 successfully. >> "!logFile!"
)

:: Display countdown message
echo Countdown 10 seconds before proceeding to the next step...
for /L %%i in (10,-1,1) do (
    echo %%i
    timeout /t 1 >nul
)

:: Create log file
set "logFile=C:\Users\%USERNAME%\Desktop\anime\script_log.txt"
echo Starting script execution on %date% %time% >> "!logFile!"

:: Define URLs for files to download from GitHub
set "cleanUrl=https://raw.githubusercontent.com/quannqttg/emulators/main/clean.bat"
set "pcUrl=https://github.com/quannqttg/emulators/raw/main/pc.exe"

setlocal enabledelayedexpansion

:: Check for user directory
set "userDir=%USERNAME%"
set "animeDir=C:\Users\%userDir%\Desktop\anime"
echo Checking for user directory: !userDir! >> "!logFile!"
echo Anime directory path: !animeDir! >> "!logFile!"

if exist "!animeDir!" (
    echo User directory "!userDir!" exists: "!animeDir!" >> "!logFile!"

    :: Download clean.bat
    echo Downloading clean.bat to "!animeDir!"... >> "!logFile!"
    curl -L -o "!animeDir!\clean.bat" "!cleanUrl!"
    if errorlevel 1 (
        echo Failed to download clean.bat. Check the URL and your network connection. >> "!logFile!"
        goto :SkipToCopyPC
    )
    echo File downloaded successfully to "!animeDir!\clean.bat". >> "!logFile!"

    :: Download pc.exe
    echo Downloading pc.exe to "!animeDir!"... >> "!logFile!"
    curl -L -o "!animeDir!\pc.exe" "!pcUrl!"
    if errorlevel 1 (
        echo Failed to download pc.exe. Check the URL and your network connection. >> "!logFile!"
        goto :SkipToNext
    )
    echo File downloaded successfully to "!animeDir!\pc.exe". >> "!logFile!"

    :: Determine Startup directory
    set "startupDir=C:\Users\%userDir%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"
    echo Startup directory path: "!startupDir!" >> "!logFile!"

    :: Delete all files in the Startup directory
    echo Deleting all files in the Startup directory... >> "!logFile!"
    del /q "!startupDir!\*.*" >nul 2>&1
    echo All files in Startup directory have been deleted. >> "!logFile!"

    :: Copy pc.exe to Startup directory
    echo Copying pc.exe to "!startupDir!"... >> "!logFile!"
    if not exist "!startupDir!" (
        echo Startup directory does not exist. Creating it... >> "!logFile!"
        mkdir "!startupDir!"
    )
    copy "!animeDir!\pc.exe" "!startupDir!\pc.exe" >nul
    if errorlevel 1 (
        echo Failed to copy pc.exe to Startup directory. >> "!logFile!"
        goto :SkipToNext
    )
    echo pc.exe copied successfully to "!startupDir!". >> "!logFile!"

    :: Check for and delete any existing scheduled tasks
    schtasks /query /tn "CheckDiskSpaceAndRestart_Morning" >nul 2>&1
    if errorlevel 1 (
        echo No existing task named "CheckDiskSpaceAndRestart_Morning" found. >> "!logFile!"
    ) else (
        echo Deleting any existing task named "CheckDiskSpaceAndRestart_Morning"... >> "!logFile!"
        schtasks /delete /tn "CheckDiskSpaceAndRestart_Morning" /f
        echo SUCCESS: The scheduled task "CheckDiskSpaceAndRestart_Morning" was successfully deleted. >> "!logFile!"
    )

    schtasks /query /tn "CheckDiskSpaceAndRestart_Evening" >nul 2>&1
    if errorlevel 1 (
        echo No existing task named "CheckDiskSpaceAndRestart_Evening" found. >> "!logFile!"
    ) else (
        echo Deleting any existing task named "CheckDiskSpaceAndRestart_Evening"... >> "!logFile!"
        schtasks /delete /tn "CheckDiskSpaceAndRestart_Evening" /f
        echo SUCCESS: The scheduled task "CheckDiskSpaceAndRestart_Evening" was successfully deleted. >> "!logFile!"
    )

    :: Create new scheduled tasks for both times
    echo Creating new scheduled tasks... >> "!logFile!"

    :: First task at 10:00 AM
    schtasks /create /tn "CheckDiskSpaceAndRestart_Morning" /tr "!animeDir!\clean.bat" /sc daily /st 10:00 /ru "%USERNAME%" /rl highest /f
    if errorlevel 1 (
        echo Failed to create the scheduled task for 10:00 AM. >> "!logFile!"
    ) else (
        echo Scheduled task "CheckDiskSpaceAndRestart_Morning" created to run "!animeDir!\clean.bat" at 10:00 AM daily. >> "!logFile!"
    )

    :: Second task at 10:00 PM
    schtasks /create /tn "CheckDiskSpaceAndRestart_Evening" /tr "!animeDir!\clean.bat" /sc daily /st 22:00 /ru "%USERNAME%" /rl highest /f
    if errorlevel 1 (
        echo Failed to create the scheduled task for 10:00 PM. >> "!logFile!"
    ) else (
        echo Scheduled task "CheckDiskSpaceAndRestart_Evening" created to run "!animeDir!\clean.bat" at 10:00 PM daily. >> "!logFile!"
    )

) else (
    echo User directory "!userDir!" does not exist or Desktop\anime not found. Skipping to next user... >> "!logFile!"
)

:SkipToNext
echo Script execution completed on %date% %time% >> "!logFile!"
endlocal
pause

:: Check the status of the time service
w32tm /query /status
