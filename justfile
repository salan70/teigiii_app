set shell := ["bash", "-euc"]

default:
    just --list

# --- 横断（モバイル + バックエンド）---

# mobile / backend の依存を入れる（flutter clean はしない）
setup: mobile-setup backend-setup

analyze: mobile-analyze backend-analyze

format: mobile-format backend-format

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

mobile-generate:
    cd mobile_app && dart run build_runner build --delete-conflicting-outputs

mobile-analyze:
    cd mobile_app && flutter analyze --no-fatal-infos

mobile-format:
    cd mobile_app && dart format .

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

backend-test:
    cd backend && bun run test

# openapi.json と Drizzle マイグレーション SQL を生成する
backend-generate:
    cd backend && bun run generate:openapi && bun run generate:migrations

backend-dev:
    cd backend && bun run dev

# dev D1 に未適用の migration を反映する
backend-migrate-dev:
    cd backend && bunx wrangler d1 migrations apply DB --env dev --remote

# app-config の初期行だけを冪等に作成する
backend-seed-dev:
    cd backend && bunx wrangler d1 execute DB --env dev --remote --command "insert into app_config (id, min_app_version_ios, min_app_version_android, in_maintenance, maintenance_scheduled_end_time, updated_at) values (1, '0.0.0', '0.0.0', 0, null, unixepoch('now') * 1000) on conflict(id) do nothing"

# migration と app-config 初期化を完了してから dev Worker を手動 deploy する
backend-deploy-dev: backend-migrate-dev backend-seed-dev
    if rg -q 'AVATAR_BASE_URL = "https://api.dev.invalid/v1"' backend/wrangler.toml; then echo 'Replace AVATAR_BASE_URL with the deployed dev Worker URL before deploy.' >&2; exit 1; fi
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

# migration を完了してから prod Worker を手動 deploy する
backend-deploy-prod: backend-migrate-prod
    cd backend && bunx wrangler deploy --env prod
