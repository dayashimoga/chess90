#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "Packaging ChessMaster Release Artifacts..."

# 1. Package Web
if [ -d "$ROOT_DIR/apps/chess_app/build/web" ]; then
    if command -v zip >/dev/null 2>&1; then
        (cd "$ROOT_DIR/apps/chess_app/build/web" && zip -rq "$ROOT_DIR/ChessMaster-Web.zip" .)
    else
        python3 -c "import shutil; shutil.make_archive('$ROOT_DIR/ChessMaster-Web', 'zip', '$ROOT_DIR/apps/chess_app/build/web')"
    fi
fi

# 2. Package Linux
if [ -d "$ROOT_DIR/apps/chess_app/build/linux/x64/release/bundle" ]; then
    echo "Packaging ChessMaster-Linux-x64.tar.gz..."
    tar -czf "$ROOT_DIR/ChessMaster-Linux-x64.tar.gz" -C "$ROOT_DIR/apps/chess_app/build/linux/x64/release/bundle" .
fi

# 3. Copy Android
if [ -f "$ROOT_DIR/apps/chess_app/build/app/outputs/flutter-apk/app-release.apk" ]; then
    cp "$ROOT_DIR/apps/chess_app/build/app/outputs/flutter-apk/app-release.apk" "$ROOT_DIR/ChessMaster.apk"
fi
if [ -f "$ROOT_DIR/apps/chess_app/build/app/outputs/bundle/release/app-release.aab" ]; then
    cp "$ROOT_DIR/apps/chess_app/build/app/outputs/bundle/release/app-release.aab" "$ROOT_DIR/ChessMaster.aab"
fi

# 4. Generate SHA256SUMS
echo "Generating SHA256SUMS..."
cd "$ROOT_DIR"
sha256sum $(ls ChessMaster-Web.zip ChessMaster-Linux-x64.tar.gz ChessMaster-Windows-x64.zip ChessMaster-Portable.exe ChessMaster-Setup.exe ChessMaster.apk ChessMaster.aab 2>/dev/null) > SHA256SUMS || true
echo "Packaging complete."
