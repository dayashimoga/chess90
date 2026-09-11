#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "======================================================"
echo "   CHESSMASTER FULL PRODUCTION CERTIFICATION PASS     "
echo "======================================================"

if ! command -v dart &> /dev/null; then
    echo "Local Dart SDK missing. Proceeding with containerized certification..."
    bash "$ROOT_DIR/scripts/run_container.sh" certify
    exit 0
fi

echo -e "\n[1/6] Running Monorepo Tests..."
bash "$ROOT_DIR/scripts/test.sh"

echo -e "\n[2/6] Running 90-Day Content Validator..."
bash "$ROOT_DIR/scripts/content_validate.sh"

echo -e "\n[3/6] Running 90-Day Simulation Engine..."
bash "$ROOT_DIR/scripts/simulation_validate.sh"

echo -e "\n[4/6] Collecting Coverage & Enforcing Gates..."
cd "$ROOT_DIR/tool"
dart pub get
dart run coverage_runner.dart

echo -e "\n[5/6] Running Performance Truth Benchmarks..."
dart run performance_runner.dart

echo -e "\n[6/6] Running Security & Secret Audits..."
dart run security_runner.dart

echo -e "\n======================================================"
echo "   ALL PRODUCTION CERTIFICATION GATES SATISFIED       "
echo "======================================================"
