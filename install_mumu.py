import pyautogui
import time
import os
import subprocess
import psutil

# Hàm tìm cửa sổ Chrome và giữ lại cửa sổ đầu tiên
def keep_first_chrome_window():
    chrome_windows = [proc for proc in psutil.process_iter(['pid', 'name']) if proc.info['name'] == 'chrome.exe']
    if chrome_windows:
        # Giữ lại PID của cửa sổ Chrome đầu tiên
        first_chrome_pid = chrome_windows[0].pid
        print(f"Giữ lại cửa sổ Chrome với PID: {first_chrome_pid}")

        # Đóng các cửa sổ Chrome khác
        for window in chrome_windows:
            if window.pid != first_chrome_pid:
                window.terminate()  # Đóng cửa sổ Chrome không phải là cửa sổ đầu tiên
        print("Đã đóng các cửa sổ Chrome khác.")
    else:
        print("Không tìm thấy cửa sổ Chrome nào.")

# Xác định tên người dùng
username = os.getlogin()  # Lấy tên người dùng hiện tại

# Đường dẫn đến trình cài đặt MuMu Player
installer_path = f"C:\\Users\\{username}\\Desktop\\anime\\MuMuInstaller_3.1.7.0_gw-overseas12_all_1712735105.exe"

# Giữ lại cửa sổ Chrome 1 và đóng các cửa sổ Chrome khác
keep_first_chrome_window()

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

    # Tọa độ của nút Accept
    accept_button_position = (1092, 868)  # Tọa độ đã xác định

    # Nhấp vào nút Accept
    pyautogui.click(accept_button_position)
    print("Đã nhấn nút Accept")

    # Đợi một chút trước khi kiểm tra
    time.sleep(5)

    # Đóng tất cả các cửa sổ Chrome đang mở
    for proc in psutil.process_iter(['pid', 'name']):
        if proc.info['name'] == 'chrome.exe' and proc.pid != first_chrome_pid:
            proc.terminate()  # Đóng cửa sổ Chrome không phải là cửa sổ đầu tiên
    print("Đã đóng các cửa sổ Chrome sau khi nhấn nút Accept.")

else:
    print("Không tìm thấy nút Quick Install")
