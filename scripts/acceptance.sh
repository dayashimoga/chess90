#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "Running ChessMaster Acceptance Suite..."
cd "$ROOT_DIR/tests"
dart pub get
dart run acceptance_runner.dart "$@"
