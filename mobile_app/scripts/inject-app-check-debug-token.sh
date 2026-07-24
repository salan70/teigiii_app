#!/usr/bin/env bash
# web/index.html の FIREBASE_APPCHECK_DEBUG_TOKEN を固定トークンへ置換する。
# APP_CHECK_DEBUG_TOKEN 未設定時は何もしない（index.html 既定の true = auto-generate）。
set -euo pipefail

root="$(cd "$(dirname "$0")/../.." && pwd)"
index="$root/mobile_app/web/index.html"

if [[ ! -f "$index" ]]; then
  echo "missing $index" >&2
  exit 1
fi

token="${APP_CHECK_DEBUG_TOKEN:-}"
if [[ -z "$token" ]]; then
  echo "APP_CHECK_DEBUG_TOKEN unset; keeping auto-generate (true)" >&2
  exit 0
fi

tmp="$(mktemp)"
# 既定の `true` を登録済みデバッグトークン文字列へ置換する
sed "s/self\.FIREBASE_APPCHECK_DEBUG_TOKEN = true;/self.FIREBASE_APPCHECK_DEBUG_TOKEN = \"${token}\";/g" \
  "$index" >"$tmp"
mv "$tmp" "$index"
echo "Injected fixed FIREBASE_APPCHECK_DEBUG_TOKEN" >&2
