#!/usr/bin/env bash
set -euo pipefail

: "${TEIGIII_API_BASE_URL:?Set the deployed dev Worker URL}"
: "${FIREBASE_ID_TOKEN:?Set a valid dev Firebase ID token}"
: "${FIREBASE_APP_CHECK_TOKEN:?Set a valid dev Firebase App Check token}"

api_base="${TEIGIII_API_BASE_URL%/}"
response_file="$(mktemp)"
avatar_file="$(mktemp)"
trap 'rm -f "$response_file" "$avatar_file"' EXIT

request() {
  local expected_status="$1"
  shift
  local actual_status
  actual_status="$(curl --silent --show-error --output "$response_file" --write-out '%{http_code}' "$@")"
  if [ "$actual_status" != "$expected_status" ]; then
    printf 'Expected HTTP %s, got %s\n' "$expected_status" "$actual_status" >&2
    jq . "$response_file" >&2 2>/dev/null || sed -n '1,120p' "$response_file" >&2
    return 1
  fi
}

app_check_header="X-Firebase-AppCheck: $FIREBASE_APP_CHECK_TOKEN"
authorization_header="Authorization: Bearer $FIREBASE_ID_TOKEN"

request 200 \
  --header "$app_check_header" \
  "$api_base/v1/app-config"
jq -e '.minAppVersionIos and .minAppVersionAndroid' "$response_file" >/dev/null

create_status="$(curl --silent --show-error --output "$response_file" --write-out '%{http_code}' \
  --request POST \
  --header "$app_check_header" \
  --header "$authorization_header" \
  --header 'Content-Type: application/json' \
  --data '{"appVersion":"smoke","bio":"","name":"Smoke Test","osVersion":"smoke"}' \
  "$api_base/v1/users")"
if [ "$create_status" != "201" ] && [ "$create_status" != "409" ]; then
  printf 'Expected user create HTTP 201 or 409, got %s\n' "$create_status" >&2
  jq . "$response_file" >&2 2>/dev/null || sed -n '1,120p' "$response_file" >&2
  exit 1
fi

request 200 \
  --request PATCH \
  --header "$app_check_header" \
  --header "$authorization_header" \
  --header 'Content-Type: application/json' \
  --data '{"bio":"dev smoke verified","name":"Smoke Test"}' \
  "$api_base/v1/users/me"

png_base64='iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII='
if ! printf '%s' "$png_base64" | base64 --decode >"$avatar_file" 2>/dev/null; then
  printf '%s' "$png_base64" | base64 -D >"$avatar_file"
fi

request 200 \
  --request PUT \
  --header "$app_check_header" \
  --header "$authorization_header" \
  --header 'Content-Type: image/png' \
  --data-binary "@$avatar_file" \
  "$api_base/v1/users/me/avatar"
avatar_url="$(jq -er '.avatarUrl' "$response_file")"
request 401 "$avatar_url"
curl --fail --silent --show-error \
  --header "$app_check_header" \
  --header "$authorization_header" \
  "$avatar_url" >/dev/null

request 204 \
  --request DELETE \
  --header "$app_check_header" \
  --header "$authorization_header" \
  "$api_base/v1/users/me/avatar"

printf 'dev smoke test passed: app-config, D1 read/write, authenticated routes, private R2 upload/read/delete\n'
