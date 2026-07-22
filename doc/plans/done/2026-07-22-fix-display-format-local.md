# 投稿日時 UTC 表示の修正 (#249)

## 目的

定義詳細画面の投稿日時が UTC のまま表示されるバグを修正する。絶対時刻の壁時計整形を `toDisplayFormat()` にチョークポイント化し、内部で `toLocal()` する。

## 実行手順

1. `toDisplayFormat` の回帰テストに「UTC 入力 → ローカル表示」ケースを追加し、失敗を確認する（RED）
2. `toDisplayFormat()` 内で `toLocal()` を呼ぶよう修正する（GREEN）
3. `overlay_in_maintenance_dialog.dart` の冗長な `.toLocal()` を整理する
4. 該当テストを通し、PR を作成する（`closes #249`）

## 完了条件

- [x] `toDisplayFormat()` が内部で `toLocal()` を行う
- [x] UTC DateTime を渡すとローカル変換される回帰テストがある
- [x] 定義詳細の投稿日時がローカルタイムゾーンで表示される（上記修正で担保）
- [x] PR が `closes #249` を含む
