# pstack model configuration. Provider-neutral: each role names a tier, and each provider maps tiers to models.
# Provider: the provider of the model that started the thread (Claude Code = claude, Codex = codex). A delegate keeps the provider it was given.
# Use the other provider only when the user says so in the session, or the local override sets `provider` or `cross-provider: on`.
# Local override: `pstack-models.local.md` in the git common directory, outside git and shared by every worktree. A Claude Code SessionStart hook adds it to the context as "Local model override". Other agents print it with `python3 tool/pstack/pstack.py models show`.
# Each line in the override replaces the line with the same name here. Precedence: the user's choice in the session, then the override, then this file.
# A model name without a version (fable, sonnet, sol, ...) means the newest version of that family. In T3 Code, resolve it with `orchestrator_capabilities` (`search` = the family name) once per thread and use the newest id it lists (e.g. `claude-fable-5-2`).
# Spawn a value of the session's own provider natively (Claude Code `Agent`, Codex `spawn_agent`) only when the native alias runs that newest version. Otherwise, or when you cannot tell, use T3 `delegate_task` with the newest id. Reach the other provider through the host's cross-provider delegation (T3 `delegate_task`, `claude-ask run`, or `codex-ask run`).
# When the chosen provider is out of quota, say so in one line and ask before switching to the other provider, unless the override sets `cross-provider: on`.
# Panel roles (arena, architect, interrogate) run on the chosen provider alone. With `cross-provider: on`, they put one member on each provider.
# budget: medium (high)

claude: top=fable low, impl=sonnet high, mid=sonnet medium, cheap=haiku high
codex: top=sol xhigh, impl=sol low, mid=terra medium, cheap=luna high

feature, refactoring: impl
bug-fix: impl
perf-issue: impl
hillclimb: impl
judgment and prose: top
hardest tasks: top
how explorer: cheap
how explainer: top
why investigators: mid
why synthesizer: top
reflect tooling: mid
reflect judgment, divergent, synthesizer: top
arena runners: top
arena cross-judge pool: top
swarm workers: cheap
architect runners: top
interrogate reviewers: top
ui: mid (settled spec), top (open look)
small edits: mid
