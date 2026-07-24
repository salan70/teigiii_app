#!/usr/bin/env bash
# build/web を Cloudflare Pages に Direct Upload し、URL を表示する。
# 必要: CLOUDFLARE_API_TOKEN / CLOUDFLARE_ACCOUNT_ID
# 任意: CLOUDFLARE_PAGES_PROJECT (default: teigiii-web-dev)
#       CLOUDFLARE_PAGES_BRANCH  (default: 現在ブランチ or preview)
set -euo pipefail

root="$(cd "$(dirname "$0")/../.." && pwd)"
web_dir="$root/mobile_app/build/web"
project="${CLOUDFLARE_PAGES_PROJECT:-teigiii-web-dev}"
branch="${CLOUDFLARE_PAGES_BRANCH:-$(git -C "$root" rev-parse --abbrev-ref HEAD 2>/dev/null || echo preview)}"

if [[ ! -d "$web_dir" ]]; then
  echo "missing $web_dir — run just web-build first" >&2
  exit 1
fi

if [[ -z "${CLOUDFLARE_API_TOKEN:-}" || -z "${CLOUDFLARE_ACCOUNT_ID:-}" ]]; then
  echo "CLOUDFLARE_API_TOKEN and CLOUDFLARE_ACCOUNT_ID are required" >&2
  exit 1
fi

out="$(mktemp)"
bunx --bun wrangler pages deploy "$web_dir" \
  --project-name="$project" \
  --branch="$branch" \
  --commit-dirty=true \
  | tee "$out"

# wrangler が出す https URL を拾う
url="$(rg -o 'https://[a-zA-Z0-9._/-]+\.pages\.dev' "$out" | head -n1 || true)"
if [[ -z "$url" ]]; then
  echo "Deploy finished but could not parse Pages URL from wrangler output" >&2
  exit 1
fi

echo "$url"
if command -v qrencode >/dev/null 2>&1; then
  echo
  qrencode -t ANSIUTF8 "$url"
fi
