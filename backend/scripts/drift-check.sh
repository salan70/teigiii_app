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
#
# 終了コード: 0 = 一致 / 1 = 乖離あり / 2 = 検査自体が失敗（認証切れ・API 障害など）。
# 「乖離」と「検査不能」を混同すると、通知を見た側が prod の状態を誤って安心するため分ける。
set -euo pipefail

cd "$(dirname "$0")/../.."

git fetch --quiet origin develop
develop_sha="$(git rev-parse origin/develop)"

cd backend

stderr_file="$(mktemp)"
trap 'rm -f "$stderr_file"' EXIT

# wrangler の stderr は握り潰さない。認証切れや API 障害を「原因不明の非 0 終了」にすると、
# 乖離しているのか検査できていないのかを実行者が区別できなくなる。
# exit を効かせるため、この関数はサブシェル（コマンド置換）の中から呼ばない。
fail() {
  printf 'drift-check could not run: %s\n' "$1" >&2
  cat "$stderr_file" >&2
  exit 2
}

status_json="$(bunx wrangler deployments status --env prod --json 2>"$stderr_file")" ||
  fail 'wrangler deployments status --env prod'
version_id="$(jq -er '.versions[0].version_id' <<<"$status_json")" ||
  fail 'no version id in deployments status output'

version_json="$(bunx wrangler versions view "$version_id" --env prod --json 2>"$stderr_file")" ||
  fail "wrangler versions view ${version_id} --env prod"
deployed_sha="$(jq -r '.resources.bindings[] | select(.name == "DEPLOYED_SHA") | .text' \
  <<<"$version_json")" || fail 'could not read DEPLOYED_SHA from version bindings'

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
  migrations="$(bunx wrangler d1 migrations list "$binding" --env prod --remote 2>"$stderr_file")" ||
    fail "wrangler d1 migrations list ${binding} --env prod --remote"
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
