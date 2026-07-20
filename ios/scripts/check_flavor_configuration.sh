#!/bin/bash

set -euo pipefail

project_root="$(cd "$(dirname "$0")/../.." && pwd)"
workspace="$project_root/ios/Runner.xcworkspace"
plugin_package="$project_root/ios/Flutter/ephemeral/Packages/FlutterGeneratedPluginSwiftPackage/Package.swift"
framework_package="$project_root/ios/Flutter/ephemeral/Packages/.packages/FlutterFramework/Package.swift"
xcode_project="$project_root/ios/Runner.xcodeproj/project.pbxproj"
deliver_workflow="$project_root/.github/workflows/deliver.yml"

if [[ ! -f "$plugin_package" ]] || ! grep -Fq '.iOS("15.0")' "$plugin_package"; then
  echo "FlutterGeneratedPluginSwiftPackage is not configured for iOS 15.0. Run 'just setup'." >&2
  exit 1
fi

if [[ ! -f "$framework_package" ]] || ! grep -Fq '.iOS("13.0")' "$framework_package"; then
  echo "FlutterFramework must remain compatible with iOS 13 plugins. Run 'just setup'." >&2
  exit 1
fi

if ! grep -Fq 'SourcePackages/checkouts/firebase-ios-sdk/Crashlytics/run' "$xcode_project"; then
  echo "Crashlytics must use the Firebase Swift Package Manager run script." >&2
  exit 1
fi

if grep -Fq 'PODS_ROOT/FirebaseCrashlytics' "$xcode_project"; then
  echo "Crashlytics must not use the CocoaPods upload-symbols path." >&2
  exit 1
fi

if ! grep -Fq -- '-gsp \"$PROJECT_DIR/$flavor/GoogleService-Info.plist\"' "$xcode_project"; then
  echo "Crashlytics must receive the flavor-specific GoogleService-Info.plist." >&2
  exit 1
fi

resolve_packages_line="$(
  grep -nF 'xcodebuild -resolvePackageDependencies -workspace ios/Runner.xcworkspace -scheme prod' \
    "$deliver_workflow" | head -1 | cut -d: -f1 || true
)"
build_ipa_line="$(
  grep -nF 'flutter build ipa --flavor prod' "$deliver_workflow" |
    head -1 |
    cut -d: -f1 || true
)"
if [[ -z "$resolve_packages_line" ]] || [[ -z "$build_ipa_line" ]] ||
  ((resolve_packages_line >= build_ipa_line)); then
  echo "The deliver workflow must resolve iOS Swift packages before building the IPA." >&2
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

assert_plist_value() {
  local file="$1"
  local key="$2"
  local expected="$3"
  local actual

  actual="$(/usr/bin/plutil -extract "$key" raw "$file")"
  if [[ "$actual" != "$expected" ]]; then
    echo "Expected ${file}:${key} = ${expected}, got ${actual}" >&2
    exit 1
  fi
}

assert_dart_ios_option() {
  local file="$1"
  local key="$2"
  local expected="$3"
  local actual

  actual="$(
    sed -n '/static const FirebaseOptions ios = FirebaseOptions(/,/^  );/p' "$file" |
      sed -n "s/^[[:space:]]*${key}: '\([^']*\)',/\1/p"
  )"
  if [[ "$actual" != "$expected" ]]; then
    echo "Expected ${file} iOS ${key} = ${expected}, got ${actual}" >&2
    exit 1
  fi
}

check_flavor() {
  local flavor="$1"
  local bundle_id="$2"
  local profile="$3"
  local project_id="$4"
  local sender_id="$5"
  local firebase_app_id="$6"
  local dart_defines="$project_root/dart_defines/${flavor}.json"
  local firebase_options="$project_root/lib/util/firebase_options/firebase_options_${flavor}.dart"
  local google_service_info="$project_root/ios/${flavor}/GoogleService-Info.plist"
  local app_name
  local app_id_suffix
  local api_base_url
  local api_key
  local storage_bucket

  app_name="$(/usr/bin/plutil -extract appName raw "$dart_defines")"
  app_id_suffix="$(/usr/bin/plutil -extract appIdSuffix raw "$dart_defines")"
  api_base_url="$(/usr/bin/plutil -extract apiBaseUrl raw "$dart_defines")"
  api_key="$(/usr/bin/plutil -extract API_KEY raw "$google_service_info")"
  storage_bucket="$(/usr/bin/plutil -extract STORAGE_BUCKET raw "$google_service_info")"

  assert_plist_value "$google_service_info" BUNDLE_ID "$bundle_id"
  assert_plist_value "$google_service_info" PROJECT_ID "$project_id"
  assert_plist_value "$google_service_info" GCM_SENDER_ID "$sender_id"
  assert_plist_value "$google_service_info" GOOGLE_APP_ID "$firebase_app_id"

  assert_dart_ios_option "$firebase_options" apiKey "$api_key"
  assert_dart_ios_option "$firebase_options" appId "$firebase_app_id"
  assert_dart_ios_option "$firebase_options" messagingSenderId "$sender_id"
  assert_dart_ios_option "$firebase_options" projectId "$project_id"
  assert_dart_ios_option "$firebase_options" storageBucket "$storage_bucket"
  assert_dart_ios_option "$firebase_options" iosBundleId "$bundle_id"

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

check_flavor \
  dev \
  com.toda.teigiii.dev \
  "Teigiii Dev" \
  everyone-teigi-dev \
  225028441501 \
  1:225028441501:ios:370c06ac8f1486b7b5db74
check_flavor \
  prod \
  com.toda.teigiii \
  "Teigiii prod" \
  everyone-teigi-prod \
  713374936833 \
  1:713374936833:ios:245c65657f69da4a927500

echo "iOS flavor configurations are valid."
