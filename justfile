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
