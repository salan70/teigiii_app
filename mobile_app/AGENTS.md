# mobile_app/AGENTS.md

Flutter アプリ（teigi_app）の作業ガイド。ルートの `AGENTS.md` を前提とし、ここには `mobile_app/` 固有の要点のみ書く。

## レイヤー規約

層の責務、依存の向き、import の可否表、命名規則は `doc/architecture.md` が正本。ファイルを追加・移動する前に読む。UI を実装・変更する場合はデザインシステム仕様（`doc/specs/mobile-app-design-system.md`）が正本で、手順は `implementing-ui-with-design-system` スキルに従う。

## 検証コマンドの選択規則

| 変更内容 | 実行するコマンド |
| --- | --- |
| 常に | `just mobile-analyze` / `just mobile-test` |
| `.dart` の追加・変更（Freezed / Riverpod / auto_route の生成対象） | `just mobile-generate` |
| UI の変更 | `just mobile-ds-check` |
| 見た目が変わる変更 | `just mobile-test-golden` |
| 仕様（`doc/specs/`）と紐づくコードの変更 | `just docbridge-check` |

実機での確認手順は `doc/ios-physical-device-debug.md` を参照する。
Cloud VM では Widgetbook の目視確認と golden の生成を実行できない。実行できない場合は未実施であることと、ローカルで必要な確認内容を報告する。
