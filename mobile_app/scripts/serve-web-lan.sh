#!/usr/bin/env bash
# build/web を LAN 向けに配信し、URL と QR を出す。
set -euo pipefail

root="$(cd "$(dirname "$0")/../.." && pwd)"
web_dir="$root/mobile_app/build/web"
port="${WEB_SERVE_PORT:-4173}"

if [[ ! -d "$web_dir" ]]; then
  echo "missing $web_dir — run just web-build first" >&2
  exit 1
fi

ip="$(ipconfig getifaddr en0 2>/dev/null || true)"
if [[ -z "$ip" ]]; then
  ip="$(hostname -I 2>/dev/null | awk '{print $1}' || true)"
fi
if [[ -z "$ip" ]]; then
  ip="127.0.0.1"
fi

url="http://${ip}:${port}"
echo "Serving $web_dir at $url"
if command -v qrencode >/dev/null 2>&1; then
  qrencode -t ANSIUTF8 "$url"
fi

cd "$web_dir"
exec python3 -m http.server "$port" --bind 0.0.0.0
