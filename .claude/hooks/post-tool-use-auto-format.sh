#!/usr/bin/env bash
# PostToolUse hook: Edit/Write 後に自動フォーマットを実行
# プロファイル: minimal 以上（常に有効）
set -uo pipefail

# jq が利用不可なら静かにスキップ
command -v jq >/dev/null 2>&1 || exit 0

input=$(cat)

# Edit または Write 以外はスキップ
tool_name=$(echo "$input" | jq -r '.tool_name // empty' 2>/dev/null)
if [[ "$tool_name" != "Edit" && "$tool_name" != "Write" ]]; then
  exit 0
fi

# ファイルパスを取得
file_path=$(echo "$input" | jq -r '.tool_input.file_path // empty' 2>/dev/null)
if [[ -z "$file_path" ]]; then
  exit 0
fi

# 拡張子に応じてフォーマッタを選択
ext="${file_path##*.}"
case "$ext" in
  dart)
    fvm dart format "$file_path" 2>&1 || true
    ;;
  *)
    # 対象外拡張子 → スキップ
    ;;
esac

exit 0
