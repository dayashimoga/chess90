#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "Cleaning monorepo build artifacts..."
rm -rf "$ROOT_DIR/apps/chess_app/build"
rm -rf "$ROOT_DIR/dist"
rm -rf "$ROOT_DIR/acceptance_tmp"
echo "Clean complete."
