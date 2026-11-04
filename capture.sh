#!/usr/bin/env bash
# capture.sh — screenshot desktop + mobile views of CAPTURE_URL
set -euo pipefail

TIME="$(command -v /usr/bin/time || echo time)"

if [ -z "${CAPTURE_URL:-}" ] || [ -z "${CAPTURE_DIR:-}" ]; then
  echo "ERROR: CAPTURE_URL and CAPTURE_DIR environment variables are required" >&2
  exit 1
fi

cd "$(dirname "$0")"

echo "[capture] CAPTURE_URL=$CAPTURE_URL"
echo "[capture] CAPTURE_DIR=$CAPTURE_DIR"

# Ensure capture output directory exists (outside source tree)
$TIME -p mkdir -p "$CAPTURE_DIR"

# Run the capture via the runtime's Playwright-based capture script.
#   - Exits 75 for temporary navigation / browser infrastructure failures
#   - Exits 1 for script or rendering defects
#   - Captures desktop (1440x900) -> final-desktop.png
#   - Captures mobile   (390x844)  -> final-mobile.png
$TIME -p node "${RUNTIME_DIR:?}/scripts/default-capture.mjs"

echo "[capture] screenshots written to $CAPTURE_DIR"
ls -la "$CAPTURE_DIR"/final-*.png
