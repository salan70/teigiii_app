set shell := ["bash", "-euc"]

default:
    just --list

setup:
    flutter clean
    flutter pub get

generate:
    dart run build_runner build --delete-conflicting-outputs

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
    flutter run --dart-define-from-file=dart_defines/dev.json

run-prod:
    flutter run --dart-define-from-file=dart_defines/prod.json

# --- server（Cloudflare Workers API）---

server-setup:
    cd server && bun install

server-lint:
    cd server && bun run lint && bun run typecheck

server-format:
    cd server && bun run format

server-test:
    cd server && bun test

# openapi.json と Drizzle マイグレーション SQL を生成する
server-generate:
    cd server && bun run generate:openapi && bun run generate:migrations

server-dev:
    cd server && bun run dev
