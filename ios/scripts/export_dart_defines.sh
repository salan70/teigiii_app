#!/bin/sh

# This file is sourced by the Runner build phase. Keep these keys aligned with
# dart_defines/{dev,prod}.json so an Xcode GUI build and a Flutter CLI build
# resolve to the same environment.

encode_dart_define() {
  printf '%s' "$1" | /usr/bin/base64 | /usr/bin/tr -d '\n'
}

append_dart_define() {
  encoded_define="$(encode_dart_define "$1")"
  if [ -n "${DART_DEFINES:-}" ]; then
    DART_DEFINES="${DART_DEFINES},${encoded_define}"
  else
    DART_DEFINES="${encoded_define}"
  fi
}

: "${flavor:?Missing flavor build setting}"
: "${appName:?Missing appName build setting}"
: "${apiBaseUrl:?Missing apiBaseUrl build setting}"

append_dart_define "flavor=${flavor}"
append_dart_define "appName=${appName}"
append_dart_define "appIdSuffix=${appIdSuffix:-}"
append_dart_define "apiBaseUrl=${apiBaseUrl}"

export DART_DEFINES
