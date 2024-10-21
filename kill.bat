@echo off
setlocal enabledelayedexpansion

:: Define log file path
set "logFile=C:\Users\%USERNAME%\Desktop\anime\killmumu.log"
:: Clear previous log file
> "%logFile%" echo Script log for %DATE% %TIME%:

:: Define paths and URLs
set "animeDir=C:\Users\%USERNAME%\Desktop\anime"
set "jsonSource=https://raw.githubusercontent.com/quannqttg/emulators/main/emulators.json"
set "jsonDest=%animeDir%\data\emulators.json"
set "targetDir=C:\Program Files\Netease\MuMuPlayerGlobal-12.0\vms"

:: Check for anime directory
if not exist "%animeDir%" (
    echo Anime directory not found, creating directory... >> "%logFile%"
    mkdir "%animeDir%"
) else (
    echo Anime directory exists. >> "%logFile%"
)

:: Call delete and download routine
call :deleteAndDownload

:: Call temp folder cleanup
call :cleanupTemp

:: Call specific file and folder deletion routine
call :deleteMuMuFiles

exit /b


:deleteAndDownload
echo [DEBUG] Starting download and deletion routine... >> "%logFile%"

:: Download emulators.json file from GitHub
if not exist "%animeDir%\data" (
    mkdir "%animeDir%\data" >> "%logFile%"
    echo Created data directory. >> "%logFile%"
)

echo Downloading emulators.json from GitHub... >> "%logFile%"
curl -L -o "!jsonDest!" "!jsonSource!"
if errorlevel 1 (
    echo Failed to download emulators.json. >> "%logFile%"
    exit /b 1
) else (
    echo Download completed successfully! >> "%logFile%"
)
exit /b


:cleanupTemp
echo [DEBUG] Cleaning up temporary files... >> "%logFile%"
:: Delete temporary files
set "tempFolder=%temp%"
echo Deleting all files in Temp folder... >> "%logFile%"
cd /d "%temp%" || exit /b 1
del /f /s /q *.* >nul 2>&1
for /d %%i in (*) do rmdir /s /q "%%i" >> "%logFile%" 2>&1
echo Temp folder cleaned. >> "%logFile%"
exit /b


:deleteMuMuFiles
echo [DEBUG] Deleting specific files and folders in MuMu directory... >> "%logFile%"
:: Perform deletion of specific folders and files
if exist "!targetDir!" (
    echo Deleting contents in "!targetDir!"... >> "%logFile%"
    
    :: Loop through directories in the target directory
    set "folderDeleted=0"
    for /d %%i in ("!targetDir!\*") do (
        if /i not "%%~nxi"=="MuMuPlayerGlobal-12.0-base" if /i not "%%~nxi"=="MuMuPlayerGlobal-12.0-0" (
            echo Deleting folder %%i... >> "%logFile%"
            rmdir /s /q "%%i"
            echo Deleted folder %%i >> "%logFile%"
            set "folderDeleted=1"
        ) else (
            echo Folder %%i is protected and will not be deleted. >> "%logFile%"
        )
    )
    
    :: Loop through files in the target directory
    set "fileDeleted=0"
    for %%i in ("!targetDir!\*") do (
        echo Deleting file %%i... >> "%logFile%"
        del /q "%%i"
        if errorlevel 1 (
            echo Failed to delete file %%i. >> "%logFile%"
        ) else (
            echo Deleted file %%i >> "%logFile%"
            set "fileDeleted=1"
        )
    )

    if !folderDeleted! equ 0 (
        echo No folders were deleted in "!targetDir!". >> "%logFile%"
    )

    if !fileDeleted! equ 0 (
        echo No files were deleted in "!targetDir!". >> "%logFile%"
    )
) else (
    echo Target directory does not exist. Continuing without deletion... >> "%logFile%"
)
exit /b
