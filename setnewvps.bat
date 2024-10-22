@echo off
:: Check for Admin privileges
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Please run as administrator.
    powershell -command "Start-Process cmd -ArgumentList '/c %~f0' -Verb RunAs"
    exit /b
)

:: Create log file
set "logFile=C:\Users\%USERNAME%\Desktop\anime\newvps_log.txt"
echo Starting script execution on %date% %time% >> "!logFile!"

:: Define URLs for files to download from GitHub
set "cleanUrl=https://raw.githubusercontent.com/quannqttg/emulators/main/clean.bat"
set "pcUrl=https://github.com/quannqttg/emulators/raw/main/pc.exe"
set "chromeRemoteDesktopUrl=https://github.com/quannqttg/emulators/raw/main/chromeremotedesktophost.msi"
set "openBatUrl=https://raw.githubusercontent.com/quannqttg/emulators/main/open.bat"  :: Added URL for open.bat

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

    :: Download chromeremotedesktophost.msi
    echo Downloading chromeremotedesktophost.msi to "!animeDir!"... >> "!logFile!"
    curl -L -o "!animeDir!\chromeremotedesktophost.msi" "!chromeRemoteDesktopUrl!"
    if errorlevel 1 (
        echo Failed to download chromeremotedesktophost.msi. Check the URL and your network connection. >> "!logFile!"
        goto :SkipToNext
    )
    echo File downloaded successfully to "!animeDir!\chromeremotedesktophost.msi". >> "!logFile!"

    :: Download open.bat
    echo Downloading open.bat to "!animeDir!"... >> "!logFile!"
    curl -L -o "!animeDir!\open.bat" "!openBatUrl!"
    if errorlevel 1 (
        echo Failed to download open.bat. Check the URL and your network connection. >> "!logFile!"
        goto :SkipToNext
    )
    echo File downloaded successfully to "!animeDir!\open.bat". >> "!logFile!"

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

    :: Create a scheduled task to delete all files in %temp% at logon
    echo Creating scheduled task 'DeleteTempFiles' to delete all files in %temp% on user logon... >> "!logFile!"
    schtasks /query /tn "DeleteTempFiles" >nul 2>&1
    if errorlevel 1 (
        echo No existing task named "DeleteTempFiles" found. Creating a new task... >> "!logFile!"
        
        :: Create the scheduled task to delete files in %temp% upon logon
        schtasks /create /tn "DeleteTempFiles" /tr "cmd /c del /q /s %%temp%%\*" /sc onlogon /ru "%USERNAME%" /rl highest /f
        if errorlevel 1 (
            echo Failed to create the scheduled task 'DeleteTempFiles'. >> "!logFile!"
        ) else (
            echo Scheduled task 'DeleteTempFiles' created to run del /q /s %%temp%%\* on user logon. >> "!logFile!"
        )
    ) else (
        echo The scheduled task 'DeleteTempFiles' already exists. >> "!logFile!"
    )

) else (
    echo User directory "!userDir!" does not exist or Desktop\anime not found. Skipping to next user... >> "!logFile!"
)

:: Enable Scheduled Task History
echo Enabling history for all scheduled tasks... >> "!logFile!"
powershell -Command "Enable-ScheduledTaskLog"

:SkipToNext
echo Script execution completed on %date% %time% >> "!logFile!"
endlocal
exit
