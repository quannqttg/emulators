@echo off
:: Batch file to set Cloudflare DNS

echo Setting Cloudflare DNS for adapter "Ethernet"...

:: Use PowerShell to set DNS
powershell -Command "$adapterName = 'Ethernet'; Set-DnsClientServerAddress -InterfaceAlias $adapterName -ServerAddresses 1.1.1.1, 1.0.0.1"

:: Check if DNS has been set correctly
echo Checking DNS settings...
powershell -Command "Get-DnsClientServerAddress -InterfaceAlias 'Ethernet'"

echo Cloudflare DNS has been set for adapter: "Ethernet".
pause
exit
