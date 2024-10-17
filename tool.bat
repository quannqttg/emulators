@echo off
setlocal

:: Define download URLs and paths
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
set "nircmdPath=C:\Users\%USERNAME%\Desktop\anime\nircmd.exe"
set "downloadMumuPlayerUrl=https://raw.githubusercontent.com/quannqttg/emulators/main/download_mumu_player.bat"
set "downloadMumuPlayerPath=C:\Users\%USERNAME%\Desktop\anime\download_mumu_player.bat"
set "updateMumuDataUrl=https://raw.githubusercontent.com/quannqttg/emulators/main/update_mumu_data.bat"
set "updateMumuDataPath=C:\Users\%USERNAME%\Desktop\anime\update_mumu_data.bat"
set "getDeviceKeyUrl=https://raw.githubusercontent.com/quannqttg/emulators/main/get_device_key.bat"
set "getDeviceKeyPath=C:\Users\%USERNAME%\Desktop\anime\get_device_key.bat"
set "getSetKeyUrl=https://raw.githubusercontent.com/quannqttg/emulators/main/set_key.bat"
set "getSetKeyPath=C:\Users\%USERNAME%\Desktop\anime\set_key.bat"

:: Check for anime directory
if not exist "C:\Users\%USERNAME%\Desktop\anime" (
    echo Anime directory not found, creating directory...
    mkdir "C:\Users\%USERNAME%\Desktop\anime"
)

:menu
:: Display options
echo =======================
echo 1. Setting time and display
echo 2. Setting new VPS
echo 3. Download Mumu Player
echo 4. Install Mumu Player
echo 5. Kill Mumu Player
echo 6. Update Mumu Data
echo 7. Get Device Key
echo 8. Set Device Key
echo 9. Exit
echo =======================
echo.

set /p choice="Choose an option (1-9): "

:: Function to download a file
:downloadFile
set "url=%~1"
set "outputPath=%~2"
echo Downloading %outputPath%...
curl -L -o "%outputPath%" "%url%"
if errorlevel 1 (
    echo Unable to download %outputPath%.
    exit /b 1
) else (
    echo %outputPath% downloaded successfully.
)
exit /b 0

:: Function to run a downloaded file
:runFile
set "filePath=%~1"
echo Running %filePath% in a new window...
start cmd /k "%filePath% & echo %filePath% has completed. & pause"
exit /b 0

:: Function to delete a file
:deleteFile
set "filePath=%~1"
echo Deleting %filePath%...
del "%filePath%"
if errorlevel 1 (
    echo Unable to delete %filePath%.
) else (
    echo %filePath% has been deleted.
)
exit /b 0

:: Handle user choice
if "%choice%"=="1" (
    call :downloadFile "%setTimeDisplayUrl%" "%setTimeDisplayPath%"
    call :runFile "%setTimeDisplayPath%"
    pause
    call :deleteFile "%setTimeDisplayPath%"
    call :deleteFile "%nircmdPath%"
    goto menu
) else if "%choice%"=="2" (
    call :downloadFile "%setnewvpsUrl%" "%setnewvpsPath%"
    call :runFile "%setnewvpsPath%"
    pause
    call :deleteFile "%setnewvpsPath%"
    goto menu
) else if "%choice%"=="3" (
    call :downloadFile "%downloadMumuPlayerUrl%" "%downloadMumuPlayerPath%"
    call :runFile "%downloadMumuPlayerPath%"
    pause
    call :deleteFile "%downloadMumuPlayerPath%"
    goto menu
) else if "%choice%"=="4" (
    call :downloadFile "%setInstallMumuUrl%" "%setInstallMumuPath%"
    call :runFile "%setInstallMumuPath%"
    pause
    call :deleteFile "%setInstallMumuPath%"
    
    call :downloadFile "%installMumuUrl%" "%installMumuPath%"
    call :runFile "%installMumuPath%"
    pause
    call :deleteFile "%installMumuPath%"
    goto menu
) else if "%choice%"=="5" (
    call :downloadFile "%killMumuUrl%" "%killMumuPath%"
    call :runFile "%killMumuPath%"
    pause
    call :deleteFile "%killMumuPath%"
    goto menu
) else if "%choice%"=="6" (
    call :downloadFile "%updateMumuDataUrl%" "%updateMumuDataPath%"
    call :runFile "%updateMumuDataPath%"
    pause
    call :deleteFile "%updateMumuDataPath%"
    goto menu
) else if "%choice%"=="7" (
    call :downloadFile "%getDeviceKeyUrl%" "%getDeviceKeyPath%"
    call :runFile "%getDeviceKeyPath%"
    pause
    call :deleteFile "%getDeviceKeyPath%"
    goto menu
) else if "%choice%"=="8" (
    call :downloadFile "%getSetKeyUrl%" "%getSetKeyPath%"
    call :runFile "%getSetKeyPath%"
    pause
    call :deleteFile "%getSetKeyPath%"
    goto menu
) else if "%choice%"=="9" (
    echo Exiting...
    exit /b
) else (
    echo Invalid option, please try again.
    goto menu
)
