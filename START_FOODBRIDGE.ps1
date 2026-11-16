# FoodBridge Launcher - PowerShell Script
$host.UI.RawUI.WindowTitle = "FoodBridge Server"

Write-Host ""
Write-Host "============================================" -ForegroundColor Green
Write-Host "  FOODBRIDGE - AI Food Rescue Platform" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Green
Write-Host ""

# Set paths
$nodePath = "C:\Users\Abhishek Sharma\.local\bin"
$projectPath = "C:\Users\Abhishek Sharma\OneDrive\Desktop\FoodBridge"
$env:PATH = "$nodePath;" + $env:PATH

# Kill anything on port 3000
Write-Host "[1/3] Clearing port 3000..." -ForegroundColor Yellow
$pids = (Get-NetTCPConnection -LocalPort 3000 -ErrorAction SilentlyContinue).OwningProcess
foreach ($pid in $pids) {
    Stop-Process -Id $pid -Force -ErrorAction SilentlyContinue
    Write-Host "      Stopped process $pid" -ForegroundColor Gray
}
Start-Sleep -Seconds 2

# Start server in background
Write-Host "[2/3] Starting FoodBridge server..." -ForegroundColor Yellow
Write-Host "      (First run takes 30-60 seconds)" -ForegroundColor Gray
Write-Host ""

$serverJob = Start-Job -ScriptBlock {
    param($proj, $node)
    $env:PATH = "$node;" + $env:PATH
    Set-Location $proj
    & node "node_modules\next\dist\bin\next" dev -H 127.0.0.1 -p 3000 2>&1
} -ArgumentList $projectPath, $nodePath

# Poll for server readiness
Write-Host "[3/3] Waiting for server to be ready..." -ForegroundColor Yellow
$ready = $false
for ($i = 1; $i -le 60; $i++) {
    try {
        $tcp = New-Object System.Net.Sockets.TcpClient
        $tcp.Connect("127.0.0.1", 3000)
        $tcp.Close()
        $ready = $true
        break
    } catch {
        # Still starting
    }
    Write-Host "      Attempt $i/60 - server starting..." -ForegroundColor Gray
    Start-Sleep -Seconds 2
}

if ($ready) {
    Write-Host ""
    Write-Host "============================================" -ForegroundColor Green
    Write-Host "  SERVER READY! Opening Chrome..." -ForegroundColor Green
    Write-Host "  URL: http://127.0.0.1:3000" -ForegroundColor Cyan
    Write-Host "============================================" -ForegroundColor Green
    Write-Host ""
    
    # Open Chrome
    $chromePaths = @(
        "C:\Program Files\Google\Chrome\Application\chrome.exe",
        "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"
    )
    $chromeLaunched = $false
    foreach ($chrome in $chromePaths) {
        if (Test-Path $chrome) {
            Start-Process $chrome "http://127.0.0.1:3000"
            $chromeLaunched = $true
            break
        }
    }
    if (-not $chromeLaunched) {
        Start-Process "http://127.0.0.1:3000"
    }
    
    Write-Host "FoodBridge is running! Keep this window open." -ForegroundColor Green
    Write-Host "Press Ctrl+C to stop the server." -ForegroundColor Yellow
    Write-Host ""
    
    # Stream server logs
    while ($true) {
        $output = Receive-Job -Job $serverJob
        if ($output) { Write-Host $output }
        if ($serverJob.State -eq 'Completed' -or $serverJob.State -eq 'Failed') {
            Write-Host "Server stopped unexpectedly!" -ForegroundColor Red
            Receive-Job -Job $serverJob | Write-Host
            break
        }
        Start-Sleep -Seconds 1
    }
} else {
    Write-Host ""
    Write-Host "ERROR: Server failed to start after 2 minutes!" -ForegroundColor Red
    Write-Host "Server log output:" -ForegroundColor Yellow
    Receive-Job -Job $serverJob | Write-Host
}

Read-Host "Press Enter to exit"
