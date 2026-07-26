#!/usr/bin/env bash
# リポジトリ直下の .env を現在のシェルへ読み込む（source 用）。
# AdMob と同様、ローカル秘匿は .env（gitignore）に置く。
# Cloudflare の deploy 認証はここに置かない（wrangler OAuth = backend-deploy と同じ）。
#
# 既に環境変数がある場合は上書きしない（CI / 手動 export を優先）。

_root_env_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
_root_env_file="${ROOT_ENV_FILE:-$_root_env_root/.env}"

if [[ ! -f "$_root_env_file" ]]; then
  return 0 2>/dev/null || exit 0
fi

while IFS= read -r line || [[ -n "$line" ]]; do
  [[ "$line" =~ ^[[:space:]]*# ]] && continue
  [[ "$line" =~ ^[[:space:]]*$ ]] && continue
  if [[ "$line" =~ ^([A-Za-z_][A-Za-z0-9_]*)=(.*)$ ]]; then
    key="${BASH_REMATCH[1]}"
    value="${BASH_REMATCH[2]}"
    if [[ "$value" =~ ^\"(.*)\"$ ]] || [[ "$value" =~ ^\'(.*)\'$ ]]; then
      value="${BASH_REMATCH[1]}"
    fi
    if [[ -z "${!key:-}" ]]; then
      export "$key=$value"
    fi
  fi
done < "$_root_env_file"
