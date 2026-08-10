set shell := ["bash", "-euc"]

default:
    just --list

# --- 横断（モバイル + バックエンド）---

# mobile / backend の依存を入れる（flutter clean はしない）
setup: mobile-setup backend-setup

analyze: mobile-analyze backend-analyze

format: mobile-format backend-format

# 整形せずに違反の有無だけを判定する（CI と同じ判定）
format-check: mobile-format-check backend-format-check

test: mobile-test backend-test web-test

# backend/openapi.json から Dart API クライアントを mobile_app/packages/teigiii_api に生成する
generate-api:
    openapi-generator-cli generate -i backend/openapi.json -g dart-dio -o mobile_app/packages/teigiii_api \
      --additional-properties=pubName=teigiii_api,serializationLibrary=json_serializable
    cd mobile_app/packages/teigiii_api && dart pub get && dart run build_runner build --delete-conflicting-outputs && dart format .

docbridge-check:
    bunx docbridge@0.5.2 check

# --- mobile（Flutter アプリ）---

# 依存導入のみ（ビルドキャッシュは消さない）
mobile-setup:
    cd mobile_app && flutter pub get

# ビルドキャッシュを明示的に消すとき用
mobile-clean:
    cd mobile_app && flutter clean

# build_runner / freezed 等は dart_style 3.x を使う（#315 案 A）。
# SDK の dart format とスタイルを揃え、生成後整形は保険として残す。
mobile-generate:
    cd mobile_app && dart run build_runner build --delete-conflicting-outputs
    cd mobile_app && dart format .

mobile-analyze:
    cd mobile_app && flutter analyze --no-fatal-infos

mobile-format:
    cd mobile_app && dart format .

# 整形せずに違反の有無だけを判定する（CI 用）
mobile-format-check:
    cd mobile_app && dart format --set-exit-if-changed --output=none .

# デザインシステム違反検出（新規違反・違反増加で失敗する）
mobile-ds-check:
    cd mobile_app && dart run tool/ds_check.dart

# 違反が減ったときに baseline を再生成する
mobile-ds-baseline-update:
    cd mobile_app && dart run tool/ds_check.dart --update-baseline

# Ds コンポーネントのカタログをローカル起動する（iOS ビルドは flavor / dart defines 必須）
mobile-widgetbook:
    cd mobile_app && flutter run -t widgetbook/main.dart --flavor dev --dart-define-from-file=dart_defines/dev.json

# カタログが壊れていないかを build で検証する
mobile-widgetbook-build:
    cd mobile_app && flutter build web -t widgetbook/main.dart --output build/widgetbook

# golden はローカル限定（CI では実行しない）。移行前後の比較に使う
mobile-test-golden:
    cd mobile_app && TZ=Asia/Tokyo flutter test --tags golden

# golden を撮り直す
mobile-test-golden-update:
    cd mobile_app && TZ=Asia/Tokyo flutter test --tags golden --update-goldens

# 日時表示の回帰テストが UTC では検出漏れになるため Asia/Tokyo に固定する
mobile-test:
    cd mobile_app && TZ=Asia/Tokyo flutter test --exclude-tags golden

mobile-coverage:
    cd mobile_app && flutter test --coverage
    cd mobile_app && lcov --remove coverage/lcov.info '*.freezed.dart' '*.g.dart' '*/repository*' -o coverage/lcov.info
    cd mobile_app && genhtml coverage/lcov.info -o coverage/html

mobile-coverage-open: mobile-coverage
    open mobile_app/coverage/html/index.html

mobile-run-dev:
    cd mobile_app && flutter run --flavor dev --dart-define-from-file=dart_defines/dev.json

# 指定した端末で dev flavor を起動する（`flutter devices` で端末 ID を確認）
# iOS 26 実機の debug は USB 推奨。無線 debug は重い。詳細は doc/ios-physical-device-debug.md
mobile-run-dev-on device:
    cd mobile_app && flutter run -d "{{device}}" --flavor dev --dart-define-from-file=dart_defines/dev.json

# 実機向け（無線可）: AOT profile。hot reload なし。端末固有確認向き
mobile-run-dev-profile-on device:
    cd mobile_app && flutter run -d "{{device}}" --profile --flavor dev --dart-define-from-file=dart_defines/dev.json

mobile-run-prod:
    cd mobile_app && flutter run --flavor prod --dart-define-from-file=dart_defines/prod.json

mobile-check-ios-flavors:
    bash mobile_app/ios/scripts/check_flavor_configuration.sh

mobile-check-ios-native-asset binary sdk:
    bash mobile_app/ios/scripts/check_native_asset_platform.sh "{{binary}}" "{{sdk}}"

# --- web QA（dev 固定・本番提供外）---

# Pages Functions（Basic Auth）の単体テスト
web-test:
    bun test mobile_app/scripts/basic-auth.test.ts mobile_app/scripts/sanitize-pages-branch.test.ts

# Flutter Web (dev) をビルドする
web-build:
    bash mobile_app/scripts/build-web-dev.sh

# ビルド → Cloudflare Pages へ deploy → URL/QR を表示する
# Cloudflare 認証は wrangler OAuth（just backend-deploy-* と同じ）。
# FIREBASE_WEB_* / APP_CHECK_DEBUG_TOKEN はルート .env に置く（AdMob と同じ）。
web-preview:
    bash mobile_app/scripts/run-web-preview.sh

# ビルド → LAN 向け http.server → URL/QR を表示する（Basic Auth なし）
# Firebase / App Check を使うならルート .env にキーを置く
web-serve: web-build
    bash mobile_app/scripts/serve-web-lan.sh

# --- backend（Cloudflare Workers API）---

backend-setup:
    cd backend && bun install

# lint + typecheck（横断の `analyze` から呼ばれる）
backend-analyze:
    cd backend && bun run lint && bun run typecheck

backend-format:
    cd backend && bun run format

# 整形せずに違反の有無だけを判定する（CI 用）
backend-format-check:
    cd backend && bun run format:check

backend-test:
    cd backend && bun run test

# openapi.json と Drizzle マイグレーション SQL（本体・テレメトリ）を生成する
backend-generate:
    cd backend && bun run generate:openapi && bun run generate:migrations && bun run generate:migrations:telemetry

backend-dev:
    cd backend && bun run dev

# dev D1 に未適用の migration を反映する
backend-migrate-dev:
    cd backend && bunx wrangler d1 migrations apply DB --env dev --remote

# dev テレメトリ D1 に未適用の migration を反映する
backend-migrate-dev-telemetry:
    cd backend && bunx wrangler d1 migrations apply TELEMETRY_DB --env dev --remote

# app-config の初期行だけを冪等に作成する
backend-seed-dev:
    cd backend && bunx wrangler d1 execute DB --env dev --remote --command "insert into app_config (id, min_app_version_ios, min_app_version_android, in_maintenance, maintenance_scheduled_end_time, perf_telemetry_enabled, updated_at) values (1, '0.0.0', '0.0.0', 0, null, 1, unixepoch('now') * 1000) on conflict(id) do nothing"

# AVATAR_BASE_URL のプレースホルダ検査は、deploy 直前ではなく PR 時点で落とすべきなので
# ci.yml の backend-analyze へ移設した。
# migration（本体 + テレメトリ）と app-config 初期化を完了してから dev Worker を deploy する（ci.yml からも実行される）
backend-deploy-dev: backend-migrate-dev backend-migrate-dev-telemetry backend-seed-dev
    cd backend && bunx wrangler deploy --env dev

# 正規の Firebase ID token / App Check token を使って dev Worker を smoke test する
backend-smoke-dev:
    backend/scripts/smoke-dev.sh

# remote dev bindings に対して Scheduled Handler を手動起動できる状態にする
backend-dev-remote-scheduled:
    cd backend && bunx wrangler dev --env dev --remote --test-scheduled

# prod bundle と bindings の解決を deploy せず検証する
backend-validate-prod:
    cd backend && bunx wrangler deploy --env prod --dry-run --outdir /tmp/teigiii-api-prod-dry-run

# prod D1 に未適用の migration を反映する
backend-migrate-prod:
    cd backend && bunx wrangler d1 migrations apply DB --env prod --remote

# prod テレメトリ D1 に未適用の migration を反映する
backend-migrate-prod-telemetry:
    cd backend && bunx wrangler d1 migrations apply TELEMETRY_DB --env prod --remote

# migration は forward-only で、destructive な migration（table recreate）は cascade で
# 関連行まで落とす。失敗時の唯一の戻し手段が Time Travel なので、適用前に bookmark を控える。
# prod D1 の現在の Time Travel bookmark を表示する（migration の直前に実行して控える）
backend-bookmark-prod:
    cd backend && bunx wrangler d1 time-travel info DB --env prod

# prod D1 を bookmark 時点へ復元する（migration 失敗時の復旧用。実行前に確認を求める）
backend-restore-prod bookmark:
    #!/usr/bin/env bash
    set -euo pipefail
    echo "prod D1 (teigiii-prod) を bookmark {{bookmark}} 時点へ復元します。"
    echo "この操作以降に書き込まれた prod データは失われます。"
    read -r -p "続行するには 'restore prod' と入力: " confirmation
    if [ "$confirmation" != 'restore prod' ]; then
      echo 'Aborted.' >&2
      exit 1
    fi
    cd backend && bunx wrangler d1 time-travel restore DB --env prod --bookmark '{{bookmark}}'

# prod の app_config を表示する（読み取りのみ）
backend-app-config-prod:
    cd backend && bunx wrangler d1 execute DB --env prod --remote --command "select * from app_config"

# prod app-config の初期行だけを冪等に作成する（既に行があれば no-op）
backend-seed-prod:
    cd backend && bunx wrangler d1 execute DB --env prod --remote --command "insert into app_config (id, min_app_version_ios, min_app_version_android, in_maintenance, maintenance_scheduled_end_time, perf_telemetry_enabled, updated_at) values (1, '0.0.0', '0.0.0', 0, null, 1, unixepoch('now') * 1000) on conflict(id) do nothing"

# prod の強制アップデート下限を更新する。更新前後の行を表示し、値の変化を記録に残せるようにする
backend-set-min-app-version-prod ios android:
    #!/usr/bin/env bash
    set -euo pipefail
    cd backend
    echo '--- before ---'
    bunx wrangler d1 execute DB --env prod --remote --command "select min_app_version_ios, min_app_version_android, updated_at from app_config"
    bunx wrangler d1 execute DB --env prod --remote --command "update app_config set min_app_version_ios = '{{ios}}', min_app_version_android = '{{android}}', updated_at = unixepoch('now') * 1000 where id = 1"
    echo '--- after ---'
    bunx wrangler d1 execute DB --env prod --remote --command "select min_app_version_ios, min_app_version_android, updated_at from app_config"

# prod が origin/develop から乖離していないかを検査する（prod へは書き込まない）
backend-drift-check:
    backend/scripts/drift-check.sh

# prod は CI からではなくローカルから deploy する運用のため、
# 「作業ツリーの中身がそのまま prod に出る」事故をここで防ぐ。
# prod deploy の事前条件を検査する（作業ツリー clean / origin/develop と一致 / CI green）
backend-guard-prod:
    #!/usr/bin/env bash
    set -euo pipefail
    if ! git diff --quiet || ! git diff --cached --quiet; then
      echo 'Working tree is dirty. Commit or stash before deploying to prod.' >&2
      exit 1
    fi
    git fetch --quiet origin develop
    head_sha="$(git rev-parse HEAD)"
    if [ "$head_sha" != "$(git rev-parse origin/develop)" ]; then
      echo 'HEAD does not match origin/develop. Deploy prod only from the merged develop.' >&2
      exit 1
    fi
    conclusions="$(gh api "repos/{owner}/{repo}/commits/${head_sha}/check-runs" \
      --jq '.check_runs[] | select(.name == "ci-passed") | .conclusion')"
    if [ -z "$conclusions" ]; then
      echo "No ci-passed check run found for ${head_sha}." >&2
      exit 1
    fi
    if grep -qv '^success$' <<<"$conclusions"; then
      echo "ci-passed is not green for ${head_sha}: ${conclusions}" >&2
      exit 1
    fi
    echo "Guard passed for ${head_sha}."

# migration は意図的に依存に含めない。deploy は wrangler rollback で可逆だが
# migration は forward-only で不可逆であり、さらに正しい順序が migration の性質で反転する
# （additive なら migrate → deploy、destructive なら deploy → migrate）。
# DEPLOYED_SHA は backend-drift-check が「prod に出ている commit」を特定するためのスタンプ。
# guard が HEAD == origin/develop を保証済みなので、この値はそのまま prod の実体を指す。
# prod Worker を手動 deploy する（migration が必要なら backend-migrate-prod* を個別に実行する）
backend-deploy-prod: backend-guard-prod
    cd backend && bunx wrangler deploy --env prod --var DEPLOYED_SHA:"$(git rev-parse HEAD)"

# --- perf（本番テレメトリ D1 の分析。D1 Read のみの CLOUDFLARE_API_TOKEN が必須）---

# 手動調査用の raw SQL。AI 主導線は perf-report を使う
perf-query sql:
    cd backend && bun run scripts/perf-query.ts "{{sql}}"

# AI 用の固定集計 JSON。任意で build_number を渡して絞り込み
perf-report *build_number:
    cd backend && bun run scripts/perf-report.ts {{build_number}}
