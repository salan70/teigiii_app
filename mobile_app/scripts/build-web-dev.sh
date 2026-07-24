#!/usr/bin/env bash
# Flutter Web (dev) をビルドする。
# 任意: FIREBASE_WEB_API_KEY / FIREBASE_WEB_APP_ID / APP_CHECK_DEBUG_TOKEN
set -euo pipefail

root="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$root/mobile_app"

bash "$root/mobile_app/scripts/inject-app-check-debug-token.sh"

# index.html を汚さないよう、ビルド後にプレースホルダへ戻す
restore_index() {
  git -C "$root" checkout -- mobile_app/web/index.html 2>/dev/null || true
}
trap restore_index EXIT

extra_defines=()
if [[ -n "${FIREBASE_WEB_API_KEY:-}" ]]; then
  extra_defines+=(--dart-define="FIREBASE_WEB_API_KEY=${FIREBASE_WEB_API_KEY}")
fi
if [[ -n "${FIREBASE_WEB_APP_ID:-}" ]]; then
  extra_defines+=(--dart-define="FIREBASE_WEB_APP_ID=${FIREBASE_WEB_APP_ID}")
fi
if [[ -n "${APP_CHECK_DEBUG_TOKEN:-}" ]]; then
  extra_defines+=(--dart-define="APP_CHECK_DEBUG_TOKEN=${APP_CHECK_DEBUG_TOKEN}")
fi

flutter build web --release --no-wasm-dry-run \
  --dart-define-from-file=dart_defines/dev.json \
  "${extra_defines[@]}"
