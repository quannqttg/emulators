@echo off
setlocal

:: Define log file path
set "logFile=C:\Users\%USERNAME%\Desktop\anime\update_configs_log.txt"
:: Clear previous log file
> "%logFile%" echo Script log for %DATE% %TIME%:

:: Define download URLs and paths
set "getDeivceKeyUrl=https://raw.githubusercontent.com/quannqttg/emulators/main/get_device_key.bat"
set "getDeivceKeyPath=C:\Users\%USERNAME%\Desktop\anime\get_device_key.bat"
set "getSetKeyUrl=https://raw.githubusercontent.com/quannqttg/emulators/main/set_key.bat"
set "getSetKeyPath=C:\Users\%USERNAME%\Desktop\anime\set_key.bat"

:: Check for anime directory
if not exist "C:\Users\%USERNAME%\Desktop\anime" (
    echo Anime directory not found, creating directory... >> "%logFile%"
    mkdir "C:\Users\%USERNAME%\Desktop\anime"
) else (
    echo Anime directory exists. >> "%logFile%"
)

:menu
:: Display options
echo ======================= >> "%logFile%"
echo 1. Get Device Key >> "%logFile%"
echo 2. Set Device Key >> "%logFile%"
echo 3. Exit >> "%logFile%"
echo ======================= >> "%logFile%"
echo. >> "%logFile%"

set /p choice="Choose an option (1, 2, or 3 to exit): "

:: Handle user choice
if "%choice%"=="1" (
    echo Downloading get_device_key.bat... >> "%logFile%"

    :: Download get_device_key.bat
    curl -L -o "%getDeivceKeyPath%" "%getDeivceKeyUrl%"
    
    :: Log download result
    if errorlevel 1 (
        echo Unable to download get_device_key.bat. >> "%logFile%"
    ) else (
        echo get_device_key.bat downloaded successfully: %getDeivceKeyPath% >> "%logFile%"
        echo. >> "%logFile%"

        :: Open a new window and run the downloaded file
        echo Running get_device_key.bat in a new window... >> "%logFile%"
        start cmd /c "%getDeivceKeyPath% & echo get_device_key.bat has completed. & pause"

        :: Wait for user confirmation before deleting the file
        pause
        echo Deleting get_device_key.bat... >> "%logFile%"
        del "%getDeivceKeyPath%"
        if errorlevel 1 (
            echo Unable to delete get_device_key.bat. >> "%logFile%"
        ) else (
            echo get_device_key.bat has been deleted. >> "%logFile%"
        )
    )
    goto menu
) else if "%choice%"=="2" (
    echo Downloading set_key.bat... >> "%logFile%"

    :: Download set_key.bat
    curl -L -o "%getSetKeyPath%" "%getSetKeyUrl%"

    :: Check if the file was downloaded successfully
    if errorlevel 1 (
        echo Unable to download set_key.bat. >> "%logFile%"
    ) else (
        echo set_key.bat downloaded successfully: %getSetKeyPath% >> "%logFile%"
        echo. >> "%logFile%"

        :: Open a new window and run the downloaded file
        echo Running set_key.bat in a new window... >> "%logFile%"
        start cmd /c "%getSetKeyPath% & echo set_key.bat has completed. & pause"

        :: Wait for user confirmation before deleting the file
        pause
        echo Deleting set_key.bat... >> "%logFile%"
        del "%getSetKeyPath%"
        if errorlevel 1 (
            echo Unable to delete set_key.bat. >> "%logFile%"
        ) else (
            echo set_key.bat has been deleted. >> "%logFile%"
        )
    )
    goto menu
) else if "%choice%"=="3" (
    echo Exiting... >> "%logFile%"
    exit /b
) else (
    echo Invalid option, please try again. >> "%logFile%"
    goto menu
)
