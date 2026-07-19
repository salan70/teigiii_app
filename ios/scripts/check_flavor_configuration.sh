#!/bin/bash

set -euo pipefail

project_root="$(cd "$(dirname "$0")/../.." && pwd)"
workspace="$project_root/ios/Runner.xcworkspace"
plugin_package="$project_root/ios/Flutter/ephemeral/Packages/FlutterGeneratedPluginSwiftPackage/Package.swift"
framework_package="$project_root/ios/Flutter/ephemeral/Packages/.packages/FlutterFramework/Package.swift"

if [[ ! -f "$plugin_package" ]] || ! grep -Fq '.iOS("15.0")' "$plugin_package"; then
  echo "FlutterGeneratedPluginSwiftPackage is not configured for iOS 15.0. Run 'just setup'." >&2
  exit 1
fi

if [[ ! -f "$framework_package" ]] || ! grep -Fq '.iOS("13.0")' "$framework_package"; then
  echo "FlutterFramework must remain compatible with iOS 13 plugins. Run 'just setup'." >&2
  exit 1
fi

assert_setting() {
  local settings="$1"
  local key="$2"
  local expected="$3"
  local actual

  actual="$(sed -n "s/^[[:space:]]*${key} = //p" <<<"$settings" | head -1)"
  if [[ "$actual" != "$expected" ]]; then
    echo "Expected ${key} = ${expected}, got ${actual}" >&2
    exit 1
  fi
}

check_flavor() {
  local flavor="$1"
  local bundle_id="$2"
  local profile="$3"
  local dart_defines="$project_root/dart_defines/${flavor}.json"
  local app_name
  local app_id_suffix
  local api_base_url

  app_name="$(/usr/bin/plutil -extract appName raw "$dart_defines")"
  app_id_suffix="$(/usr/bin/plutil -extract appIdSuffix raw "$dart_defines")"
  api_base_url="$(/usr/bin/plutil -extract apiBaseUrl raw "$dart_defines")"

  for mode in Debug Profile Release; do
    local configuration="${mode}-${flavor}"
    local settings
    settings="$(
      xcodebuild \
        -workspace "$workspace" \
        -scheme "$flavor" \
        -configuration "$configuration" \
        -showBuildSettings
    )"

    assert_setting "$settings" flavor "$flavor"
    assert_setting "$settings" appName "$app_name"
    assert_setting "$settings" appIdSuffix "$app_id_suffix"
    assert_setting "$settings" PRODUCT_BUNDLE_IDENTIFIER "$bundle_id"
    assert_setting "$settings" ASSETCATALOG_COMPILER_APPICON_NAME "AppIcon-${flavor}"
    assert_setting "$settings" CODE_SIGN_STYLE Manual
    assert_setting "$settings" PROVISIONING_PROFILE_SPECIFIER "$profile"
    assert_setting "$settings" apiBaseUrl "$api_base_url"
  done
}

check_flavor dev com.toda.teigiii.dev "Teigiii dev"
check_flavor prod com.toda.teigiii "Teigiii prod"

echo "iOS flavor configurations are valid."
