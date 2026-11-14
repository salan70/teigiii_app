
## Project overrides (teigiii_app)

Appended by `tool/pstack/pstack.py sync` from `tool/pstack/overlays/swarm.md`. The rules in `.claude/rules/pstack.md` apply here.

- Run every worker locally. Ignore `environment: "cloud"` and `cloud_base_branch`. A worker that edits files gets its own worktree.
- Size N to the coverage the task needs. Start from the smallest partition that covers it.
