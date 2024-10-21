@echo off
setlocal enabledelayedexpansion

:: Define log file path
set "logFile=C:\Users\%USERNAME%\Desktop\anime\killmumu.log"
:: Clear previous log file
> "%logFile%" echo Script log for %DATE% %TIME%:

:: Define anime directory
set "animeDir=C:\Users\%USERNAME%\Desktop\anime"

:: Call delay and run routine
call :delayAndRun
exit /b

:delayAndRun
echo Waiting for 10 seconds before running autoRelaunch_mumu.bat... >> "%logFile%"
for /L %%i in (10,-1,1) do (
    echo Starting in %%i seconds...
    timeout /t 1 >nul
)

cd "%animeDir%" || exit /b 1
if not exist "autoRelaunch_mumu.bat" (
    echo File autoRelaunch_mumu.bat does not exist. >> "%logFile%"
    exit /b 1
)

echo Running autoRelaunch_mumu.bat... >> "%logFile%"
call autoRelaunch_mumu.bat || exit /b 1
echo All operations completed successfully! >> "%logFile%"
exit /b
