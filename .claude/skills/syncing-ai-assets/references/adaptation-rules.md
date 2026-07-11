# 適応ルール

正本内のハードコード値をプロジェクト固有の値に書き換えるためのルール。

このルールは `syncing-ai-assets` が扱う Claude 用 `.claude/` assets を対象とする。通常実行では `.agents/`、`AGENTS.md`、`.codex/` を作成・上書きしない。Codex 用 assets は `porting-ai-assets-to-codex` で移植要否を判断する。

## 適応対象

### 1. 作業ログパス

| 項目 | 値 |
|---|---|
| 正本の値 | `docs/tasks/ai-logs/YYYY-MM-DD_{slug}.md` |
| 参照元 | コアワークフロースキル |
| 検出ロジック | (1) `docs/tasks/ai-logs/` が存在 → そのまま使用 (2) `ai-logs/` が存在 → `ai-logs/YYYY-MM-DD_{slug}.md` (3) どちらも存在しない → ユーザーに提案（デフォルト: `docs/ai-logs/YYYY-MM-DD_{slug}.md`） |
| 書き換え対象 | ファイルパス文字列の置換 |

### 2. 設計ドキュメントパス

| 項目 | 値 |
|---|---|
| 正本の値 | `docs/specs/` |
| 参照元 | 設計・実装スキル |
| 検出ロジック | (1) `docs/specs/` が存在 → そのまま使用 (2) `specs/`、`spec/`、`docs/design/` 等が存在 → そのパスを使用 (3) 見つからない → ユーザーに提案（デフォルト: `docs/specs/`） |
| 書き換え対象 | ディレクトリパス文字列の置換 |

### 3. タスク管理の参照先

| 項目 | 値 |
|---|---|
| 正本の値 | `docs/tasks/pre-release/index.md` |
| 参照元 | 要件定義、機能、バグ修正スキル |
| 検出ロジック | (1) `docs/tasks/pre-release/index.md` が存在 → そのまま使用 (2) `TODO.md` / `TASKS.md` が存在 → そのファイルを参照先として使用 (3) GitHub Issues を使用中（`.github/` が存在＋ Issue テンプレートあり） → `GitHub Issues` を参照 (4) 見つからない → ユーザーに提案 |
| 書き換え対象 | ファイルパス文字列の置換、参照方法の調整 |

### 4. 検証コマンド

| 項目 | 値 |
|---|---|
| 正本の値 | `nix run .#lint`、`nix run .#format`、`nix run .#test-ts`、`nix run .#test-dart` |
| 参照元 | 検証および共通ワークフロースキル |

**検出の優先順位:**

| 優先度 | ツール | 検出条件 | コマンド例 |
|---|---|---|---|
| 1 | Nix flake | `flake.nix` の `apps` に該当キーあり | `nix run .#lint` |
| 2 | npm / yarn / pnpm / bun | `package.json` の `scripts` に該当キーあり | `npm run lint` |
| 3 | Makefile | `Makefile` に該当ターゲットあり | `make lint` |
| 4 | justfile | `justfile` に該当レシピあり | `just lint` |
| 5 | 個別ツール | `.eslintrc*`、`biome.json`、`pyproject.toml` 等 | `npx eslint .`、`biome check .` |
| 6 | 不明 | 見つからない | ユーザーに確認 |

**コマンド別の検出:**

- **lint**: `lint`、`check`、`typecheck` キーを検索
- **format**: `format`、`fmt` キーを検索
- **test**: `test`、`test:unit`、`test:ts`、`test:dart` 等を検索。複数ある場合はすべて列挙

### 5. シェルポリシーの参照先

| 項目 | 値 |
|---|---|
| 正本の値 | `docs/guides/general/shell-policy.md` |
| 参照元 | 共通ワークフロースキル |
| 検出ロジック | (1) プロジェクトに同名ファイルが存在 → そのパスを使用 (2) 存在しない → 参照リンクを削除（ガードレールのテキストは維持） |
| 書き換え対象 | Markdown リンクの削除またはパスの変更 |

### 6. 正本ソースパス

| 項目 | 値 |
|---|---|
| 正本の値 | `~/Projects/tool/dotfiles/templates/ai-driven-development/.claude/` |
| 参照元 | syncing-ai-assets SKILL.md |
| 検出ロジック | syncing-ai-assets の初回実行時にユーザーに確認。以降は SKILL.md 内の値を使用 |
| 書き換え対象 | SKILL.md 内のパス文字列 |

### 7. ブランチ戦略

| 項目 | 値 |
|---|---|
| 正本の値 | `<!-- BRANCH_STRATEGY_SECTION -->` プレースホルダー + `<!-- ISSUE_BASED_START -->` 〜 `<!-- ISSUE_BASED_END -->` 条件付きブロック |
| 参照元 | git-operations |
| 検出ロジック | ヒアリングで確認（自動検出しない）: (1) **main 直接コミット** → `BRANCH_STRATEGY_SECTION` を最小構成で置換、`ISSUE_BASED_START` 〜 `ISSUE_BASED_END` ブロックを丸ごと削除 (2) **Issue ベース（feature branch 必須）** → `BRANCH_STRATEGY_SECTION` を Issue ベース規則で置換、`ISSUE_BASED_START` / `ISSUE_BASED_END` マーカー行のみ削除しコンテンツを維持 |
| 書き換え対象 | プレースホルダーの置換、条件付きブロックの処理 |

**ヒアリング質問:**

> ブランチ戦略はどちらですか？
>
> 1. **main 直接コミット可** — スピード重視、個人開発向け
> 2. **Issue ベース（feature branch 必須）** — 1 Issue = 1 ブランチ = 1 PR

**BRANCH_STRATEGY_SECTION の置換内容:**

main 直接コミット:

```markdown
## ブランチ戦略

main ブランチへの直接コミットが可能です。feature branch は任意。
```

Issue ベース:

```markdown
## ブランチ戦略

本プロジェクトは **Issue ベース**で開発を進めます。

- **1 Issue = 1 ブランチ = 1 PR** の原則を守る
- すべての作業は Issue を起点として開始する
- Issue なしでの直接コミットは原則禁止
- ブランチ命名: `<type>/<issue-number>-<short-kebab-summary>`
- PR 本文に `closes #<issue-number>` を含めて Issue を自動クローズ
```

## 書き換えルール

### 原則

1. **文字列の置換** — 正本の値をプロジェクト固有の値に単純置換
2. **参照の削除** — プロジェクトに存在しないリソースへのリンクを削除し、周囲の指示テキストは維持
3. **相対パスの維持** — スキル間の相対パス（例: `../git-operations/references/`）は変更しない。ディレクトリ構成はそのままコピーされる
4. **フォールバック** — 検出に失敗した場合は正本の値を維持し、プロジェクトの CLAUDE.md にメモを追記
5. **条件付きブロックの処理** — `<!-- ISSUE_BASED_START -->` 〜 `<!-- ISSUE_BASED_END -->` で囲まれたブロックを、ブランチ戦略に応じて維持（マーカー行のみ削除）または丸ごと削除する

### 書き換え対象外

以下は変更しない:

- スキルの YAML フロントマター（`name`、`description`）
- スキルのワークフロー手順（セクションの順序、判断ロジック）
- スキル間の相対パス参照（ディレクトリ構成が維持される）
- プロジェクト非依存のコンテンツ（承認ゲート、セルフレビューチェックリスト）
