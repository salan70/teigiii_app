#!/usr/bin/env bash
# PostToolUse hook: Edit/Write 後に自動フォーマットを実行する
#
# 失敗は握り潰さない。フォーマッタが見つからない / 失敗した場合は理由を stderr に
# 出し exit 2 で終える（PostToolUse では exit 2 の stderr のみがエージェントに渡り、
# exit 1 はユーザー表示だけでエージェントが気づけない）。
set -uo pipefail

# jq が利用不可なら静かにスキップ
command -v jq >/dev/null 2>&1 || exit 0

input=$(cat)

# Edit または Write 以外はスキップ
tool_name=$(echo "$input" | jq -r '.tool_name // empty' 2>/dev/null)
if [[ "$tool_name" != "Edit" && "$tool_name" != "Write" ]]; then
  exit 0
fi

file_path=$(echo "$input" | jq -r '.tool_input.file_path // empty' 2>/dev/null)
if [[ -z "$file_path" ]]; then
  exit 0
fi

repo_root="${CLAUDE_PROJECT_DIR:-$(git rev-parse --show-toplevel 2>/dev/null || true)}"
if [[ -z "$repo_root" ]]; then
  exit 0
fi

# 相対パスはリポジトリルート基準の絶対パスに解決する
if [[ "$file_path" != /* ]]; then
  file_path="$repo_root/$file_path"
fi
[[ -f "$file_path" ]] || exit 0

fail() {
  echo "auto-format hook: $1" >&2
  exit 2
}

ext="${file_path##*.}"
case "$ext" in
  ts | js | tsx | jsx)
    # backend 配下のみ対象（oxfmt の設定は backend にある）
    [[ "$file_path" == "$repo_root/backend/"* ]] || exit 0
    command -v bunx >/dev/null 2>&1 || fail "bunx が見つからないため $file_path をフォーマットできませんでした"
    output=$(cd "$repo_root/backend" && bunx oxfmt "$file_path" 2>&1) ||
      fail "oxfmt が失敗しました ($file_path): $output"
    ;;
  dart)
    command -v dart >/dev/null 2>&1 || fail "dart が見つからないため $file_path をフォーマットできませんでした（nix develop 内で実行してください）"
    output=$(dart format "$file_path" 2>&1) ||
      fail "dart format が失敗しました ($file_path): $output"
    ;;
  *)
    # 対象外拡張子 → スキップ
    ;;
esac

exit 0
