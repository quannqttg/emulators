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
set "getUpdateConfigsUrl=https://raw.githubusercontent.com/quannqttg/emulators/main/update_configs.bat"
set "getUpdateConfigsPath=C:\Users\%USERNAME%\Desktop\anime\update_configs.bat"
set "getUninstallMuMuUrl=https://raw.githubusercontent.com/quannqttg/emulators/main/uninstall.bat"
set "getUninstallMuMuPath=C:\Users\%USERNAME%\Desktop\anime\uninstall.bat"


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
echo 7. Update Connfis 
echo 8. Uninstall MuMu
echo 9. Exit
echo =======================
echo.

set /p choice="Choose an option (1, 2, 3, 4, 5, 6, 7, 8, or 9 to exit): "

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
    
    if errorlevel 1 (
        echo Unable to download killmumu.bat.
    ) else (
        echo killmumu.bat downloaded successfully: %killMumuPath%
        
        echo Running killmumu.bat in a new window...
        start cmd /k "%killMumuPath% & echo killmumu.bat has completed. & pause"

        pause
        echo Deleting killmumu.bat...
        del "%killMumuPath%"
        if errorlevel 1 (
            echo Unable to delete killmumu.bat.
        ) else (
            echo killmumu.bat has been deleted.
        )
    )
    goto menu

) else if "%choice%"=="6" (
    echo Downloading update_mumu_data.bat...
    
    :: Download update_mumu_data.bat
    curl -L -o "%updateMumuDataPath%" "%updateMumuDataUrl%"
    
    :: Check if the file was downloaded successfully
    if errorlevel 1 (
        echo Unable to download update_mumu_data.bat.
    ) else (
        echo update_mumu_data.bat downloaded successfully: %updateMumuDataPath%
        echo.
        
        :: Open a new window and run the downloaded file
        echo Running update_mumu_data.bat in a new window...
        start cmd /k "%updateMumuDataPath% & echo update_mumu_data.bat has completed. & pause"

        :: Wait for user confirmation before deleting the file
        pause
        echo Deleting update_mumu_data.bat...
        del "%updateMumuDataPath%"
        if errorlevel 1 (
            echo Unable to delete update_mumu_data.bat.
        ) else (
            echo update_mumu_data.bat has been deleted.
        )
    )
    goto menu

) else if "%choice%"=="7" (
    echo Downloading update_configs.bat...

    :: Download update_configs.bat
    curl -L -o "%getUpdateConfigsPath%" "%getUpdateConfigsUrl%"

    :: Check if the file was downloaded successfully
    if errorlevel 1 (
        echo Unable to download update_configs.bat.
    ) else (
        echo update_configs.bat downloaded successfully: %getUpdateConfigsPath%
        echo.

        :: Open a new window and run the downloaded file
        echo Running update_configs.bat in a new window...
        start cmd /c "%getUpdateConfigsPath% & echo update_configs.bat has completed. & pause"

        :: Wait for user confirmation before deleting the file
        pause
        echo Deleting update_configs.bat...
        del "%getUpdateConfigsPath%"
        if errorlevel 1 (
            echo Unable to delete update_configs.bat.
        ) else (
            echo update_configs.bat has been deleted.
        )
    )
    goto menu
) else if "%choice%"=="8" (
    echo Downloading uninstall.bat...

    echo Downloading uninstall.bat...
	curl -L -o "%getUninstallMuMuPath%" "%getUninstallMuMuUrl%"

    :: Check if the file was downloaded successfully
    if errorlevel 1 (
        echo Unable to download uninstall.bat.
    ) else (
        echo uninstall.bat downloaded successfully: %getUninstallMuMuPath%
        echo.

        :: Open a new window and run the downloaded file
        echo Running uninstall.bat in a new window...
        start cmd /c "%getUninstallMuMuPath% & echo update_configs.bat has completed. & pause"

        :: Wait for user confirmation before deleting the file
        pause
        echo Deleting uninstall.bat...
        del "%getUninstallMuMuPath%"
        if errorlevel 1 (
            echo Unable to delete uninstall.bat.
        ) else (
            echo uninstall.bat has been deleted.
        )
    )
    goto menu
) else if "%choice%"=="9" (
    echo Exiting...
    exit /b
) else (
    echo Invalid option, please try again.
    goto menu
)
