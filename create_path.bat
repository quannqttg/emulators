@echo off
setlocal

:: Define paths for files
set "userDir=%USERNAME%"
set "animeDir=C:\Users\%userDir%\Desktop\anime"
set "logFile=%animeDir%\create_path.log"
set "shared_folder_file=%animeDir%\shared_folder.json"

:: Define the path you want to check
set "pathToCheck=C:\Users\%userDir%\Documents\MuMuSharedFolder"

:: Check if the shared_folder.json file exists and delete it if it does
if exist "%shared_folder_file%" (
    del "%shared_folder_file%"
    echo Deleted existing JSON file: %shared_folder_file%
    
    :: Log the deletion message
    echo [%date% %time%] Deleted existing JSON file: %shared_folder_file% >> "%logFile%"
)

:: Check if the directory exists
if exist "%pathToCheck%" (
    echo Directory exists: %pathToCheck%
    
    :: Create a JSON file with the path in the specified directory
    echo { > "%shared_folder_file%"
    echo     "shared_folder": "C:\\Users\\%userDir%\\Documents\\MuMuSharedFolder" >> "%shared_folder_file%"
    echo } >> "%shared_folder_file%"
    
    echo JSON file created: %shared_folder_file%

    :: Log the success message
    echo [%date% %time%] JSON file created: C:\\Users\\%userDir%\\Desktop\\anime\\shared_folder.json >> "%logFile%"
) else (
    echo Directory does not exist: %pathToCheck%

    :: Log the error message
    echo [%date% %time%] Directory does not exist: %pathToCheck% >> "%logFile%"
)

endlocal
exit /b
