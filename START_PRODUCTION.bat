@echo off
title FoodBridge Production Platform
color 0B

echo ================================================================
echo        FOODBRIDGE - Fast Production Server
echo ================================================================
echo.
echo [1/3] Setting up environment...
set "PATH=C:\Users\Abhishek Sharma\.local\bin;%PATH%"
cd /d "%~dp0"

echo [2/3] Checking port 3000...
for /f "tokens=5" %%a in ('netstat -aon ^| findstr :3000') do (
    taskkill /f /pid %%a >nul 2>&1
)

echo [3/3] Launching FoodBridge server...
echo       Waiting for server to become ready before launching Chrome...
echo.

:: Background watcher: Polls port 3000 until server is listening, then launches Chrome immediately
start "" powershell -NoProfile -Command ^
  "$ready = $false; ^
   for ($i=0; $i -lt 40; $i++) { ^
     try { ^
       $client = New-Object System.Net.Sockets.TcpClient; ^
       $asyncResult = $client.BeginConnect('127.0.0.1', 3000, $null, $null); ^
       $success = $asyncResult.AsyncWaitHandle.WaitOne(1000); ^
       if ($success -and $client.Connected) { ^
         $client.EndConnect($asyncResult); ^
         $client.Close(); ^
         $ready = $true; ^
         break; ^
       } ^
       $client.Close(); ^
     } catch {} ^
     Start-Sleep -Milliseconds 500; ^
   }; ^
   if (Test-Path 'C:\Program Files\Google\Chrome\Application\chrome.exe') { ^
     Start-Process 'C:\Program Files\Google\Chrome\Application\chrome.exe' 'http://localhost:3000'; ^
   } elseif (Test-Path 'C:\Program Files (x86)\Google\Chrome\Application\chrome.exe') { ^
     Start-Process 'C:\Program Files (x86)\Google\Chrome\Application\chrome.exe' 'http://localhost:3000'; ^
   } else { ^
     Start-Process 'http://localhost:3000'; ^
   }"

call npm run start

pause
