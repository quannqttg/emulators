import pyautogui
import time
import os
import subprocess

# Xác định tên người dùng
username = os.getlogin()  # Lấy tên người dùng hiện tại

# Đường dẫn đến trình cài đặt MuMu Player
installer_path = f"C:\\Users\\{username}\\Desktop\\anime\\MuMuInstaller_3.1.7.0_gw-overseas12_all_1712735105.exe"

# Chạy trình cài đặt MuMu Player
pyautogui.hotkey("win", "r")
pyautogui.write(installer_path)
pyautogui.press("enter")

# Đợi ứng dụng mở ra
time.sleep(10)

# Đường dẫn đến ảnh nút "Quick Install"
button_image = f"C:\\Users\\{username}\\Desktop\\anime\\quickinstall.PNG"

# Tìm hình ảnh nút trên màn hình
button_location = pyautogui.locateOnScreen(button_image, confidence=0.8)

# Nếu tìm thấy nút, nhấp vào vị trí đó
if button_location:
    pyautogui.click(button_location)
    print("Đã nhấn nút Quick Install")

    # Tạo thời gian chờ 180 giây để hoàn tất quá trình cài đặt
    time.sleep(180)

    # Đóng cửa sổ Chrome mới hiện lên nếu có
    # Đây là cách đóng các cửa sổ Chrome dựa trên tên tiến trình
    try:
        subprocess.call(["taskkill", "/F", "/IM", "chrome.exe"])
        print("Đã đóng cửa sổ Chrome.")
    except Exception as e:
        print(f"Không thể đóng Chrome: {e}")

    # Đường dẫn đến ảnh nút "Accept"
    accept_button_image = f"C:\\Users\\{username}\\Desktop\\anime\\accept.PNG"
    
    # Tìm hình ảnh nút Accept trên màn hình
    accept_location = pyautogui.locateOnScreen(accept_button_image, confidence=0.8)

    # Nếu tìm thấy nút Accept, nhấp vào vị trí đó
    if accept_location:
        pyautogui.click(accept_location)
        print("Đã nhấn nút Accept")
    else:
        print("Không tìm thấy nút Accept")
else:
    print("Không tìm thấy nút Quick Install")
