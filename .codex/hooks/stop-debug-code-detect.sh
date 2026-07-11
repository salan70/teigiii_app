#!/usr/bin/env bash
# Stop hook: セッション中に変更されたファイルからデバッグコードを検出
# プロファイル: standard 以上
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "${SCRIPT_DIR}/lib/profile-check.sh"
requires_standard || exit 0

# stdin を消費（使用しない）
cat > /dev/null

# 変更されたファイル一覧を取得
changed_files=$(git diff --name-only HEAD 2>/dev/null || true)
if [[ -z "$changed_files" ]]; then
  exit 0
fi

found=""

while IFS= read -r file; do
  [[ -f "$file" ]] || continue

  ext="${file##*.}"
  patterns=""

  # 注意: macOS の BSD grep は Perl 正規表現（-P, lookbehind）をサポートしない。
  # すべてのパターンは POSIX 拡張正規表現（grep -nE）互換にすること。
  case "$ext" in
    ts|js|tsx|jsx)
      patterns="console\.log|console\.debug|debugger"
      ;;
    dart)
      # テストファイルは debugPrint のみチェック
      if [[ "$file" == *_test.dart || "$file" == *test/* ]]; then
        patterns="debugPrint\("
      else
        # print( は行頭またはスペース/セミコロン後のみマッチ（擬似 word boundary）
        patterns="debugPrint\(|(^|[[:space:];])print\("
      fi
      ;;
    swift)
      if [[ "$file" == *Tests* || "$file" == *Test.swift ]]; then
        patterns="dump\("
      else
        patterns="(^|[[:space:];])print\(|dump\("
      fi
      ;;
  esac

  # 全ファイル共通パターン
  common_patterns="TODO: remove|FIXME: debug|XXX"
  if [[ -n "$patterns" ]]; then
    patterns="${patterns}|${common_patterns}"
  else
    patterns="$common_patterns"
  fi

  matches=$(grep -nE "$patterns" "$file" 2>/dev/null || true)
  if [[ -n "$matches" ]]; then
    while IFS= read -r match; do
      found="${found}  ${file}:${match}\n"
    done <<< "$matches"
  fi
done <<< "$changed_files"

if [[ -n "$found" ]]; then
  printf "[デバッグコード検出] 以下のファイルにデバッグコードが残っています:\n%b" "$found"
fi

exit 0
