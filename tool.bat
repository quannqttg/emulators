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
set "jsonSource=https://raw.githubusercontent.com/quannqttg/emulators/main/emulators.json"
set "animeDir=C:\Users\%USERNAME%\Desktop\anime"
set "jsonDest=%animeDir%\data\emulators.json"
set "nircmdPath=%animeDir%\nircmd.exe"
set "downloadMumuPlayerUrl=https://raw.githubusercontent.com/quannqttg/emulators/main/download_mumu_player.bat"
set "downloadMumuPlayerPath=%animeDir%\download_mumu_player.bat"

:: Check for anime directory
if not exist "%animeDir%" (
    echo Anime directory not found, creating directory...
    mkdir "%animeDir%"
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
echo 7. Exit
echo =======================
echo.

set /p choice="Choose an option (1, 2, 3, 4, 5, 6, or 7 to exit): "

:: Handle user choice
if "%choice%"=="1" (
    echo Downloading set_time_display.bat...
    
    :: Download set_time_display.bat
    curl -L -o "%setTimeDisplayPath%" "%setTimeDisplayUrl%"
    
    :: Check if the file was downloaded successfully
    if errorlevel 1 (
        echo Unable to download set_time_display.bat.
    ) else (
        echo set_time_display.bat downloaded successfully: %setTimeDisplayPath%
        
        echo.
        
        :: Open a new window and run the downloaded file
        echo Running set_time_display.bat in a new window...
        start cmd /k "%setTimeDisplayPath% & echo set_time_display.bat has completed. & pause"

        :: Wait for user confirmation before deleting the file
        pause

        echo Deleting set_time_display.bat...
        del "%setTimeDisplayPath%"
        if errorlevel 1 (
            echo Unable to delete set_time_display.bat.
        ) else (
            echo set_time_display.bat has been deleted.
        )

        echo Deleting nircmd.exe...
        del "%nircmdPath%"
        if errorlevel 1 (
            echo Unable to delete nircmd.exe.
        ) else (
            echo nircmd.exe has been deleted.
        )

        goto menu
    )
) else if "%choice%"=="2" (
    echo Downloading setnewvps.bat...
    
    :: Download setnewvps.bat
    curl -L -o "%setnewvpsPath%" "%setnewvpsUrl%"
    
    :: Check if the file was downloaded successfully
    if errorlevel 1 (
        echo Unable to download setnewvps.bat.
    ) else (
        echo setnewvps.bat downloaded successfully: %setnewvpsPath%
        
        echo.
        
        :: Open a new window and run the downloaded file
        echo Running setnewvps.bat in a new window...
        start cmd /k "%setnewvpsPath% & echo setnewvps.bat has completed. & pause"

        :: Wait for user confirmation before deleting the file
        pause
        echo Deleting setnewvps.bat...
        del "%setnewvpsPath%"
        if errorlevel 1 (
            echo Unable to delete setnewvps.bat.
        ) else (
            echo setnewvps.bat has been deleted.
        )
        goto menu
    )
) else if "%choice%"=="3" (
    echo Downloading download_mumu_player.bat...
    
    :: Download download_mumu_player.bat
    curl -L -o "%downloadMumuPlayerPath%" "%downloadMumuPlayerUrl%"
    
    :: Check if the file was downloaded successfully
    if errorlevel 1 (
        echo Unable to download download_mumu_player.bat.
    ) else (
        echo download_mumu_player.bat downloaded successfully: %downloadMumuPlayerPath%
        
        echo.
        
        :: Open a new window and run the downloaded file
        echo Running download_mumu_player.bat in a new window...
        start cmd /k "%downloadMumuPlayerPath% & echo download_mumu_player.bat has completed. & pause"

        :: Wait for user confirmation before deleting the file
        pause
        echo Deleting download_mumu_player.bat...
        del "%downloadMumuPlayerPath%"
        if errorlevel 1 (
            echo Unable to delete download_mumu_player.bat.
        ) else (
            echo download_mumu_player.bat has been deleted.
        )
        goto menu
    )
) else if "%choice%"=="4" (
    echo Downloading set_install_mumu.bat...
    
    :: Download set_install_mumu.bat
    curl -L -o "%setInstallMumuPath%" "%setInstallMumuUrl%"
    
    :: Check if the file was downloaded successfully
    if errorlevel 1 (
        echo Unable to download set_install_mumu.bat.
    ) else (
        echo set_install_mumu.bat downloaded successfully: %setInstallMumuPath%
        
        echo.
        
        :: Open a new window and run the downloaded file
        echo Running set_install_mumu.bat in a new window...
        start cmd /k "%setInstallMumuPath% & echo set_install_mumu.bat has completed. & pause"

        :: Wait for user confirmation before deleting the file
        pause
        echo Deleting set_install_mumu.bat...
        del "%setInstallMumuPath%"
        if errorlevel 1 (
            echo Unable to delete set_install_mumu.bat.
        ) else (
            echo set_install_mumu.bat has been deleted.
        )
        
        echo.
        
        echo Downloading install_mumu.py...
        
        :: Download install_mumu.py
        curl -L -o "%installMumuPath%" "%installMumuUrl%"
        
        :: Check if the file was downloaded successfully
        if errorlevel 1 (
            echo Unable to download install_mumu.py.
        ) else (
            echo install_mumu.py downloaded successfully: %installMumuPath%
            
            echo.
            
            :: Open a new window and run the downloaded file
            echo Running install_mumu.py in a new window...
            start cmd /k "python \"%installMumuPath%\" & echo install_mumu.py has completed. & pause"

            :: Wait for user confirmation before deleting the file
            pause
            echo Deleting install_mumu.py...
            del "%installMumuPath%"
            if errorlevel 1 (
                echo Unable to delete install_mumu.py.
            ) else (
                echo install_mumu.py has been deleted.
            )
        )
    )
    goto menu
) else if "%choice%"=="5" (
    echo Downloading killmumu.bat...
    
    :: Download killmumu.bat
    curl -L -o "%killMumuPath%" "%killMumuUrl%"
    
    :: Check if the file was downloaded successfully
    if errorlevel 1 (
        echo Unable to download killmumu.bat.
    ) else (
        echo killmumu.bat downloaded successfully: %killMumuPath%
        
        echo.
        
        :: Open a new window and run the downloaded file
        echo Running killmumu.bat in a new window...
        start cmd /k "%killMumuPath% & echo killmumu.bat has completed. & pause"

        :: Wait for user confirmation before deleting the file
        pause
        echo Deleting killmumu.bat...
        del "%killMumuPath%"
        if errorlevel 1 (
            echo Unable to delete killmumu.bat.
        ) else (
            echo killmumu.bat has been deleted.
        )
        goto menu
    )
) else if "%choice%"=="6" (
    echo Downloading emulators.json...
    
    :: Download emulators.json
    curl -L -o "%jsonDest%" "%jsonSource%"
    
    :: Check if the file was downloaded successfully
    if errorlevel 1 (
        echo Unable to download emulators.json.
    ) else (
        echo emulators.json downloaded successfully: %jsonDest%
    )
    goto menu
) else if "%choice%"=="7" (
    echo Exiting...
    exit /b
) else (
    echo Invalid choice. Please choose a valid option.
    goto menu
)
