# 仕様書（doc/specs/）

このディレクトリは [DocBridge](https://github.com/salan70/docbridge) のスキャン対象となる仕様書の置き場所。

- コード側: Dart の doc コメントに `/// @doc doc/specs/<file>.md#<section>` を書く
- 仕様書側: 見出しの直前に `<!-- @code lib/<file>.dart#<canonical-id> -->` を書く
- リンクの検証: `just docbridge-check`

書き方の支援には `docbridge-annotate` スキル、既存コードとのリンク付けには
`docbridge-link` スキルを使用する。

注意: Freezed は元クラスの doc コメントを生成ファイルへ複製することがあるため、
最初のアノテーション追加時に重複リンクの挙動を検証すること
（詳細: `doc/plans/2026-07-12-docbridge-adoption.md` の将来課題）。
