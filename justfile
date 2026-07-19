set shell := ["bash", "-euc"]

default:
    just --list

setup:
    flutter clean
    flutter pub get

generate:
    dart run build_runner build --delete-conflicting-outputs

# server/openapi.json から Dart API クライアントを packages/teigiii_api に生成する
generate-api:
    openapi-generator-cli generate -i server/openapi.json -g dart-dio -o packages/teigiii_api \
      --additional-properties=pubName=teigiii_api,serializationLibrary=json_serializable
    cd packages/teigiii_api && dart pub get && dart run build_runner build --delete-conflicting-outputs && dart format .

analyze:
    flutter analyze --no-fatal-infos

format:
    dart format .

test:
    flutter test

docbridge-check:
    bunx docbridge@0.5.2 check

coverage:
    flutter test --coverage
    lcov --remove coverage/lcov.info '*.freezed.dart' '*.g.dart' '*/repository*' -o coverage/lcov.info
    genhtml coverage/lcov.info -o coverage/html

coverage-open: coverage
    open coverage/html/index.html

run-dev:
    flutter run --flavor dev --dart-define-from-file=dart_defines/dev.json

# 指定した端末で dev flavor を起動する（`flutter devices` で端末 ID を確認）
run-dev-on device:
    flutter run -d "{{device}}" --flavor dev --dart-define-from-file=dart_defines/dev.json

run-prod:
    flutter run --flavor prod --dart-define-from-file=dart_defines/prod.json

check-ios-flavors:
    bash ios/scripts/check_flavor_configuration.sh

check-ios-native-asset binary sdk:
    bash ios/scripts/check_native_asset_platform.sh "{{binary}}" "{{sdk}}"

# --- server（Cloudflare Workers API）---

server-setup:
    cd server && bun install

server-lint:
    cd server && bun run lint && bun run typecheck

server-format:
    cd server && bun run format

server-test:
    cd server && bun run test

# openapi.json と Drizzle マイグレーション SQL を生成する
server-generate:
    cd server && bun run generate:openapi && bun run generate:migrations

server-dev:
    cd server && bun run dev

# dev D1 に未適用の migration を反映する
server-migrate-dev:
    cd server && bunx wrangler d1 migrations apply DB --env dev --remote

# app-config の初期行だけを冪等に作成する
server-seed-dev:
    cd server && bunx wrangler d1 execute DB --env dev --remote --command "insert into app_config (id, min_app_version_ios, min_app_version_android, in_maintenance, maintenance_scheduled_end_time, updated_at) values (1, '0.0.0', '0.0.0', 0, null, unixepoch('now') * 1000) on conflict(id) do nothing"

# migration と app-config 初期化を完了してから dev Worker を手動 deploy する
server-deploy-dev: server-migrate-dev server-seed-dev
    if rg -q 'AVATAR_BASE_URL = "https://api.dev.invalid/v1"' server/wrangler.toml; then echo 'Replace AVATAR_BASE_URL with the deployed dev Worker URL before deploy.' >&2; exit 1; fi
    cd server && bunx wrangler deploy --env dev

# 正規の Firebase ID token / App Check token を使って dev Worker を smoke test する
server-smoke-dev:
    server/scripts/smoke-dev.sh

# remote dev bindings に対して Scheduled Handler を手動起動できる状態にする
server-dev-remote-scheduled:
    cd server && bunx wrangler dev --env dev --remote --test-scheduled

# prod は #186 まで deploy せず、bundle と bindings の解決だけを検証する
server-validate-prod:
    cd server && bunx wrangler deploy --env prod --dry-run --outdir /tmp/teigiii-api-prod-dry-run
