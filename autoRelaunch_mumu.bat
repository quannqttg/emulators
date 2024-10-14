@echo off
:Start
installer_mumu.exe
client_mumu.exe
TIMEOUT /T 5
GOTO:Start