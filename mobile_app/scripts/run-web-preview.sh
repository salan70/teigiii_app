#!/usr/bin/env bash
# ローカル Web QA: .env 読み込み → build → Pages deploy。
#
# Cloudflare 認証: backend-deploy と同じ wrangler OAuth（token ファイル不要）。
# Firebase Web / App Check: ルート .env（AdMob と同じ置き場）。
# CI: GitHub secrets が既に export されていればそれを使う。
set -euo pipefail

root="$(cd "$(dirname "$0")/../.." && pwd)"
# shellcheck source=load-root-env.sh
source "$root/mobile_app/scripts/load-root-env.sh"

env_file="${ROOT_ENV_FILE:-$root/.env}"

missing=()
[[ -n "${FIREBASE_WEB_API_KEY:-}" ]] || missing+=("FIREBASE_WEB_API_KEY")
[[ -n "${FIREBASE_WEB_APP_ID:-}" ]] || missing+=("FIREBASE_WEB_APP_ID")
[[ -n "${APP_CHECK_DEBUG_TOKEN:-}" ]] || missing+=("APP_CHECK_DEBUG_TOKEN")

if ((${#missing[@]} > 0)); then
  echo "Missing required Web QA keys in $env_file (or environment): ${missing[*]}" >&2
  echo "Add them to the repo-root .env (same file as AdMob banner IDs)." >&2
  echo "Cloudflare deploy auth is wrangler OAuth — do not put CLOUDFLARE_API_TOKEN in .env." >&2
  exit 1
fi

bash "$root/mobile_app/scripts/build-web-dev.sh"
bash "$root/mobile_app/scripts/deploy-web-pages.sh"
