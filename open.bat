@echo off
set "chromePath=C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"

:: Danh sách các URL
set "url1=https://drive.usercontent.google.com/download?id=1dQJWMbxLfj27LcejWbt_v9nu0UPbyu8K&export=download"
set "url2=https://drive.usercontent.google.com/download?id=1F72KbbHF3ZNF3RKDQNLLQcZ8wNV1t-KA&export=download"

if exist "%chromePath%" (
    start "" "%chromePath%" "%url1%"
    start "" "%chromePath%" "%url2%"
) else (
    echo Khong tim thay trinh duyet Chrome.
)
