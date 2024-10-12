@echo off
setlocal

REM Xác định tên người dùng
set USERNAME=%USERNAME%
set USER_HOME=C:\Users\%USERNAME%

REM Kiểm tra và tạo thư mục anime nếu không tồn tại
if not exist "%USER_HOME%\Desktop\anime" (
    mkdir "%USER_HOME%\Desktop\anime"
)

REM Tạo file log để ghi lại thông tin
set LOG_FILE="%USER_HOME%\Desktop\anime\install_log.txt"

REM Ghi lại thời gian bắt đầu
echo %date% %time%: Bắt đầu cài đặt >> %LOG_FILE%

REM Kiểm tra quyền admin
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo %date% %time%: Vui lòng chạy script này với quyền admin. >> %LOG_FILE%
    exit /b
)

REM Đường dẫn đến Python 3.12.7 (32-bit) installer
set PYTHON_INSTALLER="%USER_HOME%\Desktop\anime\python-3.12.7-embed-win32.zip"
set PYTHON_INSTALL_PATH="C:\Users\%USERNAME%\AppData\Local\Programs\Python\Python312-32"

REM Ghi log đường dẫn
echo Đường dẫn tới Python Installer: %PYTHON_INSTALLER% >> %LOG_FILE%
echo Đường dẫn tới Python Install Path: %PYTHON_INSTALL_PATH% >> %LOG_FILE%

REM Tải Python Installer từ link mới
set PYTHON_INSTALLER_URL="https://www.python.org/ftp/python/3.12.7/python-3.12.7-embed-win32.zip"
echo %date% %time%: Tải Python Installer từ %PYTHON_INSTALLER_URL% >> %LOG_FILE%
powershell -command "Invoke-WebRequest -Uri %PYTHON_INSTALLER_URL% -OutFile %PYTHON_INSTALLER%" >> %LOG_FILE% 2>&1

REM Kiểm tra xem Python đã được cài đặt chưa
if not exist %PYTHON_INSTALL_PATH% (
    echo %date% %time%: Cài đặt Python... >> %LOG_FILE%
    
    REM Tạo thư mục nếu không tồn tại
    if not exist "C:\Users\%USERNAME%\AppData\Local\Programs\Python" (
        mkdir "C:\Users\%USERNAME%\AppData\Local\Programs\Python"
    )
    
    REM Giải nén installer
    powershell -command "Expand-Archive -Path %PYTHON_INSTALLER% -DestinationPath C:\Users\%USERNAME%\AppData\Local\Programs\Python" >> %LOG_FILE% 2>&1

    REM Thiết lập biến môi trường PATH
    setx PATH "%PATH%;%PYTHON_INSTALL_PATH%"
)

REM Chờ một chút để hệ thống nhận biết thay đổi
timeout /t 5 /nobreak > NUL

REM Cài đặt pip nếu chưa có
if not exist "%PYTHON_INSTALL_PATH%\Scripts\pip.exe" (
    echo %date% %time%: Cài đặt pip... >> %LOG_FILE%
    %PYTHON_INSTALL_PATH%\python.exe -m ensurepip >> %LOG_FILE% 2>&1
)

REM Cài đặt các module cần thiết
echo %date% %time%: Cài đặt PyAutoGUI, Pillow và OpenCV... >> %LOG_FILE%
%PYTHON_INSTALL_PATH%\python.exe -m pip install pyautogui Pillow opencv-python >> %LOG_FILE% 2>&1

REM Tải hình ảnh nút "Quick Install"
set BUTTON_IMAGE_URL="https://github.com/quannqttg/emulators/raw/main/quickinstall.PNG"
set BUTTON_IMAGE_PATH="%USER_HOME%\Desktop\anime\quickinstall.PNG"
echo %date% %time%: Tải hình ảnh nút "Quick Install" >> %LOG_FILE%
powershell -command "Invoke-WebRequest -Uri %BUTTON_IMAGE_URL% -OutFile %BUTTON_IMAGE_PATH%" >> %LOG_FILE% 2>&1

REM Tải script cài đặt MuMu Player
set INSTALL_SCRIPT_URL="https://github.com/quannqttg/emulators/raw/main/install_mumu.py"
set INSTALL_SCRIPT_PATH="%USER_HOME%\Desktop\anime\install_mumu.py"
echo %date% %time%: Tải script cài đặt MuMu Player >> %LOG_FILE%
powershell -command "Invoke-WebRequest -Uri %INSTALL_SCRIPT_URL% -OutFile %INSTALL_SCRIPT_PATH%" >> %LOG_FILE% 2>&1

REM Chạy script cài đặt MuMu Player
echo %date% %time%: Bắt đầu cài đặt MuMu Player >> %LOG_FILE%
%PYTHON_INSTALL_PATH%\python.exe %INSTALL_SCRIPT_PATH% >> %LOG_FILE% 2>&1

REM Xác nhận cài đặt MuMu Player
echo %date% %time%: Xác nhận cài đặt MuMu Player >> %LOG_FILE%
echo import pyautogui > "%USER_HOME%\Desktop\anime\confirm_install.py"
echo import time >> "%USER_HOME%\Desktop\anime\confirm_install.py"
echo import os >> "%USER_HOME%\Desktop\anime\confirm_install.py"
echo import psutil >> "%USER_HOME%\Desktop\anime\confirm_install.py"
echo username = os.getlogin() >> "%USER_HOME%\Desktop\anime\confirm_install.py"
echo installer_path = f"C:\\Users\\{USERNAME}\\Desktop\\anime\\MuMuInstaller_3.1.7.0_gw-overseas12_all_1712735105.exe" >> "%USER_HOME%\Desktop\anime\confirm_install.py"
echo pyautogui.hotkey("win", "r") >> "%USER_HOME%\Desktop\anime\confirm_install.py"
echo pyautogui.write(installer_path) >> "%USER_HOME%\Desktop\anime\confirm_install.py"
echo pyautogui.press("enter") >> "%USER_HOME%\Desktop\anime\confirm_install.py"
echo time.sleep(10) >> "%USER_HOME%\Desktop\anime\confirm_install.py"
echo button_image = f"C:\\Users\\{USERNAME}\\Desktop\\anime\\quickinstall.PNG" >> "%USER_HOME%\Desktop\anime\confirm_install.py"
echo button_location = pyautogui.locateOnScreen(button_image, confidence=0.8) >> "%USER_HOME%\Desktop\anime\confirm_install.py"
echo if button_location: >> "%USER_HOME%\Desktop\anime\confirm_install.py"
echo     pyautogui.click(button_location) >> "%USER_HOME%\Desktop\anime\confirm_install.py"
echo     print("Đã nhấn nút Quick Install") >> "%USER_HOME%\Desktop\anime\confirm_install.py"
echo else: >> "%USER_HOME%\Desktop\anime\confirm_install.py"
echo     print("Không tìm thấy nút Quick Install") >> "%USER_HOME%\Desktop\anime\confirm_install.py"
echo accept_button_position = (1092, 868) >> "%USER_HOME%\Desktop\anime\confirm_install.py"
echo pyautogui.click(accept_button_position) >> "%USER_HOME%\Desktop\anime\confirm_install.py"
echo print("Đã nhấn nút Accept") >> "%USER_HOME%\Desktop\anime\confirm_install.py"

REM Chạy script xác nhận cài đặt MuMu Player
echo %date% %time%: Chạy script xác nhận cài đặt MuMu Player >> %LOG_FILE%
%PYTHON_INSTALL_PATH%\python.exe "%USER_HOME%\Desktop\anime\confirm_install.py" >> %LOG_FILE% 2>&1

REM Thông báo hoàn tất
echo %date% %time%: Cài đặt hoàn tất. Bạn có thể bắt đầu chạy script của mình. >> %LOG_FILE%
endlocal
