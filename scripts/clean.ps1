# Clean monorepo build artifacts and caches (PowerShell)
$rootDir = (Get-Item $PSScriptRoot).Parent.FullName

Write-Host "Cleaning monorepo build artifacts..." -ForegroundColor Yellow

$dirsToClean = @(
    "apps\chess_app\build",
    "apps\chess_app\.dart_tool",
    "dist",
    "acceptance_tmp"
)

foreach ($d in $dirsToClean) {
    $fullPath = Join-Path $rootDir $d
    if (Test-Path $fullPath) {
        Write-Host "Removing $d..." -ForegroundColor Cyan
        Remove-Item -Recurse -Force $fullPath -ErrorAction SilentlyContinue
    }
}

Write-Host "Clean complete." -ForegroundColor Green
