#!/usr/bin/env bash
# build/web を Cloudflare Pages に Direct Upload し、URL を stdout に出す。
#
# 認証（どちらか）:
#   1. ローカル: wrangler OAuth（`wrangler login`）— backend-deploy と同じ
#   2. CI: CLOUDFLARE_API_TOKEN + CLOUDFLARE_ACCOUNT_ID
#
# 任意: CLOUDFLARE_PAGES_PROJECT (default: teigiii-web-dev)
#       CLOUDFLARE_PAGES_BRANCH  (default: 現在ブランチ or preview)
#
# Pages プロジェクト側 secrets（preview / production 枠）:
#   WEB_PREVIEW_BASIC_AUTH_USER / WEB_PREVIEW_BASIC_AUTH_PASSWORD
# 未設定だと Functions が 500 を返す（fail-closed）。
#
# stdout は捕捉用（URL 1 行のみ）。QR など informational は stderr へ出す。
set -euo pipefail

root="$(cd "$(dirname "$0")/../.." && pwd)"
# shellcheck source=load-root-env.sh
source "$root/mobile_app/scripts/load-root-env.sh"
# shellcheck source=sanitize-pages-branch.sh
source "$root/mobile_app/scripts/sanitize-pages-branch.sh"

web_dir="$root/mobile_app/build/web"
project="${CLOUDFLARE_PAGES_PROJECT:-teigiii-web-dev}"
raw_branch="${CLOUDFLARE_PAGES_BRANCH:-$(git -C "$root" rev-parse --abbrev-ref HEAD 2>/dev/null || echo preview)}"
branch="$(sanitize_pages_branch "$raw_branch")"

if [[ ! -d "$web_dir" ]]; then
  echo "missing $web_dir — run just web-build first" >&2
  exit 1
fi

token_set=0
account_set=0
[[ -n "${CLOUDFLARE_API_TOKEN:-}" ]] && token_set=1
[[ -n "${CLOUDFLARE_ACCOUNT_ID:-}" ]] && account_set=1

if ((token_set == 1 && account_set == 0)); then
  echo "CLOUDFLARE_API_TOKEN is set but CLOUDFLARE_ACCOUNT_ID is missing" >&2
  exit 1
fi
if ((token_set == 0 && account_set == 1)); then
  echo "CLOUDFLARE_ACCOUNT_ID is set but CLOUDFLARE_API_TOKEN is missing" >&2
  exit 1
fi
if ((token_set == 1)); then
  echo "Using CLOUDFLARE_API_TOKEN for Pages deploy (CI / explicit token)" >&2
else
  echo "Using wrangler OAuth for Pages deploy (same as just backend-deploy-*)" >&2
  echo "If auth fails, run: cd backend && bunx wrangler login" >&2
fi

# Pages Advanced mode (_worker.js) で Basic Auth する。
# flutter build が web/ をコピーするが、deploy-only でも必ず最新を載せる。
# functions/ があると _worker.js が無視されることがあるため除去する。
rm -rf "$web_dir/functions"
cp "$root/mobile_app/web/_worker.js" "$web_dir/_worker.js"
mkdir -p "$web_dir/_lib"
cp "$root/mobile_app/web/_lib/basic-auth.js" "$web_dir/_lib/basic-auth.js"
if [[ ! -f "$web_dir/_worker.js" ]]; then
  echo "missing $web_dir/_worker.js" >&2
  exit 1
fi

out="$(mktemp)"
trap 'rm -f "$out"' EXIT

echo "Deploying to project=$project branch=$branch (from $raw_branch)" >&2
echo "Pages Basic Auth is enforced by _worker.js (secrets on Pages project)" >&2

# リポジトリ root で実行し、Workers 用 wrangler.toml を拾わせない。
# ローカル / CI で backend 依存があればその wrangler を使う。
# フォールバックの bunx は --bun を付けない（非 TTY で即終了する事例あり）。
# pipe+tee だと途中終了することがあるため、ファイルへ完全に書いてから表示する。
wrangler_bin="$root/backend/node_modules/.bin/wrangler"
set +e
(
  cd "$root"
  if [[ -x "$wrangler_bin" ]]; then
    echo "Using $wrangler_bin" >&2
    "$wrangler_bin" pages deploy "$web_dir" \
      --project-name="$project" \
      --branch="$branch" \
      --commit-dirty=true
  else
    echo "Using bunx wrangler (no --bun)" >&2
    bunx wrangler pages deploy "$web_dir" \
      --project-name="$project" \
      --branch="$branch" \
      --commit-dirty=true
  fi
) >"$out" 2>&1
status=$?
set -e
cat "$out" >&2

if [[ "$status" -ne 0 ]]; then
  echo "wrangler pages deploy failed (exit $status)" >&2
  exit "$status"
fi

# ANSI を除去してから URL を拾う。
# alias URL（branch 固定）を優先し、無ければ deployment URL を使う。
plain="$(sed -E 's/\x1B\[[0-9;]*[A-Za-z]//g' "$out")"
if ! grep -q 'Deployment complete' <<<"$plain"; then
  echo "wrangler pages deploy produced no 'Deployment complete' line" >&2
  exit 1
fi

alias_url="$(printf '%s\n' "$plain" | grep -F 'Deployment alias URL:' | grep -Eo 'https://[a-zA-Z0-9._-]+\.pages\.dev' | head -n1 || true)"
deploy_url="$(printf '%s\n' "$plain" | grep -F 'Deployment complete' | grep -Eo 'https://[a-zA-Z0-9._-]+\.pages\.dev' | head -n1 || true)"
url="${alias_url:-${deploy_url:-}}"

if [[ -z "$url" ]]; then
  echo "Could not parse deployment URL from wrangler output" >&2
  exit 1
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
