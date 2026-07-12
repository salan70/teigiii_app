#!/usr/bin/env bash
# profile-check.sh — ADD_HOOK_PROFILE による実行制御
# source して requires_standard 関数を使う
#
# ADD_HOOK_PROFILE: minimal | standard (default: standard)
ADD_HOOK_PROFILE="${ADD_HOOK_PROFILE:-standard}"

requires_standard() {
  [[ "$ADD_HOOK_PROFILE" == "standard" ]]
}
