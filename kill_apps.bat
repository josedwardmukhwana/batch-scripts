@echo off
title Resource Heavy Process Killer
setlocal enabledelayedexpansion

:: --- SET YOUR THRESHOLDS HERE ---
set MAX_RAM_MB=500
set MAX_CPU_PERCENT=20
:: -------------------------------

echo ========================================================
echo   SCANNING FOR RESOURCE-HEAVY PROCESSES...
echo   Thresholds: RAM > %MAX_RAM_MB%MB  ^|  CPU > %MAX_CPU_PERCENT%%%
echo ========================================================
echo.

:: Use PowerShell to find the IDs of heavy processes, excluding system vitals
powershell -Command ^
    "$ErrorActionPreference = 'SilentlyContinue';" ^
    "$WhiteList = @('explorer', 'dwm', 'taskmgr', 'powershell', 'cmd', 'system', 'idle', 'svchost', 'wininit', 'lsass');" ^
    "$Processes = Get-Process | Where-Object { $_.Id -gt 0 -and $WhiteList -notcontains $_.ProcessName };" ^
    "foreach ($p in $Processes) {" ^
    "    $memMB = [math]::Round($p.WorkingSet64 / 1MB, 2);" ^
    "    $cpu = [math]::Round((Get-Counter '\Process($($p.ProcessName))\%% Processor Time').CounterSamples.CookedValue / $env:NUMBER_OF_PROCESSORS, 2);" ^
    "    if ($memMB -gt %MAX_RAM_MB% -or $cpu -gt %MAX_CPU_PERCENT%) {" ^
    "        Write-Host '[KILLING] ' $p.ProcessName ' (RAM: ' $memMB 'MB, CPU: ' $cpu '%%)' -ForegroundColor Red;" ^
    "        Stop-Process -Id $p.Id -Force;" ^
    "    }" ^
    "}"

echo.
echo ========================================================
echo   Resource Cleanup Complete!
echo ========================================================
pause