# ChessMaster Server Teardown (PowerShell)
param (
    [int]$Port = 8080
)

Write-Host "Stopping any running dev servers on port $Port..." -ForegroundColor Yellow
$connections = Get-NetTCPConnection -LocalPort $Port -ErrorAction SilentlyContinue
if ($connections) {
    foreach ($conn in $connections) {
        $proc = Get-Process -Id $conn.OwningProcess -ErrorAction SilentlyContinue
        if ($proc) {
            Write-Host "Terminating process $($proc.ProcessName) (PID: $($proc.Id))" -ForegroundColor Cyan
            Stop-Process -Id $proc.Id -Force
        }
    }
}
Write-Host "Dev server stopped." -ForegroundColor Green
