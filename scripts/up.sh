#!/usr/bin/env bash
set -euo pipefail

PORT="${1:-8080}"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
APP_DIR="$ROOT_DIR/apps/chess_app"
WEB_DIST="$APP_DIR/build/web"

echo "=========================================="
echo "       CHESSMASTER PLATFORM LAUNCHER      "
echo "=========================================="

if [ ! -d "$WEB_DIST" ]; then
    echo "Building Web bundle..."
    cd "$APP_DIR"
    flutter build web --release
fi

echo "Serving ChessMaster Web on http://localhost:$PORT..."
cd "$WEB_DIST"
python3 -m http.server "$PORT" || python -m http.server "$PORT"
