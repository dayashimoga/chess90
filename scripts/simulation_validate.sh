#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if ! command -v dart &> /dev/null; then
    echo "Local Dart SDK missing. Proceeding with containerized 90-day simulation..."
    bash "$ROOT_DIR/scripts/run_container.sh" simulation-validate
    exit 0
fi

cd "$ROOT_DIR/tool"
dart pub get
dart run simulation_runner.dart
