#!/usr/bin/env bash
# Flutter Web (dev) をビルドする。
# 任意: FIREBASE_WEB_API_KEY / FIREBASE_WEB_APP_ID / APP_CHECK_DEBUG_TOKEN
#
# 作業ツリーの web/index.html は触らない。App Check debug token は
# ビルド成果物（build/web/index.html）へ後から注入する。
set -euo pipefail

root="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$root/mobile_app"

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

bash "$root/mobile_app/scripts/inject-app-check-debug-token.sh" \
  "$root/mobile_app/build/web/index.html"
