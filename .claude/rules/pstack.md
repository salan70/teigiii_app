# pstack in this repository

For a multi-step task, read `.claude/skills/poteto-mode/SKILL.md`, including its project overrides, to choose the relevant Playbook and Principles. Read only the skills needed for the task. Skip it for a pure question answered from context, a fully specified one-line edit, or when the user opts out.

The pstack skills under `.claude/skills/` are vendored verbatim from Cursor's plugin. Only the core ones are installed (see `doc/pstack.md`). The rules below override them wherever they conflict, whether a skill runs through poteto-mode or on its own. `AGENTS.md` and the user's `CLAUDE.md` win over both.

## Paths, tools, and models

- A Cursor path maps to this repository. `.cursor/skills/` and `~/.cursor/skills/` mean `.claude/skills/`. `pstack/skills/` means `.claude/skills/`. `pstack/docs/` means `tool/pstack/upstream/docs/`. In Claude Code, map tool names with `tool/pstack/upstream/docs/harness/claude-code.md`.
- Model choices come from `.claude/rules/pstack-models.md` and the local override, never from `~/.cursor/rules/pstack-models.mdc` or the skill's default slugs. A role names a tier, and the session's provider maps the tier to a model. Claude Code gets the override from a SessionStart hook. Other agents print it with `python3 tool/pstack/pstack.py models show`.
- There are no cloud agents. Run every worker locally. Ignore `environment: "cloud"` and `cloud_base_branch`, and give a worker that needs isolation its own worktree.
- Transcripts are Claude Code session files under `~/.claude/projects/<slug>/` and T3 Code threads (read them with `t3_thread_read`). Read only this project's history.
- Temporary output goes to the session scratchpad directory, not `/tmp`.
- These are not available: Bugbot, Cursor Automations, Origin, Graphite, `poteto-mode/scripts/`, `create-skill`, `deslop`, `control-ui`, `control-cli`, `statechart`, `ketchup`, `typescript-best-practices`, `automate-me`, `make-bot-ui`, and Linear, Notion, Slack, Datadog, Sentry, or Databricks connectors. Skip a step that needs one with one line, or use the replacement below.

| Upstream | Replacement |
| --- | --- |
| `create-skill` | Edit the repo copy directly, following `poteto-mode/playbooks/authoring-a-skill.md` |
| `deslop` | Review your own diff against `principle-laziness-protocol` |
| `control-ui`, `control-cli`, a `verify-<app>` skill | The verification table in `mobile_app/AGENTS.md` or `backend/AGENTS.md` |
| `watch-pr`, `check-plan`, `worktree-audit.sh` | `gh` and the host's PR tools, or a manual check |
| A team tracker | GitHub Issues through `gh`, only when the user asks |

## Stack

This is a monorepo. `mobile_app/` is a Flutter and Dart app (iOS and Android). `backend/` is a TypeScript Cloudflare Workers API. Read other-language examples as their Dart, Flutter, or TypeScript equivalents. SDK versions come from the Nix flake, so run commands through `nix develop -c just <task>` when the shell is not already the flake shell. Prototypes are throwaway scripts in the scratchpad. Code comments and docs are in Japanese.

## Git and PRs

- Feature branches start from `origin/develop` and their PRs target `develop`. Read "trunk" and "main" as `develop` except for release PRs.
- One Issue maps to one PR. Split the work into commits inside it. Stack PRs only when the user asks.
- Never rebase a pushed branch and never force-push. Bring in `develop` with a merge. Never run `git reset --hard` on a branch with work you did not make.
- Commit messages follow `<type>: #<issue> <Japanese summary> <gitmoji>`. The types are `feat` ✨, `fix` 🐛, `docs` 📝, `style` 💄, `refactor` ♻️, `test` 🧪, `chore` 🔧, `build` 📦, and `ci` 💚. PR titles follow `<type>: #<issue> <summary>`. PR bodies use `.github/PULL_REQUEST_TEMPLATE.md` in Japanese and include `closes #<issue>`.
- Stage explicit paths, never `git add .`. Check `git diff --cached --name-only` for secrets (`.env*`, `*.pem`, `*.key`, `service-account*.json`) and unstage real ones.
- Never merge, arm auto-merge, or squash. Merges are merge commits that the user approves for each PR. Shipping and Autopilot-full never run. Never bypass the Git hooks (`lefthook.yml`) with `--no-verify`.

## Autonomy and cost

- Proceed on reversible work. Merges, releases, deploys, store submissions, force pushes, data deletion, and messages or tickets outside this repository need the user's explicit approval. This overrides `principle-never-block-on-the-human`.
- Never write global settings (`~/.cursor`, `~/.claude`, `~/.codex`) or install plugins. A change to a vendored pstack skill goes into `tool/pstack/overlays/` and `tool/pstack/pstack.py sync`, never into the vendored text, and only with the user's approval.
- The user's model quota is limited. A mandatory fan-out, panel, or cross-model review runs at its smallest useful size: one subagent unless the task's risk earns more. A cross-model review runs only when the override sets `cross-provider: on` or the user asks. Do not arm recurring loops unless the user asks.
- Track handoff and pause notes with the `backlog` CLI.

## Context and delegation

Every request resends the whole thread, so cost follows thread length times the number of calls.

- Every spawn names the provider, model, and effort resolved from `pstack-models.md` and the override. A native subagent and a T3 `delegate_task` inherit the parent's model when you omit them.
- A follow-up, fix round, or next step goes to a fresh delegate with consolidated scope, as the poteto-mode Subagents section says. Do not append "continue" to a delegate's finished thread.
- A small change runs in the main agent while the thread is short. In a long thread, or for a run of tweaks, delegate it with the `small edits` line.
- UI work (screens, widgets, the design system) runs through the `ui` line, whatever playbook it falls under, and even when it is small. This line wins over `feature, refactoring`, `bug-fix`, and `small edits`. Its two values split by the work: the first for UI built to a settled spec, the second when the look is still open (a new layout, a visual redesign, proposing variants).
- Keep the main thread short. At a verified boundary (a commit whose check passed), or once the thread is long (about 120k tokens of context, or about 80 tool calls when you cannot see the count), write the resume note with `backlog note` and tell the user in one line to continue in a new thread. Do not stop mid-unit for this.
- When the user asks a side question in a long thread, answer it, then say in one line that a new thread is cheaper for such questions.
- The auto-compact window stays at Claude Code's default. Do not set `autoCompactWindow` in the repository.
