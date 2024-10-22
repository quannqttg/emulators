@echo off
:: Batch file to set Google DNS

echo Setting Google DNS for adapter "Ethernet"...

:: Use PowerShell to set DNS
powershell -Command "$adapterName = 'Ethernet'; Set-DnsClientServerAddress -InterfaceAlias $adapterName -ServerAddresses 8.8.8.8, 8.8.4.4"

:: Check if DNS has been set correctly
echo Checking DNS settings...
powershell -Command "Get-DnsClientServerAddress -InterfaceAlias 'Ethernet'"

echo Google DNS has been set for adapter: "Ethernet".
pause
exit
