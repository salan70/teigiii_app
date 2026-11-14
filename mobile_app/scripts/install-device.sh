#!/usr/bin/env bash
# Profile ビルドを作り、実機へ入れて起動する。Mac から切り離してもホーム画面から起動できる。
# 使い方: install-device.sh <dev|prod> [端末名か UDID]
#   端末を省くと環境変数か .env の TEIGIII_DEVICE を使う。一覧は `xcrun devicectl list devices`。
# 署名は ios/Flutter/{Dev,Prod}.xcconfig の手動署名（端末に入るプロファイルを Xcode が持つ前提）。
#   App Store Connect の API キーは使わない。
# 環境変数:
#   TEIGIII_DEVICE          既定の端末名か UDID（端末名は repo に書かないため .env か環境変数で渡す）
#   SKIP_BUILD=1            前回のビルドを使い、インストールと起動だけをする（APP_CHECK_DEBUG_TOKEN は反映されない）
#   NO_LAUNCH=1             インストールだけで起動しない
#   CONFIRM_PROD=1          prod を入れる確認。prod を直接実行するときに必須（just device-prod は確認後に付ける）
#   APP_CHECK_DEBUG_TOKEN   UUID を指定すると、ビルド時の --dart-define として焼き込む。起動のたびに有効になる
#                           （Profile は kReleaseMode でないため iOS の App Check は debug provider になる）
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
# shellcheck source=/dev/null
source "$root/mobile_app/scripts/load-root-env.sh"

die() {
  echo "エラー: $*" >&2
  exit 1
}

for tool in jq xcrun flutter; do
  command -v "$tool" >/dev/null 2>&1 || die "${tool} が見つからない。開発環境（nix develop など）に入ってから実行する"
done

flavor="${1:-}"
case "$flavor" in
  dev) bundle_id_expected="com.toda.teigiii.dev" ;;
  prod)
    bundle_id_expected="com.toda.teigiii"
    [[ "${CONFIRM_PROD:-}" == 1 ]] ||
      die "prod を入れるには CONFIRM_PROD=1 を付ける（just device-prod は確認後に付ける）"
    ;;
  *) die "flavor に dev か prod を指定する（例: install-device.sh dev [端末]）" ;;
esac

token="${APP_CHECK_DEBUG_TOKEN:-}"
if [[ -n "$token" ]]; then
  [[ "$token" =~ ^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$ ]] ||
    die "APP_CHECK_DEBUG_TOKEN は UUID で指定する"
  [[ "${SKIP_BUILD:-}" != 1 ]] ||
    echo "注意: SKIP_BUILD=1 のため APP_CHECK_DEBUG_TOKEN は反映されない（ビルド時に焼き込むため）" >&2
fi

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
  tunnel_state="$(jq -r '.connectionProperties.tunnelState // ""' <<<"$found")"
  [[ "$(jq -r '.connectionProperties.pairingState // ""' <<<"$found")" == paired ]] ||
    die "端末「${device_label}」がペアリングされていない。ケーブルで接続して「このコンピュータを信頼」を押す"
  [[ "$(jq -r '.deviceProperties.developerModeStatus // ""' <<<"$found")" == enabled ]] ||
    die "端末「${device_label}」の開発者モードが無効。設定 > プライバシーとセキュリティ > 開発者モードを ON にして再起動する"
  # tunnelState が connected でなくても、devicectl の操作で接続が張られることがある。数分かかるビルドの前に 1 回つないで確かめる。
  if [[ "$tunnel_state" != connected ]]; then
    xcrun devicectl device info details --device "$device_id" --timeout 20 >/dev/null 2>&1 || true
    xcrun devicectl list devices --json-output "$scratch/devices.json" >/dev/null 2>&1 || true
    tunnel_state="$(jq -r --arg id "$device_id" '
      [.result.devices[] | select(.identifier == $id)] | first | .connectionProperties.tunnelState // ""' "$scratch/devices.json")"
    [[ "$tunnel_state" == connected ]] ||
      die "端末「${device_label}」に接続できない（tunnelState: ${tunnel_state:-不明}）。ケーブルを繋いでロックを解除するか、同じネットワークで Xcode の「ネットワーク経由で接続」を確認する"
  fi
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

# flavor ごとの出力先だけを見る。flavor 非依存の build/ios/iphoneos は別 flavor の成果物かもしれない。
app="$mobile/build/ios/Profile-${flavor}-iphoneos/Runner.app"

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

if [[ "${SKIP_BUILD:-}" != 1 ]]; then
  # 古い成果物を入れ直さないよう、先に消す。
  rm -rf "$app"
  prepare_crashlytics_scripts
  define_args=(--dart-define-from-file="dart_defines/${flavor}.json")
  [[ -z "$token" ]] || define_args+=(--dart-define="APP_CHECK_DEBUG_TOKEN=${token}")
  (cd "$mobile" && flutter build ios --profile --flavor "$flavor" "${define_args[@]}")
fi

[[ -d "$app" ]] || die "ビルド済みの app が無い（${app}）。SKIP_BUILD を外して作り直す"

bundle_id="$(/usr/bin/plutil -extract CFBundleIdentifier raw "$app/Info.plist")"
echo "bundle ID: ${bundle_id}"
[[ "$bundle_id" == "$bundle_id_expected" ]] ||
  die "bundle ID が ${flavor} の期待値 ${bundle_id_expected} と違う（${bundle_id}）。SKIP_BUILD を外して作り直す"

run_devicectl install xcrun devicectl device install app --device "$device_id" "$app"

if [[ "${NO_LAUNCH:-}" != 1 ]]; then
  run_devicectl launch xcrun devicectl device process launch --device "$device_id" \
    --terminate-existing "$bundle_id"
fi

echo "完了: ${bundle_id} を ${device_label} に入れた"
