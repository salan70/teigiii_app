#!/usr/bin/env bash
# session-reflect-reminder.sh
# Stop hook: 作業完了報告の直後に session-reflect の実行をリマインドする。
#
# 判定ロジック:
# 1. stop_hook_active == true → exit 0（ループ防止）
# 2. last_assistant_message に「セッション振り返り提案」を含む → exit 0（実行済み）
# 3. last_assistant_message に「作業完了報告」を含む → block + リマインド
# 4. それ以外 → exit 0（通常の応答では発火しない）

set -uo pipefail

# jq が利用不可なら静かにスキップ
command -v jq >/dev/null 2>&1 || exit 0

input=$(cat)

# transcript_suffix から最後のアシスタントメッセージを取得
last_message=$(echo "$input" | jq -r '.transcript_suffix // empty' 2>/dev/null | jq -r '
  [.[] | select(.type == "assistant")] | last | .message // empty
' 2>/dev/null)

# メッセージが取得できない場合はスキップ
if [[ -z "$last_message" ]]; then
  exit 0
fi

# 既に session-reflect 実行済み
if echo "$last_message" | grep -q 'セッション振り返り提案'; then
  exit 0
fi

# 作業完了報告の直後 → リマインド
if echo "$last_message" | grep -q '作業完了報告'; then
  echo "BLOCK: セッション振り返りを実行してください。\`/session-reflect\` または「振り返って」で提案を生成できます。"
  exit 1
fi

# それ以外 → 何もしない
exit 0
