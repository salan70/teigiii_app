
## Project overrides (teigiii_app)

Appended by `tool/pstack/pstack.py sync` from `tool/pstack/overlays/no-comments.md`. The rules in `.claude/rules/pstack.md` apply here.

- The default base branch is `develop`. Use `main` only for a release or hotfix PR.
- Comments in this repository are in Japanese. A constraint comment says in Japanese why the code must stay.
- The suppressions to audit are Dart `// ignore:` and `// ignore_for_file:`, and TypeScript `@ts-ignore` and `@ts-expect-error`.
