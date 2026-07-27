#!/usr/bin/env bash
# PostToolUse hook: ファイル編集後に自動フォーマットを実行する（Codex 版）
#
# Codex は編集を apply_patch ツールで行い、tool_input には file_path ではなく
# パッチ本文（command）が入る。そのためパッチから対象パスを抽出する。
# tool_name の実値は codex-cli 0.144.6 の実セッションで確認済み。
#
# 失敗は握り潰さない。フォーマッタを解決できない / 失敗した場合は理由を stderr に
# 出し exit 2 で終える。
set -uo pipefail

# jq が利用不可なら静かにスキップ
command -v jq >/dev/null 2>&1 || exit 0

input=$(cat)

tool_name=$(echo "$input" | jq -r '.tool_name // empty' 2>/dev/null)
[[ "$tool_name" == "apply_patch" ]] || exit 0

# *** Add File: <path> / *** Update File: <path> / *** Move to: <path>
# 削除されたファイルは対象外。1 回の apply_patch が複数ファイルを含みうる。
# 抽出は jq で行う（BSD sed は選択の \| を解釈しないため、macOS の素の
# /usr/bin/sed では GNU 拡張の書き方だと空振りする）。
file_paths=$(
  echo "$input" | jq -r '
    (.tool_input.command // "")
    | [scan("(?m)^\\*\\*\\* (?:Add File|Update File|Move to): (.+)$")]
    | flatten
    | .[]
  ' 2>/dev/null
)
[[ -n "$file_paths" ]] || exit 0

repo_root="$(git rev-parse --show-toplevel 2>/dev/null || true)"
[[ -n "$repo_root" ]] || exit 0

fail() {
  echo "auto-format hook: $1" >&2
  exit 2
}

# hook runner が nix develop 内で動くとは限らないため、PATH でツールを解決できない
# 場合はリポジトリ管理のツールチェーン（flake）経由で起動する。
resolve_nix() {
  if command -v nix >/dev/null 2>&1; then
    echo "nix"
  elif [[ -x /nix/var/nix/profiles/default/bin/nix ]]; then
    echo "/nix/var/nix/profiles/default/bin/nix"
  elif [[ -x "${HOME:-}/.nix-profile/bin/nix" ]]; then
    echo "${HOME}/.nix-profile/bin/nix"
  fi
}

format_dart() {
  local target="$1" output nix_bin
  if command -v dart >/dev/null 2>&1; then
    output=$(dart format "$target" 2>&1) ||
      fail "dart format が失敗しました ($target): $output"
    return
  fi
  nix_bin="$(resolve_nix)"
  [[ -n "$nix_bin" ]] ||
    fail "dart も nix も見つからないため $target をフォーマットできませんでした（nix develop 内で実行してください）"
  output=$(cd "$repo_root" && "$nix_bin" run .#dart -- format "$target" 2>&1) ||
    fail "nix run .#dart -- format が失敗しました ($target): $output"
}

format_ts() {
  local target="$1" output nix_bin
  # backend 配下のみ対象（oxfmt の設定は backend にある）
  [[ "$target" == "$repo_root/backend/"* ]] || return
  if command -v bunx >/dev/null 2>&1; then
    output=$(cd "$repo_root/backend" && bunx oxfmt "$target" 2>&1) ||
      fail "oxfmt が失敗しました ($target): $output"
    return
  fi
  nix_bin="$(resolve_nix)"
  [[ -n "$nix_bin" ]] ||
    fail "bunx も nix も見つからないため $target をフォーマットできませんでした（nix develop 内で実行してください）"
  output=$(cd "$repo_root" && "$nix_bin" develop --command bash -c 'cd backend && bunx oxfmt "$1"' _ "$target" 2>&1) ||
    fail "nix develop 経由の oxfmt が失敗しました ($target): $output"
}

while IFS= read -r file_path; do
  [[ -n "$file_path" ]] || continue

  # 相対パスはリポジトリルート基準の絶対パスに解決する
  if [[ "$file_path" != /* ]]; then
    file_path="$repo_root/$file_path"
  fi
  [[ -f "$file_path" ]] || continue

  case "${file_path##*.}" in
    ts | js | tsx | jsx) format_ts "$file_path" ;;
    dart) format_dart "$file_path" ;;
    *) ;; # 対象外拡張子 → スキップ
  esac
done <<< "$file_paths"

exit 0
