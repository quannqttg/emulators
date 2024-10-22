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
set "createKeyUrl=https://raw.githubusercontent.com/quannqttg/emulators/main/create_key.bat"
set "createKeyPath=C:\Users\%USERNAME%\Desktop\anime\create_key.bat"
set "createPathUrl=https://raw.githubusercontent.com/quannqttg/emulators/main/create_path.bat"
set "createPathPath=C:\Users\%USERNAME%\Desktop\anime\create_path.bat"
set "googleDnsUrl=https://raw.githubusercontent.com/quannqttg/emulators/main/google_dns.bat"
set "cloudflareDnsUrl=https://raw.githubusercontent.com/quannqttg/emulators/main/cloudflare_dns.bat"
set "openDnsUrl=https://raw.githubusercontent.com/quannqttg/emulators/main/open_dns.bat"
set "googleDnsPath=C:\Users\%USERNAME%\Desktop\anime\google_dns.bat"
set "cloudflareDnsPath=C:\Users\%USERNAME%\Desktop\anime\cloudflare_dns.bat"
set "openDnsPath=C:\Users\%USERNAME%\Desktop\anime\open_dns.bat"

:: Check for anime directory
if not exist "C:\Users\%USERNAME%\Desktop\anime" (
    echo Anime directory not found, creating directory... >> "%logFile%"
    mkdir "C:\Users\%USERNAME%\Desktop\anime"
) else (
    echo Anime directory exists. >> "%logFile%"
)

:menu
:: Display options to both the log file and the screen
echo =======================
echo 1. Create Device and Path (Auto runs options 1 and 3)
echo 2. Get Device
echo 3. Set Device Key
echo 4. Set Google DNS
echo 5. Set Cloudflare DNS
echo 6. Set Open DNS
echo 7. Exit
echo =======================
echo.

:: Log the options
echo ======================= >> "%logFile%"
echo 1. Create Device and Path (Auto runs options 1 and 3) >> "%logFile%"
echo 2. Get Device >> "%logFile%"
echo 3. Set Device Key >> "%logFile%"
echo 4. Set Google DNS >> "%logFile%"
echo 5. Set Cloudflare DNS >> "%logFile%"
echo 6. Set Open DNS >> "%logFile%"
echo 7. Exit >> "%logFile%"
echo ======================= >> "%logFile%"
echo. >> "%logFile%"

set /p choice="Choose an option (1, 2, 3, 4, 5, 6, or 7 to exit): "

:: Handle user choice
if "%choice%"=="1" (
    echo Option 1 selected: Create Device and Path >> "%logFile%"
    
    :: Download create_key.bat
    echo Downloading create_key.bat... >> "%logFile%"
    curl -L -o "%createKeyPath%" "%createKeyUrl%"
    
    :: Check if the file was downloaded successfully
    if errorlevel 1 (
        echo Unable to download create_key.bat. >> "%logFile%"
    ) else (
        echo create_key.bat downloaded successfully: %createKeyPath% >> "%logFile%"
        echo. >> "%logFile%"
        
        :: Run create_key.bat in a new window and wait for it to close
        echo Running create_key.bat in a new window... >> "%logFile%"
        start "" /wait cmd /c "%createKeyPath%"
        
        :: After the script finishes, delete the file
        echo Deleting create_key.bat... >> "%logFile%"
        del "%createKeyPath%"
        if errorlevel 1 (
            echo Unable to delete create_key.bat. >> "%logFile%"
        ) else (
            echo create_key.bat has been deleted. >> "%logFile%"
        )
    )
    
    :: Download create_path.bat
    echo Downloading create_path.bat... >> "%logFile%"
    curl -L -o "%createPathPath%" "%createPathUrl%"
    
    :: Check if the file was downloaded successfully
    if errorlevel 1 (
        echo Unable to download create_path.bat. >> "%logFile%"
    ) else (
        echo create_path.bat downloaded successfully: %createPathPath% >> "%logFile%"
        echo. >> "%logFile%"
        
        :: Run create_path.bat in a new window and wait for it to close
        echo Running create_path.bat in a new window... >> "%logFile%"
        start "" /wait cmd /c "%createPathPath%"
        
        :: After the script finishes, delete the file
        echo Deleting create_path.bat... >> "%logFile%"
        del "%createPathPath%"
        if errorlevel 1 (
            echo Unable to delete create_path.bat. >> "%logFile%"
        ) else (
            echo create_path.bat has been deleted. >> "%logFile%"
        )
    )
    
    :: Automatically run Set Device Key
    echo Downloading set_key.bat... >> "%logFile%"
    
    :: Download set_key.bat
    curl -L -o "%getSetKeyPath%" "%getSetKeyUrl%"
    
    :: Check if the file was downloaded successfully
    if errorlevel 1 (
        echo Unable to download set_key.bat. >> "%logFile%"
    ) else (
        echo set_key.bat downloaded successfully: %getSetKeyPath% >> "%logFile%"
        echo. >> "%logFile%"
        
        :: Run set_key.bat in a new window and wait for it to close
        echo Running set_key.bat in a new window... >> "%logFile%"
        start "" /wait cmd /c "%getSetKeyPath%"
        
        :: After the script finishes, delete the file
        echo Deleting set_key.bat... >> "%logFile%"
        del "%getSetKeyPath%"
        if errorlevel 1 (
            echo Unable to delete set_key.bat. >> "%logFile%"
        ) else (
            echo set_key.bat has been deleted. >> "%logFile%"
        )
    )
    
    goto menu
) else if "%choice%"=="2" (
    echo Downloading get_device_key.bat... >> "%logFile%"
    
    :: Download get_device_key.bat
    curl -L -o "%getDeivceKeyPath%" "%getDeivceKeyUrl%"
    
    :: Log download result
    if errorlevel 1 (
        echo Unable to download get_device_key.bat. >> "%logFile%"
    ) else (
        echo get_device_key.bat downloaded successfully: %getDeivceKeyPath% >> "%logFile%"
        echo. >> "%logFile%"
        
        :: Run get_device_key.bat in a new window and wait for it to close
        echo Running get_device_key.bat in a new window... >> "%logFile%"
        start "" /wait cmd /c "%getDeivceKeyPath%"
        
        :: After the script finishes, delete the file
        echo Deleting get_device_key.bat... >> "%logFile%"
        del "%getDeivceKeyPath%"
        if errorlevel 1 (
            echo Unable to delete get_device_key.bat. >> "%logFile%"
        ) else (
            echo get_device_key.bat has been deleted. >> "%logFile%"
        )
    )
    goto menu
) else if "%choice%"=="3" (
    echo Downloading set_key.bat... >> "%logFile%"
    
    :: Download set_key.bat
    curl -L -o "%getSetKeyPath%" "%getSetKeyUrl%"
    
    :: Check if the file was downloaded successfully
    if errorlevel 1 (
        echo Unable to download set_key.bat. >> "%logFile%"
    ) else (
        echo set_key.bat downloaded successfully: %getSetKeyPath% >> "%logFile%"
        echo. >> "%logFile%"
        
        :: Run set_key.bat in a new window and wait for it to close
        echo Running set_key.bat in a new window... >> "%logFile%"
        start "" /wait cmd /c "%getSetKeyPath%"
        
        :: After the script finishes, delete the file
        echo Deleting set_key.bat... >> "%logFile%"
        del "%getSetKeyPath%"
        if errorlevel 1 (
            echo Unable to delete set_key.bat. >> "%logFile%"
        ) else (
            echo set_key.bat has been deleted. >> "%logFile%"
        )
    )
    goto menu
) else if "%choice%"=="4" (
    echo Downloading google_dns.bat... >> "%logFile%"
    
    :: Download google_dns.bat
    curl -L -o "%googleDnsPath%" "%googleDnsUrl%"
    
    :: Check if the file was downloaded successfully
    if errorlevel 1 (
        echo Unable to download google_dns.bat. >> "%logFile%"
    ) else (
        echo google_dns.bat downloaded successfully: %googleDnsPath% >> "%logFile%"
        echo. >> "%logFile%"
        
        :: Run google_dns.bat in a new window and wait for it to close
        echo Running google_dns.bat in a new window... >> "%logFile%"
        start "" /wait cmd /c "%googleDnsPath%"
        
        :: After the script finishes, delete the file
        echo Deleting google_dns.bat... >> "%logFile%"
        del "%googleDnsPath%"
        if errorlevel 1 (
            echo Unable to delete google_dns.bat. >> "%logFile%"
        ) else (
            echo google_dns.bat has been deleted. >> "%logFile%"
        )
    )
    goto menu
) else if "%choice%"=="5" (
    echo Downloading cloudflare_dns.bat... >> "%logFile%"
    
    :: Download cloudflare_dns.bat
    curl -L -o "%cloudflareDnsPath%" "%cloudflareDnsUrl%"
    
    :: Check if the file was downloaded successfully
    if errorlevel 1 (
        echo Unable to download cloudflare_dns.bat. >> "%logFile%"
    ) else (
        echo cloudflare_dns.bat downloaded successfully: %cloudflareDnsPath% >> "%logFile%"
        echo. >> "%logFile%"
        
        :: Run cloudflare_dns.bat in a new window and wait for it to close
        echo Running cloudflare_dns.bat in a new window... >> "%logFile%"
        start "" /wait cmd /c "%cloudflareDnsPath%"
        
        :: After the script finishes, delete the file
        echo Deleting cloudflare_dns.bat... >> "%logFile%"
        del "%cloudflareDnsPath%"
        if errorlevel 1 (
            echo Unable to delete cloudflare_dns.bat. >> "%logFile%"
        ) else (
            echo cloudflare_dns.bat has been deleted. >> "%logFile%"
        )
    )
    goto menu
) else if "%choice%"=="6" (
    echo Downloading open_dns.bat... >> "%logFile%"
    
    :: Download open_dns.bat
    curl -L -o "%openDnsPath%" "%openDnsUrl%"
    
    :: Check if the file was downloaded successfully
    if errorlevel 1 (
        echo Unable to download open_dns.bat. >> "%logFile%"
    ) else (
        echo open_dns.bat downloaded successfully: %openDnsPath% >> "%logFile%"
        echo. >> "%logFile%"
        
        :: Run open_dns.bat in a new window and wait for it to close
        echo Running open_dns.bat in a new window... >> "%logFile%"
        start "" /wait cmd /c "%openDnsPath%"
        
        :: After the script finishes, delete the file
        echo Deleting open_dns.bat... >> "%logFile%"
        del "%openDnsPath%"
        if errorlevel 1 (
            echo Unable to delete open_dns.bat. >> "%logFile%"
        ) else (
            echo open_dns.bat has been deleted. >> "%logFile%"
        )
    )
    goto menu
) else if "%choice%"=="7" (
    echo Exiting the script. >> "%logFile%"
    exit /b
) else (
    echo Invalid choice. Please choose a valid option. >> "%logFile%"
    goto menu
)
