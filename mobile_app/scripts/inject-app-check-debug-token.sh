#!/usr/bin/env bash
# index.html の FIREBASE_APPCHECK_DEBUG_TOKEN を固定トークンへ置換する。
# 第一引数で対象ファイルを指定（省略時は mobile_app/web/index.html）。
# APP_CHECK_DEBUG_TOKEN 未設定時は何もしない（index.html 既定の true = auto-generate）。
set -euo pipefail

root="$(cd "$(dirname "$0")/../.." && pwd)"
index="${1:-$root/mobile_app/web/index.html}"

if [[ ! -f "$index" ]]; then
  echo "missing $index" >&2
  exit 1
fi

token="${APP_CHECK_DEBUG_TOKEN:-}"
if [[ -z "$token" ]]; then
  echo "APP_CHECK_DEBUG_TOKEN unset; keeping auto-generate (true)" >&2
  exit 0
fi

# App Check debug token は UUID。sed メタ文字混入を避けるため形式を検証する。
if [[ ! "$token" =~ ^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$ ]]; then
  echo "APP_CHECK_DEBUG_TOKEN must be a UUID (got: ${token})" >&2
  exit 1
fi

# リテラル置換（sed の置換文字列に token を埋め込まない）
python3 - "$index" "$token" <<'PY'
import pathlib
import sys

path = pathlib.Path(sys.argv[1])
token = sys.argv[2]
needle = "self.FIREBASE_APPCHECK_DEBUG_TOKEN = true;"
replacement = f'self.FIREBASE_APPCHECK_DEBUG_TOKEN = "{token}";'
text = path.read_text()
if needle not in text:
    raise SystemExit(f"placeholder not found in {path}")
path.write_text(text.replace(needle, replacement, 1))
PY

echo "Injected fixed FIREBASE_APPCHECK_DEBUG_TOKEN into $index" >&2
