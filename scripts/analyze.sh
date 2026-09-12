#!/usr/bin/env bash
set -e

WORKSPACE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$WORKSPACE_DIR"

PACKAGES=(
  "packages/chess_core"
  "packages/chess_engine"
  "packages/chess_learning"
  "packages/chess_curriculum"
  "packages/chess_labs"
  "packages/chess_storage"
  "packages/chess_content"
  "packages/chess_video"
  "apps/chess_app"
  "tool"
)

echo "======================================================"
echo "          CHESSMASTER MONOREPO STATIC ANALYSIS        "
echo "======================================================"

EXIT_CODE=0

for dir in "${PACKAGES[@]}"; do
  echo ""
  echo ">>> Analyzing $dir..."
  if [ -d "$dir" ]; then
    (
      cd "$dir"
      if [ -f "pubspec.yaml" ] && grep -q "sdk: flutter" "pubspec.yaml"; then
        flutter pub get > /dev/null 2>&1 || true
        flutter analyze .
      else
        dart pub get --offline > /dev/null 2>&1 || dart pub get > /dev/null 2>&1 || true
        dart analyze .
      fi
    ) || {
      echo "❌ $dir had analysis issues!"
      EXIT_CODE=1
    }
  else
    echo "⚠️ Directory $dir not found"
  fi
done

echo ""
echo "======================================================"
if [ $EXIT_CODE -eq 0 ]; then
  echo "🎉 ALL MONOREPO PACKAGES PASSED STATIC ANALYSIS CLEANLY!"
else
  echo "❌ STATIC ANALYSIS FOUND ISSUES!"
fi
echo "======================================================"

exit $EXIT_CODE
