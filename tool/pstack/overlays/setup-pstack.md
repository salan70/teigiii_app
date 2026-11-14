
## Project overrides (teigiii_app)

This section is appended by `tool/pstack/pstack.py sync` from `tool/pstack/overlays/setup-pstack.md`. Edit that file, not this one. It replaces steps 1, 4, 5, and 6 above. Steps 2, 3, 7, and 8 still apply.

### Where the rule lives

The committed rule is `.claude/rules/pstack-models.md`. It holds provider-neutral defaults and changes rarely. Never write `~/.cursor/rules/` or `~/.claude/rules/`. Claude Code loads the project file into every session. Codex and Cursor reach it through `AGENTS.md` and `.cursor/rules/pstack.mdc`.

Day-to-day choices (which provider, cross-provider use, a role pinned to one model) go into the local override, not the committed rule. The override is `pstack-models.local.md` in the git common directory, outside git and shared by every worktree. A SessionStart hook in `.claude/settings.json` adds it to every Claude Code session. Print it with `python3 tool/pstack/pstack.py models show`, and change it with `python3 tool/pstack/pstack.py models set <name> <value>`. When the user asks to change a choice, write the override unless they ask to change the shared default.

### Available models

The main session runs on Claude Code or Codex. By default every role runs on the provider of the model that started the thread.

- Claude: `haiku`, `sonnet`, `opus`, and `fable`.
- Codex: `sol` (`gpt-6.1-sol`), `terra` (`gpt-6.1-terra`), and `luna` (`gpt-6-luna`). The user chose `luna` for the Codex `cheap` tier.

Other models the host lists, such as `gpt-6-astra`, need the user's choice before you assign them.

### Assignment

Write two kinds of lines in the committed rule.

- One tier line per provider, such as `claude: top=fable low, impl=sonnet high, cheap=haiku high`. Keep the same tier names on both providers.
- One line per role with the role labels from step 5 above, naming a tier, such as `bug-fix: impl`. Code work defaults to `impl`, routine fan-out to `cheap`, and judgment and prose to `top`. Panel roles name one tier. They run on the session's provider alone, and put one member on each provider only with `cross-provider: on`.

In the override, a line replaces the committed line with the same name. A role line there may name a model directly (`ui: claude:sonnet medium (settled spec), claude:fable low (open look)`).

### Writing the rule

Write the committed file with no frontmatter. Put the provider notes, a `# budget:` line, the tier lines, and the role lines. The budget sets the effort token of every tier. Keep the project-only `ui` and `small edits` lines. Overwrite the whole file. Tell the user the file changed and that it is part of the PR diff.
