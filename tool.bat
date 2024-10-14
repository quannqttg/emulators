@echo off
setlocal

:: Định nghĩa các URL tải về và đường dẫn
set "setTimeDisplayUrl=https://raw.githubusercontent.com/quannqttg/emulators/main/set_time_display.bat"
set "setTimeDisplayPath=C:\Users\%USERNAME%\Desktop\anime\set_time_display.bat"
set "setnewvpsUrl=https://raw.githubusercontent.com/quannqttg/emulators/main/setnewvps.bat"
set "setnewvpsPath=C:\Users\%USERNAME%\Desktop\anime\setnewvps.bat"
set "setInstallMumuUrl=https://raw.githubusercontent.com/quannqttg/emulators/main/set_install_mumu.bat"
set "setInstallMumuPath=C:\Users\%USERNAME%\Desktop\anime\set_install_mumu.bat"
set "installMumuUrl=https://raw.githubusercontent.com/quannqttg/emulators/main/install_mumu.py"
set "installMumuPath=C:\Users\%USERNAME%\Desktop\anime\install_mumu.py"
set "killMumuUrl=https://raw.githubusercontent.com/quannqttg/emulators/main/killmumu.bat"
set "killMumuPath=C:\Users\%USERNAME%\Desktop\anime\killmumu.bat"
set "jsonSource=https://raw.githubusercontent.com/quannqttg/emulators/main/emulators.json"
set "animeDir=C:\Users\%USERNAME%\Desktop\anime"
set "jsonDest=%animeDir%\data\emulators.json"
set "nircmdPath=%animeDir%\nircmd.exe"

:: Kiểm tra thư mục anime
if not exist "%animeDir%" (
    mkdir "%animeDir%"
)

:menu
:: Hiển thị tùy chọn
echo =======================
echo 1. Setting time and display
echo 2. Setting new VPS
echo 3. Install Mumu Player
echo 4. Kill Mumu Player
echo 5. Update Mumu Data
echo 6. Thoat
echo =======================
echo.

set /p choice="Chon mot tuy chon (1, 2, 3, 4, 5 hoac 6 de thoat): "

:: Xử lý lựa chọn của người dùng
if "%choice%"=="1" (
    echo Dang tai tep set_time_display.bat...
    
    :: Tải tệp set_time_display.bat
    curl -L -o "%setTimeDisplayPath%" "%setTimeDisplayUrl%"
    
    :: Kiểm tra xem tệp đã được tải xuống thành công
    if errorlevel 1 (
        echo Khong the tai tep set_time_display.bat.
    ) else (
        echo Tep set_time_display.bat da duoc tai xuong thanh cong: %setTimeDisplayPath%
        
        echo.
        
        :: Mở cửa sổ mới và chạy tệp vừa tải xuống
        echo Dang chay tep set_time_display.bat trong cua so moi...
        start cmd /k "%setTimeDisplayPath% & echo Tep set_time_display.bat da hoan thanh. & pause"

        :: Đợi người dùng xác nhận trước khi xóa tệp
        pause
        del "%setTimeDisplayPath%"
        del "%nircmdPath%"  :: Xóa tệp nircmd.exe

        goto menu
    )
) else if "%choice%"=="2" (
    echo Dang tai tep setnewvps.bat...
    
    :: Tải tệp setnewvps.bat
    curl -L -o "%setnewvpsPath%" "%setnewvpsUrl%"
    
    :: Kiểm tra xem tệp đã được tải xuống thành công
    if errorlevel 1 (
        echo Khong the tai tep setnewvps.bat.
    ) else (
        echo Tep setnewvps.bat da duoc tai xuong thanh cong: %setnewvpsPath%
        
        echo.
        
        :: Mở cửa sổ mới và chạy tệp vừa tải xuống
        echo Dang chay tep setnewvps.bat trong cua so moi...
        start cmd /k "%setnewvpsPath% & echo Tep setnewvps.bat da hoan thanh. & pause"

        :: Đợi người dùng xác nhận trước khi xóa tệp
        pause
        del "%setnewvpsPath%"
        goto menu
    )
) else if "%choice%"=="3" (
    echo Dang tai tep set_install_mumu.bat...
    
    :: Tải tệp set_install_mumu.bat
    curl -L -o "%setInstallMumuPath%" "%setInstallMumuUrl%"
    
    :: Kiểm tra xem tệp đã được tải xuống thành công
    if errorlevel 1 (
        echo Khong the tai tep set_install_mumu.bat.
    ) else (
        echo Tep set_install_mumu.bat da duoc tai xuong thanh cong: %setInstallMumuPath%
        
        echo.
        
        :: Mở cửa sổ mới và chạy tệp vừa tải xuống
        echo Dang chay tep set_install_mumu.bat trong cua so moi...
        start cmd /k "%setInstallMumuPath% & echo Tep set_install_mumu.bat da hoan thanh. & pause"

        :: Đợi người dùng xác nhận trước khi xóa tệp
        pause
        del "%setInstallMumuPath%"
        
        echo.
        
        echo Dang tai tep install_mumu.py...
        
        :: Tải tệp install_mumu.py
        curl -L -o "%installMumuPath%" "%installMumuUrl%"
        
        :: Kiểm tra xem tệp đã được tải xuống thành công
        if errorlevel 1 (
            echo Khong the tai tep install_mumu.py.
        ) else (
            echo Tep install_mumu.py da duoc tai xuong thanh cong: %installMumuPath%
            
            echo.
            
            :: Mở cửa sổ mới và chạy tệp vừa tải xuống
            echo Dang chay tep install_mumu.py trong cua so moi...
            start cmd /k "python \"%installMumuPath%\" & echo Tep install_mumu.py da hoan thanh. & pause"

            :: Đợi người dùng xác nhận trước khi xóa tệp
            pause
            del "%installMumuPath%"
        )
    )
    goto menu
) else if "%choice%"=="4" (
    echo Dang tai tep killmumu.bat...
    
    :: Tải tệp killmumu.bat
    curl -L -o "%killMumuPath%" "%killMumuUrl%"
    
    :: Kiểm tra xem tệp đã được tải xuống thành công
    if errorlevel 1 (
        echo Khong the tai tep killmumu.bat.
    ) else (
        echo Tep killmumu.bat da duoc tai xuong thanh cong: %killMumuPath%
        
        echo.
        
        :: Mở cửa sổ mới và chạy tệp vừa tải xuống
        echo Dang chay tep killmumu.bat trong cua so moi...
        start cmd /k "%killMumuPath% & echo Tep killmumu.bat da hoan thanh. & pause"

        :: Đợi người dùng xác nhận trước khi xóa tệp
        pause
        del "%killMumuPath%"
        goto menu
    )
) else if "%choice%"=="5" (
    echo Dang tai tep emulators.json...
    
    :: Tải tệp emulators.json
    curl -L -o "%jsonDest%" "%jsonSource%"
    
    :: Kiểm tra xem tệp đã được tải xuống thành công
    if errorlevel 1 (
        echo Khong the tai tep emulators.json.
    ) else (
        echo Tep emulators.json da duoc tai xuong thanh cong: %jsonDest%
    )
    goto menu
) else if "%choice%"=="6" (
    exit /b
) else (
    echo Lua chon khong hop le. Vui long chon tu 1 den 6 de thoat.
    goto menu
)
