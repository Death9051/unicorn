@echo off
rem Starts PhotoCraft with the control server for the "photocraft-ui" MCP.
rem Close any running PhotoCraft first, otherwise the control flags are ignored.
setlocal
set "PC="
for /d %%D in ("D:\New Folder\*") do if exist "%%D\PhotoCraft\photocraft.exe" set "PC=%%D\PhotoCraft\photocraft.exe"
if not defined PC (echo photocraft.exe not found & pause & exit /b 1)
for %%R in ("%~dp0..") do set "ROOT=%%~fR"
if not exist "%USERPROFILE%\.photocraft" mkdir "%USERPROFILE%\.photocraft"
start "" "%PC%" --control 47821 --control-token-file "%USERPROFILE%\.photocraft\control.token" --automation-read-root "%ROOT%" --automation-write-root "%ROOT%"
