#!/usr/bin/env bash
set -euo pipefail

DEMO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$DEMO_DIR"

PROJECT="DemoServerSim.xcodeproj"
SCHEME="DemoServerSim"
BUNDLE_ID="com.iosdailydemo.DemoServerSim"
DERIVED_DATA="${DERIVED_DATA:-/private/tmp/DemoServerSimServeSimDerivedData}"
SERVE_SIM_PORT="${SERVE_SIM_PORT:-3200}"
SERVE_SIM_LOG="${SERVE_SIM_LOG:-/private/tmp/DemoServerSimServeSimPreview.log}"
SERVE_SIM_PID_FILE="${SERVE_SIM_PID_FILE:-/private/tmp/DemoServerSimServeSimPreview.pid}"
DEVICE="${1:-booted}"

if ! command -v serve-sim >/dev/null 2>&1; then
  echo "serve-sim is not installed. Install it with: npm install -g serve-sim" >&2
  exit 1
fi

xcodebuild \
  -project "$PROJECT" \
  -scheme "$SCHEME" \
  -destination "generic/platform=iOS Simulator" \
  -derivedDataPath "$DERIVED_DATA" \
  CODE_SIGNING_ALLOWED=NO \
  build

APP_PATH="$DERIVED_DATA/Build/Products/Debug-iphonesimulator/$SCHEME.app"

xcrun simctl bootstatus "$DEVICE" -b
xcrun simctl install "$DEVICE" "$APP_PATH"
xcrun simctl launch "$DEVICE" "$BUNDLE_ID"

serve-sim --kill >/dev/null 2>&1 || true

if [[ -f "$SERVE_SIM_PID_FILE" ]]; then
  OLD_PREVIEW_PID="$(cat "$SERVE_SIM_PID_FILE" 2>/dev/null || true)"
  if [[ -n "$OLD_PREVIEW_PID" ]] && kill -0 "$OLD_PREVIEW_PID" >/dev/null 2>&1; then
    kill "$OLD_PREVIEW_PID" >/dev/null 2>&1 || true
  fi
fi

STREAM_JSON="$(serve-sim --detach)"
STREAM_DEVICE="$(node -e 'const data = JSON.parse(process.argv[1]); console.log(data.device || "")' "$STREAM_JSON")"
SERVE_SIM_PID="$(node scripts/start-serve-sim-preview.cjs "$SERVE_SIM_PORT" "$SERVE_SIM_LOG" "$SERVE_SIM_PID_FILE" "$STREAM_DEVICE")"

for _ in {1..50}; do
  if curl -fsS "http://127.0.0.1:$SERVE_SIM_PORT" >/dev/null 2>&1; then
    echo "DemoServerSim is running through serve-sim at http://localhost:$SERVE_SIM_PORT"
    echo "serve-sim pid: $SERVE_SIM_PID"
    echo "serve-sim log: $SERVE_SIM_LOG"
    exit 0
  fi

  if ! kill -0 "$SERVE_SIM_PID" >/dev/null 2>&1; then
    echo "serve-sim exited early. Log:" >&2
    tail -n 40 "$SERVE_SIM_LOG" >&2 || true
    exit 1
  fi

  sleep 0.2
done

echo "serve-sim did not become ready at http://localhost:$SERVE_SIM_PORT. Log:" >&2
tail -n 40 "$SERVE_SIM_LOG" >&2 || true
exit 1
