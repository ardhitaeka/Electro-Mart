@echo off
rem Jalankan autosync.ps1 tanpa mengubah Execution Policy global.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0autosync.ps1" %*
pause
