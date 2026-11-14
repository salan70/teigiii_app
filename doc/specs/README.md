# 仕様書（doc/specs/）

このディレクトリは仕様書の置き場所であり、[DocBridge](https://github.com/salan70/docbridge) のスキャン対象。個別の仕様はこの索引から辿る。

## 仕様一覧

実装が従うべき仕様。履歴や計画は置かない（履歴は Git と Issue、計画は Issue に書く）。

| 仕様 | いつ読むか |
| --- | --- |
| [mobile-app-design-system.md](mobile-app-design-system.md) | `mobile_app/` の UI を実装・変更する前（Ds コンポーネント / トークンの正本） |
| [workers-api-server.md](workers-api-server.md) | `backend/` の API を追加・変更する前（認証・認可・可視性・状態遷移。HTTP フィールドの正本は `backend/openapi.json`） |
| [new-ui-information-architecture.md](new-ui-information-architecture.md) | 画面の追加・遷移の変更を行う前（画面マップとナビゲーション構造） |
| [analytics-events.md](analytics-events.md) | Analytics イベントを追加・変更する前（イベント名・パラメータ・発火タイミングの正本） |
| [app-performance-telemetry.md](app-performance-telemetry.md) | フレーム計測テレメトリのクライアント側を変更する前（画面遷移境界の対応付け契約・ジャンク判定・送信方針） |


## DocBridge の書き方

- コード側: Dart の doc コメントに `/// @doc doc/specs/<file>.md#<section>` を書く
- 仕様書側: 見出しの直前に `<!-- @code mobile_app/lib/<file>.dart#<canonical-id> -->` を書く
- リンクの検証: `just docbridge-check`

アノテーションの追加、リンクの修正、`related --gate` の所見の確認には `docbridge` スキルを使う。

注意: Freezed は元クラスの doc コメントを生成ファイルへ複製することがある。Freezed クラスに `@doc` を付けたら、重複リンクが出ないか `just docbridge-check` で確認する。
