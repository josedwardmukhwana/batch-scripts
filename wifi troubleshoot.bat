@echo off
:: Check for Admin Rights
net session >nul 2>&1
if %errorLevel% == 0 (
    echo [OK] Running with Administrator privileges.
) else (
    echo [ERROR] Please right-click and "Run as Administrator."
    pause
    exit /b
)

echo ======================================
echo      ENHANCED NETWORK RECOVERY
echo ======================================

echo [1/6] Flushing DNS and Clearing ARP...
ipconfig /flushdns
arp -d *
echo.

echo [2/6] Releasing IP Address...
ipconfig /release
echo.

echo [3/6] Resetting Winsock and IP Stack...
netsh winsock reset >nul
netsh int ip reset >nul
echo.

echo [4/6] Restarting WLAN Service...
net stop wlansvc
timeout /t 2 >nul
net start wlansvc
echo.

echo [5/6] Renewing IP Address...
ipconfig /renew
echo.

echo [6/6] Clearing Network State...
netsh interface set interface "Wi-Fi" admin=disable
timeout /t 2 >nul
netsh interface set interface "Wi-Fi" admin=enable

echo ======================================
echo Done! Speed should be restored.
echo ======================================
pause