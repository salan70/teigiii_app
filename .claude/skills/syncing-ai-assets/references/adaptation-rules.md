# 適応ルール

正本内のハードコード値をプロジェクト固有の値に書き換えるためのルール。

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
| 正本の値 | `devbox run lint`、`devbox run format`、`devbox run test:ts`、`devbox run test:dart` |
| 参照元 | 検証および共通ワークフロースキル |

**検出の優先順位:**

| 優先度 | ツール | 検出条件 | コマンド例 |
|---|---|---|---|
| 1 | devbox | `devbox.json` の `shell.scripts` に該当キーあり | `devbox run lint` |
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

## 書き換えルール

### 原則

1. **文字列の置換** — 正本の値をプロジェクト固有の値に単純置換
2. **参照の削除** — プロジェクトに存在しないリソースへのリンクを削除し、周囲の指示テキストは維持
3. **相対パスの維持** — スキル間の相対パス（例: `../wf-03-writing-plans/references/`）は変更しない。ディレクトリ構成はそのままコピーされる
4. **フォールバック** — 検出に失敗した場合は正本の値を維持し、プロジェクトの CLAUDE.md にメモを追記

### 書き換え対象外

以下は変更しない:

- スキルの YAML フロントマター（`name`、`description`）
- スキルのワークフロー手順（セクションの順序、判断ロジック）
- スキル間の相対パス参照（ディレクトリ構成が維持される）
- プロジェクト非依存のコンテンツ（承認ゲート、セルフレビューチェックリスト）
