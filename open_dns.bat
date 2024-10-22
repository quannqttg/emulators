@echo off
:: Batch file to set OpenDNS

echo Setting OpenDNS for adapter "Ethernet"...

:: Use PowerShell to set DNS
powershell -Command "$adapterName = 'Ethernet'; Set-DnsClientServerAddress -InterfaceAlias $adapterName -ServerAddresses 208.67.222.222, 208.67.220.220"

:: Check if DNS has been set correctly
echo Checking DNS settings...
powershell -Command "Get-DnsClientServerAddress -InterfaceAlias 'Ethernet'"

echo OpenDNS has been set for adapter: "Ethernet".
pause
exit
