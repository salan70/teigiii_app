---
name: continuous-learning
description: セッション中の行動パターンを instinct として抽出・蓄積・進化させる学習エンジン
triggers:
  - /learn コマンド
  - Stop フックからのプロンプト
  - 他スキルからの instinct 参照要求
---

# Continuous Learning（Instinct エンジン）

セッション中の成功・失敗パターンを「instinct」として抽出し、`~/.claude/instincts/instincts.json` に蓄積する。

## 使用タイミング

- `/learn` コマンド実行時（手動）
- Stop フックからのプロンプト受信時（自動）
- `/instincts` コマンドで一覧表示時

## 手順

instinct-engine.md の手順に従って実行する。
