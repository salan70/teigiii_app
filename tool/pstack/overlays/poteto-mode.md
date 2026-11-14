
## Project overrides (teigiii_app)

This section is appended by `tool/pstack/pstack.py sync` from `tool/pstack/overlays/poteto-mode.md`. Edit that file, not this one. Read `.claude/rules/pstack.md` first. Its rules (paths, models, stack, Git, autonomy, cost) apply to this skill and every playbook. Where this section conflicts with the text above, this section wins.

### Harness

- Pass this file's path, `.claude/skills/poteto-mode/SKILL.md`, in every `poteto-agent` brief. The project agents are `poteto-agent` and `comment-sicko`, without the `pstack:` prefix.
- Only the core pstack skills are installed. If a playbook names a skill that is missing from `.claude/skills/`, skip that step with one line, or add the skill through `tool/pstack/manifest.json` when the user asks.
- Bundled skills live at `.claude/skills/<name>/SKILL.md`. Most set `disable-model-invocation`, so read them directly instead of calling the `Skill` tool.
- Ignore the model defaults in **Subagents**. Use `.claude/rules/pstack-models.md` and the local override that `.claude/rules/pstack.md` describes. An explicit model choice from the user in the session wins.

### Triggers

- Choose the Playbook and Principles that affect this task, then read their leaf skills. Do not turn the upstream triggers into a requirement to read every skill or update every document.
- **architect** runs for a design decision that crosses modules or packages, not for every change that crosses a function boundary.
- **interrogate** runs when the user asks, or when a design stays contested after **how**.
- A small change runs in one agent with no subagent.
- **Broken skill mid-task** means an overlay in `tool/pstack/overlays/`, proposed to the user. Do not open a separate PR for it unasked.

### Playbooks

- **Opening a PR.** The project template `.github/PULL_REQUEST_TEMPLATE.md` replaces `## Why` and the other sections. Write it in Japanese. Commits stay ordered by verifiable unit inside one PR. Run `no-comments` before review.
- **Feature**, **Bug fix**, **Refactoring.** Step 4's delegation is optional for a small change. Read "Rebase into small, ordered commits" as commits ordered by verifiable unit, without rewriting pushed history. Choose checks through the verification table in `mobile_app/AGENTS.md` or `backend/AGENTS.md`.
- **UI work.** Follow the `implementing-ui-with-design-system` skill.
- **Prototype.** Build in the scratchpad, never inside `mobile_app/` or `backend/`.
- **Multi-phase plan**, **Orchestrate**, **Autonomous run**, **Autopilot-stack.** Run only when the user asks. Write the plan in Japanese under `doc/plans/`. Owners never merge. An autonomous run stops after the iteration or time cap the user gives, or asks for one before it starts.
- **Shipping**, **Autopilot-full.** Never run.
- **Babysit.** Ends at merge-ready.
- **Worktree cleanup.** T3 Code manages worktrees under `~/.t3/worktrees/`. List candidates and ask before removing any.
- **Session pickup.** Read the prior T3 thread with `t3_thread_read` or the Claude Code session file, and the `backlog` notes.
- **Pause safely.** Write the resume note with `backlog note`, not to `/tmp`.
- **Eval.** Run only when the user asks.

### Verification

**Prove It Works** means checking the artifact that changed. Choose checks from the verification table in `mobile_app/AGENTS.md` or `backend/AGENTS.md`. For documentation or tooling, check the affected links, commands, and generated output, and run `just docbridge-check` when a spec is involved. Do not require app runs for prose-only changes. List what stayed unverified and do not rerun a check that already passed on the same head.

### Replies

Write replies and reports to the user in Japanese, as `AGENTS.md` and the user's `CLAUDE.md` require. Keep principle and skill names in English. Report Git and GitHub results in every completion report.
