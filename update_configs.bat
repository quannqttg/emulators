@echo off
setlocal

:: Define download URLs and paths
set "getDeivceKeyUrl=https://raw.githubusercontent.com/quannqttg/emulators/main/get_device_key.bat"
set "getDeivceKeyPath=C:\Users\%USERNAME%\Desktop\anime\get_device_key.bat"
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
echo 1. Get Device Key
echo 2. Set Device Key
echo 3. Exit
echo =======================
echo.

set /p choice="Choose an option (1, 2, or 3 to exit): "

:: Handle user choice
if "%choice%"=="1" (
    echo Downloading get_device_key.bat...

    :: Download get_device_key.bat
    curl -L -o "%getDeivceKeyPath%" "%getDeivceKeyUrl%"

    :: Check if the file was downloaded successfully
    if errorlevel 1 (
        echo Unable to download get_device_key.bat.
    ) else (
        echo get_device_key.bat downloaded successfully: %getDeivceKeyPath%
        echo.

        :: Open a new window and run the downloaded file
        echo Running get_device_key.bat in a new window...
        start cmd /c "%getDeivceKeyPath% & echo get_device_key.bat has completed. & pause"

        :: Wait for user confirmation before deleting the file
        pause
        echo Deleting get_device_key.bat...
        del "%getDeivceKeyPath%"
        if errorlevel 1 (
            echo Unable to delete get_device_key.bat.
        ) else (
            echo get_device_key.bat has been deleted.
        )
    )
    goto menu
) else if "%choice%"=="2" (
    echo Downloading set_key.bat...

    echo Downloading set_key.bat...
	curl -L -o "%getSetKeyPath%" "%getSetKeyUrl%"

    :: Check if the file was downloaded successfully
    if errorlevel 1 (
        echo Unable to download set_key.bat.
    ) else (
        echo set_key.bat downloaded successfully: %getSetKeyPath%
        echo.

        :: Open a new window and run the downloaded file
        echo Running set_key.bat in a new window...
        start cmd /c "%getSetKeyPath% & echo get_device_key.bat has completed. & pause"

        :: Wait for user confirmation before deleting the file
        pause
        echo Deleting set_key.bat...
        del "%getSetKeyPath%"
        if errorlevel 1 (
            echo Unable to delete set_key.bat.
        ) else (
            echo set_key.bat has been deleted.
        )
    )
    goto menu
) else if "%choice%"=="3" (
    echo Exiting...
    exit /b
) else (
    echo Invalid option, please try again.
    goto menu
)
