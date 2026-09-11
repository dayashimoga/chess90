#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "=========================================="
echo "       RUNNING ALL CHESSMASTER TESTS      "
echo "=========================================="

PACKAGES=(
    "packages/chess_core"
    "packages/chess_engine"
    "packages/chess_learning"
    "packages/chess_curriculum"
    "packages/chess_labs"
    "packages/chess_content"
    "packages/chess_video"
    "packages/chess_storage"
)

for pkg in "${PACKAGES[@]}"; do
    echo -e "\nTesting $pkg..."
    cd "$ROOT_DIR/$pkg"
    dart pub get
    dart test
    echo "PASSED: $pkg"
done

echo -e "\nTesting apps/chess_app..."
cd "$ROOT_DIR/apps/chess_app"
flutter pub get
flutter test
echo "PASSED: apps/chess_app"

echo -e "\n=========================================="
echo " ALL TEST SUITES PASSED CLEANLY (100%)    "
echo "=========================================="
