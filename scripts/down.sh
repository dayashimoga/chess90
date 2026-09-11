#!/usr/bin/env bash
set -euo pipefail

PORT="${1:-8080}"
echo "Stopping dev servers on port $PORT..."
fuser -k "${PORT}/tcp" || true
echo "Done."
