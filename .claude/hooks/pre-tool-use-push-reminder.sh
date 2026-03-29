#!/usr/bin/env bash
# PreToolUse hook: git push 実行前にリマインダーを表示
# プロファイル: standard 以上
set -uo pipefail

# jq が利用不可なら静かにスキップ
command -v jq >/dev/null 2>&1 || exit 0

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "${SCRIPT_DIR}/lib/profile-check.sh"
requires_standard || exit 0

input=$(cat)

# Bash ツール以外はスキップ
tool_name=$(echo "$input" | jq -r '.tool_name // empty' 2>/dev/null)
if [[ "$tool_name" != "Bash" ]]; then
  exit 0
fi

# コマンドに git push が含まれるかチェック
command=$(echo "$input" | jq -r '.tool_input.command // empty' 2>/dev/null)
if echo "$command" | grep -q "git push"; then
  echo "[push リマインダー] wf-06 検証は済んでいますか？ コードレビューは完了していますか？"
fi

exit 0
