#!/usr/bin/env bash
# prod が origin/develop から乖離していないかを検査する（#322）。
#
# prod は CI ではなくローカルからの手動 deploy なので、「deploy し忘れ」も
# 「migration の適用し忘れ」も誰も検知しない。ここでは prod へ一切書き込まず、
# 次の 2 つの乖離を報告する:
#
#   1. prod Worker に出ている commit（deploy 時に打つ DEPLOYED_SHA）と origin/develop の差
#   2. prod D1 / prod テレメトリ D1 の未適用 migration
#
# 実行には wrangler の OAuth ログイン（just backend-deploy-prod と同じ）が必要。
set -euo pipefail

cd "$(dirname "$0")/../.."

git fetch --quiet origin develop
develop_sha="$(git rev-parse origin/develop)"

cd backend

version_id="$(bunx wrangler deployments status --env prod --json 2>/dev/null |
  jq -er '.versions[0].version_id')"
deployed_sha="$(bunx wrangler versions view "$version_id" --env prod --json 2>/dev/null |
  jq -r '.resources.bindings[] | select(.name == "DEPLOYED_SHA") | .text')"

drifted=0

printf 'origin/develop : %s\n' "$develop_sha"
if [ -z "$deployed_sha" ]; then
  # 初回は #322 より前の deploy なのでスタンプが無い。次の deploy 以降は必ず入る。
  printf 'prod Worker    : (DEPLOYED_SHA 未スタンプ。#322 以降の deploy で付く)\n'
  drifted=1
elif [ "$deployed_sha" != "$develop_sha" ]; then
  printf 'prod Worker    : %s\n' "$deployed_sha"
  printf 'prod Worker is behind origin/develop by %s commits.\n' \
    "$(git rev-list --count "${deployed_sha}..${develop_sha}" 2>/dev/null || echo '?')"
  drifted=1
else
  printf 'prod Worker    : %s (up to date)\n' "$deployed_sha"
fi

for binding in DB TELEMETRY_DB; do
  printf '\n--- %s の未適用 migration ---\n' "$binding"
  migrations="$(bunx wrangler d1 migrations list "$binding" --env prod --remote 2>/dev/null)"
  printf '%s\n' "$migrations"
  if ! grep -q 'No migrations to apply' <<<"$migrations"; then
    drifted=1
  fi
done

if [ "$drifted" -ne 0 ]; then
  printf '\nprod drifted from origin/develop. See doc/specs/workers-api-server.md#prod-deploy\n' >&2
  exit 1
fi

printf '\nprod is in sync with origin/develop.\n'
