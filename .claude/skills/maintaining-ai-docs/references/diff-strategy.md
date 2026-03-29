# 最小差分戦略

AI ドキュメントの差分を可能な限り小さく保つための定量基準と例。

## 定量基準

- **変更行数を最小化する**: 変更目的に直接関係する行のみを編集する。
- **影響をローカライズする**: 単一セクション内に収まる変更を優先する。ファイル全体に影響する変更は分割を検討する。
- **無関係な差分はゼロ**: フォーマットの修正、空白の調整、表現の微調整を意図した変更と混ぜない。

## 良い例

### 例 1: トリガーフレーズの追加

目的: ai-doc-maintainer の description にトリガーフレーズを追加する。

```diff
 description: |
   AI operational documents (AGENTS.md / CLAUDE.md / SKILL.md) maintenance with minimal diffs.
-  Use when: (1) creating new AI docs, (2) updating existing rules, (3) resolving cross-file inconsistencies.
+  Use when: (1) creating new AI docs, (2) updating existing rules, (3) resolving cross-file inconsistencies, (4) requests like "update CLAUDE.md" or "fix SKILL.md".
```

変更行数: 1。影響範囲: メタデータの description フィールドのみ。

### 例 2: チェックリスト項目の追加

目的: チェックリストに新しい項目を追加する。

```diff
 ## チェックリスト

 - [ ] ルールに How が含まれている（方針だけでなく）
 - [ ] コマンドが実行可能な形式
+- [ ] 変更目的に無関係な差分がない
 - [ ] 例外処理が明示されている
```

変更行数: 1。影響範囲: チェックリストセクションのみ。

## 悪い例

### 例 1: 無関係なフォーマット変更の混入

目的: description にトリガーフレーズを追加する。

```diff
-description: |
-  AI operational documents (AGENTS.md / CLAUDE.md / SKILL.md) maintenance with minimal diffs.
-  Use when: (1) creating new AI docs, (2) updating existing rules, (3) resolving cross-file inconsistencies.
+description: >-
+  AI operational documents (AGENTS.md / CLAUDE.md / SKILL.md)
+  maintenance with minimal diffs.
+  Use when: (1) creating new AI docs,
+  (2) updating existing rules,
+  (3) resolving cross-file inconsistencies,
+  (4) requests like "update CLAUDE.md" or "fix SKILL.md".
```

問題: YAML のブロックスタイル＋改行位置を変更。8 行変更（1 行で済むはず）。

### 例 2: ついでのリファクタリング

目的: ワークフローに 1 ステップ追加する。

```diff
 ## ワークフロー

-1. 変更目的を一文で確定する。
-2. 既存コンテンツを読み、変更が必要な行だけを特定する。
-3. How を追加する。
+1. **目的確定**: 変更目的を一文で確定する。
+2. **現状把握**: 既存コンテンツを読み、変更が必要な行だけを特定する。
+3. **How 追加**: How を追加する。
+4. **新ステップ**: 新しいステップを実行する。
```

問題: ステップ 1〜3 への見出し追加は目的外。ステップ 4 だけが意図した追加。
