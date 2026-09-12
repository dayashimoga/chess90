# ChessMaster Podman / OCI Container Automation Script
[CmdletBinding()]
param (
    [ValidateSet("build", "test", "coverage", "performance", "security", "acceptance", "content-validate", "simulation-validate", "certify", "shell", "serve")]
    [string]$Action = "test",
    [string]$Port = "8080"
)

$ErrorActionPreference = "Stop"
$rootDir = (Get-Item $PSScriptRoot).Parent.FullName

# 1. Detect Container Engine (Prefer Podman)
$containerEngine = $null
if (Get-Command "podman" -ErrorAction SilentlyContinue) {
    $containerEngine = "podman"
} elseif (Get-Command "docker" -ErrorAction SilentlyContinue) {
    $containerEngine = "docker"
} else {
    Write-Error "Neither podman nor docker CLI found in PATH. Please install Podman to run containerized verification."
    exit 1
}

Write-Host "======================================================" -ForegroundColor Cyan
Write-Host "       CHESSMASTER PODMAN CONTAINER RUNNER            " -ForegroundColor Cyan
Write-Host "======================================================" -ForegroundColor Cyan
Write-Host "Container Engine : $containerEngine" -ForegroundColor Green
Write-Host "Target Action    : $Action" -ForegroundColor Yellow
Write-Host "Workspace Root   : $rootDir" -ForegroundColor Gray
Write-Host "------------------------------------------------------" -ForegroundColor Gray

$imageTag = "chessmaster:latest"

# 2. Check if image exists before running actions
if ($Action -ne "build") {
    $imageExists = & $containerEngine images -q $imageTag
    if (-not $imageExists) {
        Write-Host "[Container] Image '$imageTag' not found locally. Auto-building image first..." -ForegroundColor Yellow
        & $containerEngine build -t $imageTag -f (Join-Path $rootDir "infra/Containerfile") $rootDir
        if ($LASTEXITCODE -ne 0) {
            Write-Error "Failed to build container image $imageTag."
            exit 1
        }
    }
}

switch ($Action) {
    "build" {
        Write-Host "[Container] Building image $imageTag via $containerEngine..." -ForegroundColor Cyan
        & $containerEngine build -t $imageTag -f (Join-Path $rootDir "infra/Containerfile") $rootDir
    }

    "test" {
        Write-Host "[Container] Running monorepo tests in isolated container..." -ForegroundColor Cyan
        & $containerEngine run --rm -v chess_pub_cache:/root/.pub-cache -v "${rootDir}:/workspace:z" -w /workspace $imageTag bash scripts/test.sh
    }

    "coverage" {
        Write-Host "[Container] Running coverage collection & gates in container..." -ForegroundColor Cyan
        & $containerEngine run --rm -v chess_pub_cache:/root/.pub-cache -v "${rootDir}:/workspace:z" -w /workspace $imageTag bash -c "cd tool && dart pub get && dart run coverage_runner.dart"
    }

    "performance" {
        Write-Host "[Container] Running performance benchmarks in container..." -ForegroundColor Cyan
        & $containerEngine run --rm -v chess_pub_cache:/root/.pub-cache -v "${rootDir}:/workspace:z" -w /workspace $imageTag bash -c "cd tool && dart pub get && dart run performance_runner.dart"
    }

    "security" {
        Write-Host "[Container] Running security audit in container..." -ForegroundColor Cyan
        & $containerEngine run --rm -v chess_pub_cache:/root/.pub-cache -v "${rootDir}:/workspace:z" -w /workspace $imageTag bash -c "cd tool && dart pub get && dart run security_runner.dart"
    }

    "acceptance" {
        Write-Host "[Container] Running full acceptance certification in container..." -ForegroundColor Cyan
        & $containerEngine run --rm -v chess_pub_cache:/root/.pub-cache -v "${rootDir}:/workspace:z" -w /workspace $imageTag bash scripts/acceptance.sh --full
    }

    "content-validate" {
        Write-Host "[Container] Running 90-day content depth & legal move validator in container..." -ForegroundColor Cyan
        & $containerEngine run --rm -v chess_pub_cache:/root/.pub-cache -v "${rootDir}:/workspace:z" -w /workspace $imageTag bash -c "cd tool && dart pub get && dart run content_validator.dart"
    }

    "pedagogy-validate" {
        Write-Host "[Container] Running 90-day pedagogical quality auditor in container..." -ForegroundColor Cyan
        & $containerEngine run --rm -v chess_pub_cache:/root/.pub-cache -v "${rootDir}:/workspace:z" -w /workspace $imageTag bash -c "cd tool && dart pub get && dart run pedagogy_auditor.dart"
    }

    "simulation-validate" {
        Write-Host "[Container] Running 90-day deterministic simulation runner in container..." -ForegroundColor Cyan
        & $containerEngine run --rm -v chess_pub_cache:/root/.pub-cache -v "${rootDir}:/workspace:z" -w /workspace $imageTag bash -c "cd tool && dart pub get && dart run simulation_runner.dart"
    }

    "release-manifest" {
        Write-Host "[Container] Generating multi-platform release manifest in container..." -ForegroundColor Cyan
        & $containerEngine run --rm -v chess_pub_cache:/root/.pub-cache -v "${rootDir}:/workspace:z" -w /workspace $imageTag bash -c "cd tool && dart pub get && dart run release_manifest_generator.dart"
    }

    "certify" {
        Write-Host "[Container] Running end-to-end certification gate in container..." -ForegroundColor Cyan
        & $containerEngine run --rm -v chess_pub_cache:/root/.pub-cache -v "${rootDir}:/workspace:z" -w /workspace $imageTag bash -c "bash scripts/test.sh && cd tool && dart pub get && dart run content_validator.dart && dart run pedagogy_auditor.dart && dart run simulation_runner.dart && dart run coverage_runner.dart && dart run performance_runner.dart && dart run security_runner.dart && dart run release_manifest_generator.dart"
    }

    "shell" {
        Write-Host "[Container] Launching interactive shell..." -ForegroundColor Cyan
        & $containerEngine run -it --rm -v "${rootDir}:/workspace:z" -w /workspace $imageTag bash
    }

    "serve" {
        Write-Host "[Container] Serving ChessMaster Web on http://localhost:${Port}..." -ForegroundColor Green
        & $containerEngine run --rm -p "${Port}:8080" -v "${rootDir}:/workspace:z" -w /workspace $imageTag bash scripts/up.sh 8080
    }
}

Write-Host "`nContainer operation '$Action' completed." -ForegroundColor Cyan
