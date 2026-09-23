#!/usr/bin/env bash
set -eo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
ACTION="${1:-test}"
PORT="${2:-8080}"
IMAGE_TAG="chessmaster:latest"

# 1. Detect Container Engine (Prefer Podman)
if command -v podman &> /dev/null; then
    CONTAINER_ENGINE="podman"
elif command -v docker &> /dev/null; then
    CONTAINER_ENGINE="docker"
else
    echo "ERROR: Neither podman nor docker CLI found in PATH." >&2
    exit 1
fi

echo "======================================================"
echo "       CHESSMASTER PODMAN CONTAINER RUNNER            "
echo "======================================================"
echo "Container Engine : $CONTAINER_ENGINE"
echo "Target Action    : $ACTION"
echo "Workspace Root   : $ROOT_DIR"
echo "------------------------------------------------------"

# 2. Check if image exists before running actions
if [ "$ACTION" != "build" ]; then
    if ! $CONTAINER_ENGINE image exists "$IMAGE_TAG" 2>/dev/null; then
        echo "[Container] Image '$IMAGE_TAG' not found locally. Auto-building image first..."
        $CONTAINER_ENGINE build -t "$IMAGE_TAG" -f "$ROOT_DIR/infra/Containerfile" "$ROOT_DIR"
    fi
fi

case "$ACTION" in
    build)
        echo "[Container] Building image $IMAGE_TAG via $CONTAINER_ENGINE..."
        $CONTAINER_ENGINE build -t "$IMAGE_TAG" -f "$ROOT_DIR/infra/Containerfile" "$ROOT_DIR"
        ;;
    test)
        echo "[Container] Running monorepo tests in isolated container..."
        $CONTAINER_ENGINE run --rm -v "$ROOT_DIR:/workspace:z" -w /workspace "$IMAGE_TAG" bash scripts/test.sh
        ;;
    coverage)
        echo "[Container] Running coverage collection & gates in container..."
        $CONTAINER_ENGINE run --rm -v "$ROOT_DIR:/workspace:z" -w /workspace "$IMAGE_TAG" bash -c "cd tool && dart pub get && dart run coverage_runner.dart"
        ;;
    performance)
        echo "[Container] Running performance benchmarks in container..."
        $CONTAINER_ENGINE run --rm -v "$ROOT_DIR:/workspace:z" -w /workspace "$IMAGE_TAG" bash -c "cd tool && dart pub get && dart run performance_runner.dart"
        ;;
    security)
        echo "[Container] Running security audit in container..."
        $CONTAINER_ENGINE run --rm -v "$ROOT_DIR:/workspace:z" -w /workspace "$IMAGE_TAG" bash -c "cd tool && dart pub get && dart run security_runner.dart"
        ;;
    acceptance)
        echo "[Container] Running full acceptance certification in container..."
        $CONTAINER_ENGINE run --rm -v "$ROOT_DIR:/workspace:z" -w /workspace "$IMAGE_TAG" bash scripts/acceptance.sh --full
        ;;
    content-validate)
        echo "[Container] Running 90-day content depth & legal move validator in container..."
        $CONTAINER_ENGINE run --rm -v "$ROOT_DIR:/workspace:z" -w /workspace "$IMAGE_TAG" bash -c "cd tool && dart pub get && dart run content_validator.dart"
        ;;
    simulation-validate)
        echo "[Container] Running 90-day deterministic simulation runner in container..."
        $CONTAINER_ENGINE run --rm -v "$ROOT_DIR:/workspace:z" -w /workspace "$IMAGE_TAG" bash -c "cd tool && dart pub get && dart run simulation_runner.dart"
        ;;
    certify)
        echo "[Container] Running end-to-end certification gate in container..."
        $CONTAINER_ENGINE run --rm -v "$ROOT_DIR:/workspace:z" -w /workspace "$IMAGE_TAG" bash -c "bash scripts/test.sh && cd tool && dart pub get && dart run content_validator.dart && dart run pedagogy_auditor.dart && dart run simulation_runner.dart && dart run coverage_runner.dart && dart run performance_runner.dart && dart run security_runner.dart && dart run forensic_auditor.dart && dart run release_manifest_generator.dart && cd ../tests && dart pub get && dart run acceptance_runner.dart --full"
        ;;
    shell)
        echo "[Container] Launching interactive shell..."
        $CONTAINER_ENGINE run -it --rm -v "$ROOT_DIR:/workspace:z" -w /workspace "$IMAGE_TAG" bash
        ;;
    serve)
        echo "[Container] Serving ChessMaster Web on http://localhost:$PORT..."
        $CONTAINER_ENGINE run --rm -p "$PORT:8080" -v "$ROOT_DIR:/workspace:z" -w /workspace "$IMAGE_TAG" bash scripts/up.sh 8080
        ;;
    *)
        echo "Unknown action: $ACTION. Supported: build, test, coverage, performance, security, acceptance, shell, serve" >&2
        exit 1
        ;;
esac

echo "Container operation '$ACTION' completed."
