#!/usr/bin/env bash
# Profile ビルドを作り、実機へ入れて起動する。Mac から切り離してもホーム画面から起動できる。
# 使い方: install-device.sh <dev|prod> [端末名か UDID]
#   端末を省くと環境変数か .env の TEIGIII_DEVICE を使う。一覧は `xcrun devicectl list devices`。
# 署名は ios/Flutter/{Dev,Prod}.xcconfig の手動署名（端末に入るプロファイルを Xcode が持つ前提）。
#   App Store Connect の API キーは使わない。
# 環境変数:
#   SKIP_BUILD=1            前回のビルドを使い、インストールと起動だけをする
#   NO_LAUNCH=1             インストールだけで起動しない
#   APP_CHECK_DEBUG_TOKEN   UUID を指定すると、起動時の FIRAAppCheckDebugToken として渡す
#                           （Profile は kReleaseMode でないため iOS の App Check は debug provider になる）
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
# shellcheck source=/dev/null
source "$root/mobile_app/scripts/load-root-env.sh"

die() {
  echo "エラー: $*" >&2
  exit 1
}

flavor="${1:-}"
case "$flavor" in
  dev | prod) ;;
  *) die "flavor に dev か prod を指定する（例: install-device.sh dev [端末]）" ;;
esac

device_query="${2:-${TEIGIII_DEVICE:-}}"
[[ -n "$device_query" ]] ||
  die "端末が未指定。引数か .env の TEIGIII_DEVICE に端末名か UDID を書く（一覧: xcrun devicectl list devices）"

mobile="$root/mobile_app"
scratch="$(mktemp -d)"
trap 'rm -rf "$scratch"' EXIT

# 端末を解決し、使えない状態なら原因を 1 行で出す。
resolve_device() {
  xcrun devicectl list devices --json-output "$scratch/devices.json" >/dev/null 2>&1 ||
    die "端末の一覧を取得できない。Xcode の Command Line Tools と devicectl を確認する"
  local found
  found="$(jq -c --arg q "$device_query" '
    [.result.devices[]
     | select(.deviceProperties.name == $q or .hardwareProperties.udid == $q or .identifier == $q)]
    | first // empty' "$scratch/devices.json")"
  if [[ -z "$found" ]]; then
    echo "エラー: 端末「${device_query}」が見つからない。ケーブルで接続して「このコンピュータを信頼」を押すか、同じネットワークで Xcode の「ネットワーク経由で接続」を有効にする。" >&2
    echo "認識している端末:" >&2
    jq -r '.result.devices[] | "  \(.deviceProperties.name)  \(.hardwareProperties.udid)"' "$scratch/devices.json" >&2
    exit 1
  fi
  device_id="$(jq -r '.identifier' <<<"$found")"
  device_label="$(jq -r '.deviceProperties.name' <<<"$found")"
  [[ "$(jq -r '.connectionProperties.pairingState // ""' <<<"$found")" == paired ]] ||
    die "端末「${device_label}」がペアリングされていない。ケーブルで接続して「このコンピュータを信頼」を押す"
  [[ "$(jq -r '.deviceProperties.developerModeStatus // ""' <<<"$found")" == enabled ]] ||
    die "端末「${device_label}」の開発者モードが無効。設定 > プライバシーとセキュリティ > 開発者モードを ON にして再起動する"
}

# devicectl の失敗を、原因と対処の 1 行へ言い換える。分からなければ原文を出す。
explain_failure() {
  local log="$1"
  local message
  if grep -qiE 'locked|passcode' "$log"; then
    message="端末がロックされている。ロックを解除して画面を点けたまま再実行する"
  elif grep -qiE 'developer mode' "$log"; then
    message="開発者モードが無効。設定 > プライバシーとセキュリティ > 開発者モードを ON にして再起動する"
  elif grep -qiE 'not (been )?trusted|untrusted|profile.*(not|no).*(valid|trusted)|invalid.*signature' "$log"; then
    message="開発元が信頼されていない。設定 > 一般 > VPN とデバイス管理で開発元を信頼する"
  elif grep -qiE 'provisioning profile|not included|0xe8008015|profile.*(not found|expired)' "$log"; then
    message="署名のプロファイルがこの端末を含まない（または期限切れ）。Apple Developer の端末登録とプロファイルの再生成を確認する（prod は配布用でこの端末に入らない）"
  elif grep -qiE 'unavailable|not connected|no route|timed out|tunnel|could not connect' "$log"; then
    message="端末に接続できない。ケーブルを繋ぎ直すか、同じネットワークで Xcode の「ネットワーク経由で接続」を確認する"
  else
    message=""
  fi
  if [[ -n "$message" ]]; then
    echo "エラー: $message" >&2
    echo "（devicectl の原文）" >&2
    grep -iE 'error|failed|reason|locked|profile' "$log" | head -5 >&2 || true
  else
    cat "$log" >&2
    echo "エラー: 原因を特定できない。上の devicectl の出力を確認する" >&2
  fi
}

run_devicectl() {
  local log="$scratch/devicectl-$1.log"
  shift
  if ! "$@" >"$log" 2>&1; then
    explain_failure "$log"
    exit 1
  fi
  cat "$log"
}

resolve_device
echo "端末: ${device_label}（${device_id}）/ flavor: ${flavor}"

app_candidates=(
  "$mobile/build/ios/iphoneos/Runner.app"
  "$mobile/build/ios/Profile-${flavor}-iphoneos/Runner.app"
)

# flutter build は Xcode の SourcePackages を既定の場所に置かないため、Crashlytics の run が見つからない。
# deliver.yml と同じく、Package.resolved が固定する firebase-ios-sdk のスクリプトを取得して渡す。
prepare_crashlytics_scripts() {
  local resolved="$mobile/ios/Runner.xcworkspace/xcshareddata/swiftpm/Package.resolved"
  local revision dir script
  revision="$(jq -r '.pins[] | select(.identity == "firebase-ios-sdk") | .state.revision' "$resolved")"
  [[ -n "$revision" && "$revision" != null ]] ||
    die "firebase-ios-sdk の revision を $resolved から読めない"
  dir="$mobile/build/crashlytics/$revision"
  if [[ ! -x "$dir/run" || ! -x "$dir/upload-symbols" ]]; then
    mkdir -p "$dir"
    for script in run upload-symbols; do
      curl --fail --location --silent --show-error \
        "https://raw.githubusercontent.com/firebase/firebase-ios-sdk/$revision/Crashlytics/$script" \
        --output "$dir/$script" ||
        die "Crashlytics の ${script} を取得できない。ネットワークを確認する"
      chmod +x "$dir/$script"
    done
  fi
  export CRASHLYTICS_RUN_SCRIPT="$dir/run"
}

if [[ -z "${SKIP_BUILD:-}" ]]; then
  # 古い成果物を入れ直さないよう、先に消す。
  rm -rf "${app_candidates[@]}"
  prepare_crashlytics_scripts
  (cd "$mobile" && flutter build ios --profile --flavor "$flavor" \
    --dart-define-from-file="dart_defines/${flavor}.json")
fi

app=""
for candidate in "${app_candidates[@]}"; do
  if [[ -d "$candidate" ]]; then
    app="$candidate"
    break
  fi
done
[[ -n "$app" ]] || die "ビルド済みの app が無い（${app_candidates[*]}）。SKIP_BUILD を外して作り直す"

bundle_id="$(/usr/bin/plutil -extract CFBundleIdentifier raw "$app/Info.plist")"
echo "bundle ID: ${bundle_id}"

run_devicectl install xcrun devicectl device install app --device "$device_id" "$app"

if [[ -z "${NO_LAUNCH:-}" ]]; then
  token="${APP_CHECK_DEBUG_TOKEN:-}"
  if [[ -n "$token" ]]; then
    [[ "$token" =~ ^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$ ]] ||
      die "APP_CHECK_DEBUG_TOKEN は UUID で指定する"
    export DEVICECTL_CHILD_FIRAAppCheckDebugToken="$token"
  fi
  run_devicectl launch xcrun devicectl device process launch --device "$device_id" \
    --terminate-existing "$bundle_id"
fi

echo "完了: ${bundle_id} を ${device_label} に入れた"
