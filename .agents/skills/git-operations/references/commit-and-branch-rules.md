# コミットとブランチのルール

## コミットメッセージフォーマット（デフォルト）

```txt
[type]: [説明] [gitmoji]
```

- 説明はデフォルトで日本語で記述する。
- 以下の type と gitmoji の値を使用する。
- プロジェクト規約がある場合はそちらが優先。

### type リファレンス

| type     | 用途                             |
| -------- | -------------------------------- |
| feat     | 新機能                           |
| fix      | バグ修正                         |
| docs     | ドキュメント更新                 |
| style    | フォーマット / 見た目のみの変更  |
| refactor | 内部改善（動作変更なし）         |
| test     | テストの追加・修正               |
| chore    | メンテナンス / 開発ツール        |
| build    | ビルド設定の変更                 |
| ci       | CI 設定の変更                    |

### gitmoji リファレンス

| type     | 推奨 gitmoji         |
| -------- | -------------------- |
| feat     | ✨ `:sparkles:`      |
| fix      | 🐛 `:bug:`           |
| docs     | 📝 `:memo:`          |
| style    | 💄 `:lipstick:`      |
| refactor | ♻️ `:recycle:`       |
| test     | 🧪 `:test_tube:`     |
| chore    | 🔧 `:wrench:`        |
| build    | 📦 `:package:`       |
| ci       | 💚 `:green_heart:`   |

### 例

```txt
feat: Git スキルの初期構成を追加 ✨
fix: ステージング漏れの検知条件を修正 🐛
docs: コメントテンプレートの説明を更新 📝
```

### 禁止パターン

| パターン            | 理由                                                          | 対処                             |
| ------------------- | ------------------------------------------------------------- | -------------------------------- |
| `@` + 英数字        | GitHub がユーザーメンションとして自動リンクし通知が送信される | `@` を除去する（例: `param`）    |

- アノテーションであっても `@` を使用しない。GitHub はコミットメッセージを Markdown としてレンダリングしないため、バッククォートのエスケープでは防げない。
- Issue/PR の本文ではバッククォートで囲むことでメンションリンクを防げる。

## ブランチ命名規則（デフォルト）

### フォーマット

```txt
<type>/<task-id>-<short-kebab-summary>
```

タスク ID がない場合:

```txt
<type>/<yyyymmdd>-<short-kebab-summary>
```

### 例

```txt
feature/137-workers-recipe-import
fix/20260211-precommit-error
docs/20260211-git-skill-guidelines
```
