#!/usr/bin/env bash
# SessionStart hook – inject brainstorming-first rule into Claude Code / Codex

set -euo pipefail

# Determine repo root (two levels up from .claude/hooks/)
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

# Read wf-01-brainstorming skill from local path
brainstorming_content=$(cat "${REPO_ROOT}/.claude/skills/wf-01-brainstorming/SKILL.md" 2>/dev/null || echo "Error reading brainstorming skill")

# Escape string for JSON embedding using bash parameter substitution.
escape_for_json() {
    local s="$1"
    s="${s//\\/\\\\}"
    s="${s//\"/\\\"}"
    s="${s//$'\n'/\\n}"
    s="${s//$'\r'/\\r}"
    s="${s//$'\t'/\\t}"
    printf '%s' "$s"
}

brainstorming_escaped=$(escape_for_json "$brainstorming_content")
session_context="すべてのタスクは wf-01-brainstorming スキルで開始すること。例外はユーザーが「brainstorming 不要」と明示した場合のみ。\\n\\n以下は brainstorming スキルの内容:\\n\\n${brainstorming_escaped}"

# Output context injection as JSON.
# Claude Code expects hookSpecificOutput.additionalContext.
# Codex and other platforms use additional_context.
#
# Uses printf instead of heredoc to work around a bash 5.3+ bug where
# heredoc variable expansion hangs when content exceeds ~512 bytes.
if [ -n "${CLAUDE_PLUGIN_ROOT:-}" ]; then
  # Claude Code
  printf '{\n  "hookSpecificOutput": {\n    "hookEventName": "SessionStart",\n    "additionalContext": "%s"\n  }\n}\n' "$session_context"
else
  # Codex / fallback
  printf '{\n  "additional_context": "%s"\n}\n' "$session_context"
fi

exit 0
