# Issue #312 かなの分類・並び順の正本をサーバーに一本化する

## 目的

よみから読みサブグループを算出する規則と、一覧の並び順を backend の正本へ一本化する。mobile は API の `readingSubGroup` とサーバーが返した順序だけを使い、現行の見出しと並びを維持する。

## 実行手順

1. backend worker test と mobile test に、全辞書 DTO が `readingSubGroup` を返すこと、保存一覧を含む一覧がサーバー読み順であること、mobile が API のサブグループと受信順を使うことを固定する回帰テストを追加し、RED を確認する。
2. `DefinedWordItem`、`SavedWordItem`、`UserDictionaryItem` に `readingSubGroup` を追加し、各 SELECT とレスポンス変換を更新する。
3. 保存一覧を reading の文字種クラス、reading、id の keyset pagination に変更し、全辞書一覧の分類・並び順を backend に統一する。
4. OpenAPI と Dart API client を再生成し、`user_dictionary_word_repository.dart` をサーバー値へ切り替える。
5. `buildIndexedList` の再ソートを削除し、サーバーのサブグループ値からセクションヘッダーを導く対応表を残す。
6. reading から分類する mobile ロジックと未参照の文字変換・正規表現を削除し、分類テスト資産を backend test に集約する。
7. `workers-api-server.md` と `new-ui-information-architecture.md` に、分類・並び順の正本がサーバーであることを明記する。
8. 必須検証を通し、plan を `doc/plans/done/` へ移動する。

## 完了条件

- よみから読みサブグループを算出する実装が backend のみに存在する。
- みんなの辞書、自分・他ユーザーの辞書、保存した言葉がサーバー値とサーバー順で同じ見出し・並びを表示する。
- `backend/openapi.json` と Dart API client が更新されている。
- `just backend-analyze`、`just backend-test`、`just backend-generate` が成功する。
- `just mobile-analyze`、`just mobile-test`、`just mobile-generate` が成功する。
- `just docbridge-check` が成功する。

## 作業ログ

- backend worker test で、3 辞書 DTO の `readingSubGroup` 欠落と保存一覧の保存日時順を RED として確認した。実装後は対象 19 test が成功した。
- mobile test で、3 repository が reading から再計算していることと `buildIndexedList` が再ソートしていることを RED として確認した。実装後は対象 10 test と mobile 全 385 test が成功した。
- Flutter にあった全かな・英字・数字・記号の分類ケースを backend の正本テストへ移した。
- `mobile-generate` は成功したが generator 版差による Issue 外の生成差分が出たため、対象 API model 以外は保持しなかった。
- `just backend-analyze`、`just backend-generate`、`just mobile-analyze`、`just mobile-test`、`just mobile-generate`、`just mobile-test-golden`、`just docbridge-check` は成功した。
- `just backend-test` は変更前後とも migration test 13 件だけ失敗する。原因は `backend/drizzle/0003_eminent_klaw.sql` の CHECK 制約がリネーム前テーブル名 `__new_definitions.status` を修飾していることで、修飾を外した非永続の診断実行では全 migration の適用に成功した。Issue #312 の変更とは独立しているため本 plan では変更しない。

## 振り返りと改善提案

API レスポンスだけでなく保存一覧の cursor/order も読み順へ変えなければ、クライアント再ソート削除後の表示順を維持できないことが確認できた。改善提案として、履歴 migration を現行 Bun/SQLite でも適用できるよう CHECK 制約のテーブル修飾を別 Issue で修正し、base branch の `backend-test` を復旧する。
