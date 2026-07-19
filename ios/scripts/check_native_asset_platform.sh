#!/bin/bash

set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "Usage: $0 <native-asset-binary> <iphoneos|iphonesimulator>" >&2
  exit 2
fi

binary="$1"
sdk="$2"

if [[ ! -f "$binary" ]]; then
  echo "Native asset binary not found: $binary" >&2
  exit 1
fi

case "$sdk" in
  iphoneos)
    expected_platform=2
    ;;
  iphonesimulator)
    expected_platform=7
    ;;
  *)
    echo "Unsupported SDK: $sdk" >&2
    exit 2
    ;;
esac

actual_platform="$(
  otool -l "$binary" |
    awk '/LC_BUILD_VERSION/ { getline; getline; print $2; exit }'
)"

if [[ "$actual_platform" != "$expected_platform" ]]; then
  echo "Expected Mach-O platform $expected_platform for $sdk, got $actual_platform: $binary" >&2
  exit 1
fi

echo "Native asset platform is valid for $sdk: $binary"
