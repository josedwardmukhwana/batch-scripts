# This script forces WSA to refresh its app registration with Windows
# Run this if icons are missing or "phantom" apps won't disappear

Write-Host "Closing active WSA processes to prevent 'Resources in Use' error..." -ForegroundColor Yellow
wsaclient.exe /shutdown

Write-Host "Refreshing Android App Registration..." -ForegroundColor Cyan
Get-AppxPackage -allusers *SubsystemForAndroid* | Foreach {Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml"}

Write-Host "Done! You can close this window." -ForegroundColor Green
Pause