@echo off
echo ================================
echo   RESETTING PRINTER SERVICES
echo ================================
echo.

echo Stopping Print Spooler service...
net stop spooler
echo.

echo Clearing print queue files...
del /Q /F "%systemroot%\System32\spool\PRINTERS\*.*"
echo.

echo Starting Print Spooler service...
net start spooler
echo.

echo Print spooler has been reset successfully!
pause
