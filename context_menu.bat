@echo off
SETLOCAL EnableDelayedExpansion

:: --- AUTO-ELEVATION BLOCK ---
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
    pushd "%CD%"
    CD /D "%~dp0"
:: ----------------------------

:MENU
cls
echo ==================================================
echo   Mina Menu Installer
echo ==================================================
echo 1. Install "Mina" Menu
echo 2. Remove "Mina" Menu
echo 3. Exit
echo ==================================================
set /p choice="Select an option (1-3): "

if "%choice%"=="1" goto INSTALL
if "%choice%"=="2" goto REMOVE
if "%choice%"=="3" exit
goto MENU

:INSTALL
echo Installing Submenu...

:: 1. Define the Subcommands (The "Extended" list)
reg add "HKLM\SOFTWARE\Classes\Directory\ContextMenus\Mina\shell\run mina" /ve /d "Run Mina" /f >nul
reg add "HKLM\SOFTWARE\Classes\Directory\ContextMenus\Mina\shell\run mina\command" /ve /d "python C:\Projects\Python\Scripts\erp.py \"%%V\"" /f >nul

reg add "HKLM\SOFTWARE\Classes\Directory\ContextMenus\Mina\shell\stop mina" /ve /d "Stop Mina" /f >nul
reg add "HKLM\SOFTWARE\Classes\Directory\ContextMenus\Mina\shell\stop mina\command" /ve /d "python C:\Projects\Python\Scripts\stop_erp.py" /f >nul

:: 2. Link the Backgrounds to the ContextMenu
for %%k in (Directory\Background DesktopBackground) do (
    reg add "HKLM\SOFTWARE\Classes\%%k\shell\Mina" /v "MUIVerb" /d "Mina" /f >nul
    reg add "HKLM\SOFTWARE\Classes\%%k\shell\Mina" /v "Icon" /d "shell32.dll,72" /f >nul
    reg add "HKLM\SOFTWARE\Classes\%%k\shell\Mina" /v "ExtendedSubCommandsKey" /d "Directory\ContextMenus\Mina" /f >nul
)

echo Successfully installed!
pause
goto MENU

:REMOVE
reg delete "HKLM\SOFTWARE\Classes\Directory\Background\shell\Mina" /f >nul
reg delete "HKLM\SOFTWARE\Classes\Directory\Background\shell\MinaRun" /f >nul
reg delete "HKLM\SOFTWARE\Classes\Directory\Background\shell\MinaStop" /f >nul
echo Removed.
pause
goto MENU