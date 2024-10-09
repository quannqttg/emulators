@echo off
REM Tên tác vụ
set TaskName=CheckDiskSpaceAndRestart

REM Lệnh để xóa tác vụ nếu nó đã tồn tại
schtasks /delete /tn "%TaskName%" /f

REM Tạo tác vụ lên lịch để chạy file clean.bat vào lúc 12:00 hàng ngày
schtasks /create /tn "%TaskName%" /tr "C:\Users\pc\clean.bat" /sc daily /st 12:00 /ru "SYSTEM" /rl highest /f

echo Scheduled task "%TaskName%" has been created to run "C:\Users\pc\clean.bat" at 12:00 daily.
