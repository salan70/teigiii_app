---
name: wf-05-requesting-code-review
description: タスク完了時、主要機能の実装後、またはマージ前に、作業が要件を満たしているか検証するために使用する
---

# コードレビューの依頼

superpowers:code-reviewer サブエージェントを起動して、問題がカスケードする前に検出する。レビューアーには評価に必要な正確に構成されたコンテキストを渡す — セッション履歴は渡さない。これによりレビューアーは思考プロセスではなく成果物に集中でき、自分自身のコンテキストも継続作業のために確保される。

**基本原則:** レビューは早めに、頻繁に。

## レビューを依頼するタイミング

**必須:**
- サブエージェント駆動開発で各タスク完了後
- 主要機能の完了後
- main へのマージ前

**任意だが有用:**
- 行き詰まったとき（新鮮な視点）
- リファクタリング前（ベースラインチェック）
- 複雑なバグ修正後

## 依頼方法

**1. git SHA を取得:**
```bash
BASE_SHA=$(git rev-parse HEAD~1)  # or origin/main
HEAD_SHA=$(git rev-parse HEAD)
```

**2. code-reviewer サブエージェントを起動:**

Task ツールで superpowers:code-reviewer タイプを使用し、`code-reviewer.md` のテンプレートに記入する

**プレースホルダー:**
- `{WHAT_WAS_IMPLEMENTED}` - 今作ったもの
- `{PLAN_OR_REQUIREMENTS}` - 何をすべきだったか
- `{BASE_SHA}` - 開始コミット
- `{HEAD_SHA}` - 終了コミット
- `{DESCRIPTION}` - 簡潔な概要

**3. フィードバックに対応:**
- Critical の問題は即座に修正
- Important の問題は先に進む前に修正
- Minor の問題は後で対応として記録
- レビューアーが間違っている場合は根拠を示して反論

## 例

```
[タスク 2 完了: 検証関数の追加]

あなた: 先に進む前にコードレビューを依頼しよう。

BASE_SHA=$(git log --oneline | grep "Task 1" | head -1 | awk '{print $1}')
HEAD_SHA=$(git rev-parse HEAD)

[superpowers:code-reviewer サブエージェントを起動]
  WHAT_WAS_IMPLEMENTED: 会話インデックスの検証・修復関数
  PLAN_OR_REQUIREMENTS: docs/superpowers/plans/deployment-plan.md のタスク 2
  BASE_SHA: a7981ec
  HEAD_SHA: 3df7661
  DESCRIPTION: verifyIndex() と repairIndex() を4種類の問題タイプ付きで追加

[サブエージェントの返答]:
  長所: クリーンなアーキテクチャ、実際のテスト
  問題:
    重要: 進捗表示がない
    軽微: 報告間隔のマジックナンバー（100）
  評価: 続行可能

あなた: [進捗表示を修正]
[タスク 3 へ続行]
```

## ワークフローとの統合

**サブエージェント駆動開発:**
- 各タスク後にレビュー
- 問題が積み重なる前に検出
- 次のタスクに進む前に修正

**計画の実行:**
- バッチごとにレビュー（3タスクごと）
- フィードバックを受けて適用、続行

**アドホック開発:**
- マージ前にレビュー
- 行き詰まったときにレビュー

## 禁止事項

**絶対にしないこと:**
- 「シンプルだから」とレビューをスキップ
- Critical の問題を無視
- 未修正の Important 問題を残して先に進む
- 妥当な技術的フィードバックに反論

**レビューアーが間違っている場合:**
- 技術的な根拠で反論
- 動作するコード/テストを示す
- 明確化を求める

テンプレートは wf-05-requesting-code-review/code-reviewer.md を参照。
