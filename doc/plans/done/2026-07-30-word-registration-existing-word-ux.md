# 言葉登録画面で既存語を事前に知らせ、登録結果を正しく伝える（#306）

## 目的

言葉登録画面で、登録操作の結果をユーザーが誤認しない状態にする。

現状は「既存の公開済み言葉に登録した」場合でも一律「登録しました！」と表示して pop するが、
`words.first_registered_at` は更新されないため「見つける」タイムラインには何も現れない。
**observable な変化がゼロの操作に成功を報告している**のが解くべき問題。

「よみ入力の手間を減らす」ことは目的に含めない（同一性キーが (表記, よみ) である以上、
よみが揃うまで既存判定はできない）。

## 前提

- #305（言葉の同一性を (表記, よみ) に変更）が develop にマージ済み（PR #307, 927b0d8）

## 設計判断

### 事前チェック API を新設する

`GET /v1/words/lookup?word=&reading=` を追加する。

- 判定キーは正規化後の (表記, よみ) の完全一致。正規化はサーバーの `normalizeText` に一本化する
- 判定対象は**閲覧者にとって公開されている言葉のみ**（`publiclyVisibleWordSql`）。
  非公開語の存在を答えると、総当たりで「誰かがこの語について非公開で書いている」事実が漏れる
- レスポンスは `{ "word": WordSummary | null }`。既存語のよみ・定義数は返さない（UI で並べないため）
- **棄却:** `GET /v1/search/words` の流用。部分一致 + ページングのため完全一致の検出を保証できず、
  `normalizeText` のクライアント再実装はサーバーとの乖離を生む
- reading の文字種 regex は lookup では課さない。存在確認の read-only クエリであり、
  マッチしない入力は単に「見つからない」で足りる。長さ上限と空文字拒否のみ `POST /v1/words` と揃える
- 経路は `/words/{id}` より先に登録する（静的セグメント優先を明示するため）

### 登録結果の種別を返す

`POST /v1/words` のレスポンスに `registrationResult` を追加する。

| 値 | 条件 |
| --- | --- |
| `created` | words 行を新規作成した |
| `promoted` | 既存行だが、この登録の**前**は閲覧者にとって公開経路に出ていなかった |
| `alreadyPublic` | 既存行で、この登録の前から公開経路に出ていた |

判定は `#ensureRegistration` の**前**に `publiclyVisibleWordSql` で行う。
201 / 200 の使い分けは #305 の仕様のまま変更しない（`created` のみ 201）。

「閲覧者にとって」の判定はミュートを含む。登録者をミュートしている閲覧者にとっては
その登録によって初めて見えるようになるため、`promoted` が正しい。

### UI

- チップは**よみフィールドの下**に置く。**公開済みの既存語を検出したときだけ表示**する。
  issue では「表記フィールドの上」としていたが、上に置くと確保領域が画面上部の
  一等地を潰すうえ、判定はよみを入力し終えて初めて成立するため、視線の位置と合わない。
  下に置けば確保領域は元から空いている領域に収まる（#306 のレビューで変更）
- チップの有無でレイアウトがずれないよう、非表示でも領域を確保する
- チップはタップ可能 + chevron。タップで言葉ページへ **push**（閉じない。
  閉じると `_close()` の確認ダイアログが毎回挟まる）
- 検出中は AppBar の登録ボタンを disable。よみフィールドは常に有効
- 既存語のよみ・定義数を並べるリスト表示は行わない
- 事後表示は 2 通り。`created` / `promoted` → 「登録しました！」、
  `alreadyPublic` → 既存語である旨 + 言葉ページ導線

### デザインシステム

- `word_registration_page.dart` を Ds へ移行する（`TextFormField` → `DsTextField`、
  AppBar の `InkWell` + `withOpacity` → `DsAppBarAction` 相当）
- チップ相当の Ds コンポーネントが存在しないため `DsChip.navigable` を新規追加する。
  「2 画面以上で同じ見た目」は現時点で満たさないが、タップ領域・セマンティクスの
  アクセシビリティ要件を持つため仕様 4 章の基準を満たす。
  仕様 / Widgetbook use case / widget test / a11y test を同一 PR で追加する

## 実行手順

1. backend: `GET /v1/words/lookup` と `registrationResult` を実装し、worker test を追加
2. backend: `just backend-generate` で `openapi.json` を再生成、`doc/specs/workers-api-server.md` を更新
3. `just generate-api` で Dart クライアントを再生成
4. mobile: `WordRepository.lookupPublicWord` / `create` の戻り値変更、application 層の provider 追加
5. mobile: `DsChip` 追加（component / barrel / 仕様 / Widgetbook / test / a11y）
6. mobile: `word_registration_page.dart` の Ds 移行 + チップ + 事後表示の分岐
7. 検証コマンド一式

## 完了条件

- [x] 表記とよみを入力し、公開済みの同一言葉が存在するとき、登録ボタンを押す前にチップが表示され、登録ボタンが disable になる
- [x] チップをタップすると該当の言葉ページが push され、戻ると入力内容が保持されている
- [x] 非公開の既存語ではチップが出ず、登録すると公開昇格して「登録しました！」が出る
- [x] 競合等で `alreadyPublic` が返った場合、既存語である旨と言葉ページ導線が表示される
- [x] `word_registration_page.dart` に生の `TextFormField` / `InkWell` / `withOpacity` が残っていない
- [x] `just mobile-generate` / `just mobile-analyze` / `just mobile-test` / `just mobile-ds-check` /
      `just mobile-test-golden` / `just test` / `just docbridge-check` が通る
