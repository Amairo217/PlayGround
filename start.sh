#!/usr/bin/env bash
# start.sh — build static output and serve the Pemandian Gunung Danau game
set -euo pipefail

TIME="$(command -v /usr/bin/time || echo time)"

# Change to the script's directory (PROJECT_DIR)
PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$PROJECT_DIR"

PORT="${PORT:-3000}"
DIST_DIR="$PROJECT_DIR/dist"

echo "[start] PROJECT_DIR=$PROJECT_DIR"
echo "[start] PORT=$PORT"

# ---- build: static output inside PROJECT_DIR/dist ---------------------------
$TIME -p mkdir -p "$DIST_DIR"

# Copy the single-file game as index.html (static entry point)
$TIME -p cp game-gunung-danau.html "$DIST_DIR/index.html"

# ---- write deployment-output.json to OPENCODE_WEB_DIR (worker metadata) -----
WEB_DIR="${OPENCODE_WEB_DIR:-$RUNNER_TEMP/omgithub-web}"
$TIME -p mkdir -p "$WEB_DIR"
$TIME -p sh -c 'printf "{\"project\":\"%s\",\"directory\":\"%s\"}\n" "$1" "$2" > "$3/deployment-output.json"' _ "$PROJECT_DIR" "$DIST_DIR" "$WEB_DIR"

echo "[start] deployment-output.json written to $WEB_DIR/deployment-output.json"
echo "[start] serving static build from $DIST_DIR on port $PORT"

# ---- serve in foreground ----------------------------------------------------
exec $TIME -p python3 -m http.server "$PORT" --directory "$DIST_DIR"
