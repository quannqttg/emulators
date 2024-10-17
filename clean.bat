@echo off
setlocal enabledelayedexpansion

echo Starting disk space check and restarting the computer...

:: Lấy tên người dùng hiện tại từ biến môi trường USERNAME
set "userDir=%USERNAME%"
set "animeDir=C:\Users\%userDir%\Desktop\anime"

echo Checking for user directory: !userDir!
echo Anime directory path: !animeDir!

:: Kiểm tra xem thư mục animeDir có tồn tại không
if not exist "!animeDir!" (
    echo Directory "!animeDir!" does not exist. Creating it...
    mkdir "!animeDir!"
)

:: Log for clean in animeDir
echo %date% %time% - clean.bat is running >> "!animeDir!\checkclean.log"

if exist "!animeDir!" (
    echo User directory "!userDir!" exists: "!animeDir!"
) else (
    echo User directory "!userDir!" does not exist or Desktop\anime not found. Skipping to next user...
)

REM Step 1: Check for administrative privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting administrative privileges...
    powershell -command "Start-Process cmd -ArgumentList '/c %~f0' -Verb RunAs"
    exit /b
)

REM Get the current CMD process ID
set "currentPID=%PROCESS_ID%"
for /f "tokens=2 delims=," %%i in ('tasklist /fi "imagename eq cmd.exe" /fo csv /nh') do (
    set "currentPID=%%i"
)
echo Current CMD Process ID: !currentPID!

REM Step 2: Check free space on C: drive using PowerShell
for /f "usebackq delims=" %%a in (`powershell -command "(Get-PSDrive C).Free"`) do (
    set "freeSpace=%%a"
)
if "%freeSpace%"=="" (
    echo Failed to retrieve free space. Please check if PowerShell is available and working.
    exit /b 2
)
echo Retrieved free space: !freeSpace!

REM Check if freeSpace is a valid number
for /f "delims=0123456789" %%i in ("%freeSpace%") do (
    echo Invalid free space value retrieved: "%freeSpace%". Ensure PowerShell command is working.
    exit /b 3
)

REM Echo the free space in bytes for logging purposes
echo Free space on C: drive: !freeSpace! bytes
set "minRequiredSpace=42949672960"
echo Required minimum space: !minRequiredSpace! bytes

REM Step 3: Check if there is at least 42,949,672,960 bytes free using PowerShell for accurate comparison
powershell -command "$freeSpace = [int64]$Env:freeSpace; $minRequiredSpace = [int64]$Env:minRequiredSpace; if ($freeSpace -lt $minRequiredSpace) { exit 1 } else { exit 0 }" freeSpace=!freeSpace! minRequiredSpace=!minRequiredSpace!

if errorlevel 1 (
    echo Not enough free space on C: drive. Free space is !freeSpace! bytes, which is less than !minRequiredSpace! bytes.

    REM Aborting any ongoing shutdown
    echo Aborting any ongoing shutdown...
    shutdown /a >nul 2>&1

    REM Check if any shutdown process is running
    tasklist | find "shutdown"
    if not errorlevel 1 (
        echo A shutdown process is already in progress. Please check your system state.
        exit /b 1
    )

    REM Step to close all running applications except current CMD
    echo Closing all running applications...
    set "closeSuccess=1"  REM Flag to check if closing applications was successful

    for /f "tokens=2 delims=," %%i in ('tasklist /fo csv /nh') do (
        if not "%%i"=="!currentPID!" (
            echo Closing process with PID %%i...
            taskkill /F /PID %%i >nul 2>&1
            if errorlevel 1 (
                echo Failed to close process with PID %%i.
                set "closeSuccess=0"
            )
        )
    )

    if !closeSuccess! equ 1 (
        echo All applications closed successfully.
    ) else (
        echo Some applications could not be closed.
    )

    REM Indicate system needs to be restarted
    echo System needs to be restarted to free up space. Please save all work.
    echo Restarting the computer in 10 seconds...

    REM Countdown for 10 seconds
    for /l %%i in (10,-1,1) do (
        echo %%i...
        timeout /t 1 >nul
    )

    REM Restart the computer
    echo Attempting to restart the computer...
    shutdown /r /t 0

    REM Prevent the script from continuing after restart command
    exit /b 0  REM Prevent further execution
) else (
    echo Sufficient free space on C: drive. Free space is !freeSpace! bytes, which is greater than or equal to !minRequiredSpace! bytes.
)

echo All operations completed successfully!
exit /b 0
exit
