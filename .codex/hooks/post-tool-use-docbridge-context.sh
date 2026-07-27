#!/usr/bin/env bash
# Codex PostToolUse hook: surface the linked counterpart content of the file that
# was just edited, so the agent reconciles the edit with the linked specification
# (or code) before moving on.
#
# PostToolUse, not PreToolUse: a PreToolUse hook's additionalContext arrives next
# to the tool result (after the edit runs), so it cannot enforce
# read-before-editing. Delivering it right after the edit is the honest,
# documented behavior.
#
# Wire it to the apply_patch tool in .codex/hooks.json. Requires bash, git, bun,
# and the DocBridge CLI.
set -euo pipefail

payload="$(cat || true)"

repo_root="$(git rev-parse --show-toplevel)"
cd "$repo_root"

# How to invoke DocBridge. Override with e.g.
#   DOCBRIDGE_CMD="bun run /path/to/docbridge/src/cli/index.ts"
# Intentionally unquoted below so a multi-word command splits into words.
docbridge_cmd=(${DOCBRIDGE_CMD:-bunx docbridge@0.5.2})

# Codex は編集を apply_patch で行い、tool_input には file_path ではなくパッチ本文
# （command）が入る。パッチから対象パスを抽出する（削除されたファイルは対象外）。
# 1 回の apply_patch が複数ファイルを含みうるため、改行区切りで列挙する。
# tool_name の実値は codex-cli 0.144.6 の実セッションで確認済み。
file_paths="$(
  PAYLOAD="$payload" bun -e '
    try {
      const payload = JSON.parse(process.env.PAYLOAD || "{}");
      if (payload.tool_name === "apply_patch") {
        const command = payload.tool_input?.command ?? "";
        const paths = [...command.matchAll(/^\*\*\* (?:Add File|Update File|Move to): (.+)$/gm)]
          .map((m) => m[1].trim());
        console.log(paths.join("\n"));
      } else {
        console.log(payload.tool_input?.file_path ?? "");
      }
    } catch {
      console.log("");
    }
  '
)"
[ -n "$file_paths" ] || exit 0

# Let DocBridge decide whether the file is managed: `docbridge context` resolves
# the path against the project's language-keyed config and reports no context
# blocks for anything it does not manage (handled by the summary-line guard
# below). This keeps the hook language-agnostic instead of hard-coding an
# extension allowlist.
context_all=""
while IFS= read -r file_path; do
  [ -n "$file_path" ] || continue

  context_out="$("${docbridge_cmd[@]}" context "$file_path" 2>/dev/null || true)"

  # The summary line is always printed last; a zero count means the file has no
  # linked counterparts and nothing to inject.
  summary_line="$(printf '%s\n' "$context_out" | tail -n 1)"
  case "$summary_line" in
    *", 0 context blocks") continue ;;
    "") continue ;;
  esac

  context_all="${context_all}
DocBridge: linked counterpart content for ${file_path} (just edited). Reconcile the edit with it; if the change altered documented behavior, update the counterpart too:

${context_out}
"
done <<EOF
$file_paths
EOF

[ -n "$context_all" ] || exit 0

CONTEXT_ALL="$context_all" bun -e '
  console.log(JSON.stringify({
    hookSpecificOutput: {
      hookEventName: "PostToolUse",
      additionalContext: process.env.CONTEXT_ALL,
    },
  }));
'
