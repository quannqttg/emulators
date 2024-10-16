@echo off
set "chromePath=C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"

:: Danh sách các URL
set "url1=https://drive.usercontent.google.com/download?id=1dQJWMbxLfj27LcejWbt_v9nu0UPbyu8K&export=download"

if exist "%chromePath%" (
    start "" "%chromePath%" "%url1%"    
) else (
    echo Khong tim thay trinh duyet Chrome.
)
