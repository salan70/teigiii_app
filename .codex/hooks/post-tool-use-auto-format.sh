#!/usr/bin/env bash
# PostToolUse hook: ファイル編集後に自動フォーマットを実行する（Codex 版）
#
# Codex は編集を apply_patch ツールで行い、tool_input には file_path ではなく
# パッチ本文（command）が入る。そのためパッチから対象パスを抽出する。
# tool_name の実値は codex-cli 0.144.6 の実セッションで確認済み。
#
# 失敗は握り潰さない。フォーマッタが見つからない / 失敗した場合は理由を stderr に
# 出し exit 2 で終える。
set -uo pipefail

# jq が利用不可なら静かにスキップ
command -v jq >/dev/null 2>&1 || exit 0

input=$(cat)

tool_name=$(echo "$input" | jq -r '.tool_name // empty' 2>/dev/null)

case "$tool_name" in
  apply_patch)
    # *** Add File: <path> / *** Update File: <path> / *** Move to: <path>
    # 削除されたファイルは対象外。1 回の apply_patch が複数ファイルを含みうる
    file_paths=$(
      echo "$input" | jq -r '.tool_input.command // empty' 2>/dev/null |
        sed -n 's/^\*\*\* \(Add File\|Update File\|Move to\): //p'
    )
    ;;
  Edit | Write)
    file_paths=$(echo "$input" | jq -r '.tool_input.file_path // empty' 2>/dev/null)
    ;;
  *)
    exit 0
    ;;
esac

[[ -n "$file_paths" ]] || exit 0

repo_root="$(git rev-parse --show-toplevel 2>/dev/null || true)"
[[ -n "$repo_root" ]] || exit 0

fail() {
  echo "auto-format hook: $1" >&2
  exit 2
}

while IFS= read -r file_path; do
  [[ -n "$file_path" ]] || continue

  # 相対パスはリポジトリルート基準の絶対パスに解決する
  if [[ "$file_path" != /* ]]; then
    file_path="$repo_root/$file_path"
  fi
  [[ -f "$file_path" ]] || continue

  ext="${file_path##*.}"
  case "$ext" in
    ts | js | tsx | jsx)
      # backend 配下のみ対象（oxfmt の設定は backend にある）
      [[ "$file_path" == "$repo_root/backend/"* ]] || continue
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
done <<< "$file_paths"

exit 0
