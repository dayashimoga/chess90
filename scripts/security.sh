#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if ! command -v dart &> /dev/null; then
    echo "Local Dart SDK missing. Running security via container..."
    bash "$ROOT_DIR/scripts/run_container.sh" security
    exit 0
fi

cd "$ROOT_DIR/tool"
dart pub get
dart run security_runner.dart
