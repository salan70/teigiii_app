# #315: formatter 往復書き換えの解消

## 目的

`just format` と `just mobile-generate` が同じ生成物を別スタイルで書き換え、リポジトリ状態が収束しない問題を解消する。

## 背景

Issue #315 の推奨は B（生成物を `dart format` から除外）+ C（手書き整形）だった。
その後 #320 が別経路で完了条件を満たした:

- C: format drift 解消コミットで手書きソースを整形済み
- generate 末尾に `dart format .` を追加し、生成物も SDK スタイルに揃える
- CI に `mobile-format-check` / backend `format:check` を追加

本 plan では **B には戻さない**。除外すると format-check が生成物の崩れを見逃し、#320 の CI 前提と矛盾する。正本は SDK の `dart format`。`dart_style` 3.x への依存更新（A）は別途。

## 実行手順

1. `just format` → clean rebuild の `just mobile-generate` → `just format` で差分ゼロを確認する
2. 残差があれば取り込み、往復が消えるまで繰り返す
3. `justfile` の format / generate コメントに #315 の方針を明記する（挙動変更なし）
4. `just format-check` が通ることを確認する
5. 本 plan を `doc/plans/done/` へ移し、`closes #315` の PR を出す

## 完了条件

- clean な状態で `just format` → `just mobile-generate`（`.dart_tool/build` 削除後）→ `just format` を通しても git 差分が出ない
- CI に format チェックを入れる判断が明示されている（#320 で追加済み）
- Issue #315 を閉じられる PR がある

## 実行結果

- `just format` は mobile 575 / backend 75 とも 0 changed
- clean rebuild の `just mobile-generate` は build_runner 後に 105 生成物を SDK format で再整形し、最終的にスタイル往復は消える
- 残差は `definition_for_write_notifier.g.dart` の Riverpod create hash 1 行のみ（スタイルではない）。取り込み後、再クリーン生成でも安定
- `just format-check` 成功
- `justfile` コメントに #315 方針（SDK format 正・生成物除外しない・A は後続）を明記
