#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET="${1:-all}"

echo "Building ChessMaster target: $TARGET"
cd "$ROOT_DIR/apps/chess_app"

if [ "$TARGET" = "all" ] || [ "$TARGET" = "web" ]; then
    echo "Building Web Production Bundle..."
    flutter build web --release
fi

if [ "$TARGET" = "all" ] || [ "$TARGET" = "linux" ]; then
    echo "Building Linux x64 Release Bundle..."
    flutter config --enable-linux-desktop
    flutter build linux --release
fi

if [ "$TARGET" = "all" ] || [ "$TARGET" = "android" ]; then
    echo "Building Android Release APK and AAB..."
    flutter build apk --release
    flutter build appbundle --release
fi

echo "Build completed for target: $TARGET"
