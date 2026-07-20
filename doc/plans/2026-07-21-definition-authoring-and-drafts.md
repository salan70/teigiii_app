# 定義作成・編集と Draft

## 目的

一画面の定義作成を維持しつつ、任意の 1 項目から安全にサーバー保存できる Draft ライフサイクルを提供する。

## 実行手順

1. `definition_drafts` の Drizzle schema と migration を test-first で追加する
2. client-generated UUID を使う冪等 PUT／GET／list／DELETE API の worker test を追加して実装する
3. finalize API の必須検証、既存語解決、よみ競合、冪等性、権限 test を追加して実装する
4. `definitions.status=draft` と関連 OpenAPI／query を専用 Draft モデルへ移す
5. OpenAPI と Dart クライアントを再生成する
6. mobile domain／repository／notifier を test-first で Draft API へ接続する
7. 現行型の一画面フォーム、公開範囲 selector、投稿、明示保存を実装する
8. 離脱・バックグラウンド自動保存、失敗時再試行、空 Draft 削除確認を Widget test する
9. 編集期限は `editableUntil` を正として実装し、期限後の本文複製を廃止する
10. backend/mobile analyze、test、OpenAPI freshness、DocBridge を実行する

## 完了条件

- どれか 1 項目が入力済みなら Draft を保存できる
- 全項目空の新規 Draft を作らず、既存 Draft は確認後に削除する
- finalize の再試行で定義が重複しない
- 新規語は Draft 保存時ではなく定義確定時に共有登録される
- 既存語のよみ不一致だけ確認を要求する
- 単独コミットで検証が通る
