@echo off
:: === Force run as admin ===
net session >nul 2>&1
if %errorlevel% neq 0 (
    powershell -Command "Start-Process '%~f0' -Verb runAs"
    exit /b
)

title Custom Command Prompt
set "customName=user"

echo Microsoft Windows [Version 10.0.26100.3775]
echo (c) Microsoft Corporation.
echo.

:main
set /p cmd="C:\Users\%USERNAME%>"

:: Convert input to lowercase for easier matching
set "input=%cmd%"
if /i "%input%"=="help" goto :help
if /i "%input%"=="disabletaskmgr" goto :disabletaskmgr
if /i "%input%"=="disableUAC" goto :disableUAC
if /i "%input%"=="enableUAC" goto :enableUAC
if /i "%input%"=="enabletaskmgr" goto :enabletaskmgr
if /i "%input%"=="rst" goto :restart
:: If unknown command
echo '%cmd%' is not recognized as an internal or external command.
goto :main

:help
echo disabletaskmgr
echo disableUAC
echo enableUAC
echo enabletaskmgr
echo rst
goto :main

:disabletaskmgr
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v DisableTaskMgr /t REG_DWORD /d 1 /f
goto :main

:disableUAC
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableLUA /t REG_DWORD /d 0 /f
goto :main

:enableUAC
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableLUA /t REG_DWORD /d 1 /f
goto :main


:enabletaskmgr
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v DisableTaskMgr /t REG_DWORD /d 0 /f
goto :main

:restart
shutdown -r -t 9 -c "close all running apps!"
pause
