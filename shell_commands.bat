@echo off
SETLOCAL EnableDelayedExpansion

:: --- AUTO-ELEVATION BLOCK ---
:: Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

:: If error flag set, we do not have admin.
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
echo ========================================
echo   Dynamic Context Menu Manager (ADMIN)
echo ========================================
echo 1. Add a new command
echo 2. Remove a command
echo 3. Exit
echo ========================================
set /p choice="Select an option (1-3): "

if "%choice%"=="1" goto ADD
if "%choice%"=="2" goto REMOVE
if "%choice%"=="3" exit
goto MENU

:ADD
echo.
set /p "MenuName=Enter the Title (Text shown in menu): "
set /p "CommandToRun=Enter the Command (Full path or shell command): "

set "RegKey=%MenuName: =%"

echo.
echo Adding "%MenuName%"...
reg add "HKEY_CLASSES_ROOT\Directory\Background\shell\%RegKey%" /ve /t REG_SZ /d "%MenuName%" /f >nul
reg add "HKEY_CLASSES_ROOT\Directory\Background\shell\%RegKey%\command" /ve /t REG_SZ /d "%CommandToRun%" /f >nul

if %errorlevel% equ 0 (
    echo Successfully added!
) else (
    echo Error: Registry modification failed.
)
pause
goto MENU

:REMOVE
echo.
echo Note: This must match the Title you entered when adding.
set /p "MenuName=Enter the Title to remove: "
set "RegKey=%MenuName: =%"

echo.
echo Removing "%MenuName%"...
reg delete "HKEY_CLASSES_ROOT\Directory\Background\shell\%RegKey%" /f >nul

if %errorlevel% equ 0 (
    echo Successfully removed!
) else (
    echo Error: Could not find a menu item with that title.
)
pause
goto MENU