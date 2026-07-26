#!/usr/bin/env bash
# build/web を Cloudflare Pages に Direct Upload し、URL を stdout に出す。
# 必要: CLOUDFLARE_API_TOKEN / CLOUDFLARE_ACCOUNT_ID
# 任意: CLOUDFLARE_PAGES_PROJECT (default: teigiii-web-dev)
#       CLOUDFLARE_PAGES_BRANCH  (default: 現在ブランチ or preview)
#
# stdout は捕捉用（URL 1 行のみ）。QR など informational は stderr へ出す。
set -euo pipefail

root="$(cd "$(dirname "$0")/../.." && pwd)"
web_dir="$root/mobile_app/build/web"
project="${CLOUDFLARE_PAGES_PROJECT:-teigiii-web-dev}"
raw_branch="${CLOUDFLARE_PAGES_BRANCH:-$(git -C "$root" rev-parse --abbrev-ref HEAD 2>/dev/null || echo preview)}"
# Pages の branch alias は `/` を扱えないことがあるためサニタイズする。
branch="$(printf '%s' "$raw_branch" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9._-]+/-/g; s/^-+//; s/-+$//; s/-+/-/g')"
if [[ -z "$branch" ]]; then
  branch="preview"
fi

if [[ ! -d "$web_dir" ]]; then
  echo "missing $web_dir — run just web-build first" >&2
  exit 1
fi

if [[ -z "${CLOUDFLARE_API_TOKEN:-}" || -z "${CLOUDFLARE_ACCOUNT_ID:-}" ]]; then
  echo "CLOUDFLARE_API_TOKEN and CLOUDFLARE_ACCOUNT_ID are required" >&2
  exit 1
fi

out="$(mktemp)"
trap 'rm -f "$out"' EXIT

echo "Deploying to project=$project branch=$branch (from $raw_branch)" >&2

# wrangler は完了 URL を stderr に出すことがあるため両方を保存する。
bunx --bun wrangler pages deploy "$web_dir" \
  --project-name="$project" \
  --branch="$branch" \
  --commit-dirty=true \
  2>&1 | tee "$out" >&2

# ANSI を除去してから URL を拾う。
# alias URL（branch 固定）を優先し、無ければ deployment URL を使う。
plain="$(sed -E 's/\x1B\[[0-9;]*[A-Za-z]//g' "$out")"
alias_url="$(printf '%s\n' "$plain" | grep -F 'Deployment alias URL:' | grep -Eo 'https://[a-zA-Z0-9._-]+\.pages\.dev' | head -n1 || true)"
deploy_url="$(printf '%s\n' "$plain" | grep -F 'Deployment complete' | grep -Eo 'https://[a-zA-Z0-9._-]+\.pages\.dev' | head -n1 || true)"
url="${alias_url:-${deploy_url:-}}"

# 取れなければ alias URL をフォールバック
if [[ -z "$url" ]]; then
  if [[ "$branch" == "develop" || "$branch" == "main" || "$branch" == "master" ]]; then
    url="https://${project}.pages.dev"
  else
    url="https://${branch}.${project}.pages.dev"
  fi
  echo "Could not parse deployment URL from wrangler; falling back to $url" >&2
fi

if command -v qrencode >/dev/null 2>&1; then
  echo >&2
  qrencode -t ANSIUTF8 "$url" >&2
fi

# CI 向け: GITHUB_OUTPUT があれば url を書き出す
if [[ -n "${GITHUB_OUTPUT:-}" ]]; then
  echo "url=$url" >>"$GITHUB_OUTPUT"
fi

echo "$url"
