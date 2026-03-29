#!/usr/bin/env bash
# Stop hook: instinct 収集を Claude にプロンプト
# プロファイル: standard 以上
# 注意: このフックは instincts.json を読み書きしない。
#       Claude に収集を促すメッセージを出力するのみ。
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "${SCRIPT_DIR}/lib/profile-check.sh"
requires_standard || exit 0

# stdin を消費（使用しない）
cat > /dev/null

echo "[instinct] セッション終了: /learn を実行して学習パターンを収集してください"

exit 0
