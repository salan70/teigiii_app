# mobile_app/CLAUDE.md

Flutter アプリ（teigi_app）の作業ガイド。ルートの `CLAUDE.md` を前提とし、ここには `mobile_app/` 固有の要点のみ書く。

## レイヤー規約（要点）

- feature ファースト。feature 配下を `presentation` / `application` / `domain` / `repository` の 4 層に分ける
- `lib/` 直下は `core` / `feature` / `util`。page を表す Widget は `core/page/`（feature の presentation ではない）
- 依存の向き: presentation → application → repository。presentation から repository を直接 import しない
- domain は Flutter / Riverpod に依存しない（Freezed のみ）

詳細（層ごとの責務、import の可否表、命名規則）は `doc/architecture.md` を参照する。UI を実装・変更する場合はデザインシステム仕様（`doc/specs/mobile-app-design-system.md`）が正本で、手順は `implementing-ui-with-design-system` スキルに従う。

## 検証コマンドの選択規則

| 変更内容 | 実行するコマンド |
| --- | --- |
| 常に | `just mobile-analyze` / `just mobile-test` |
| `.dart` の追加・変更（Freezed / Riverpod / auto_route の生成対象） | `just mobile-generate` |
| UI の変更 | `just mobile-ds-check` |
| 見た目が変わる変更 | `just mobile-test-golden` |
| 仕様（`doc/specs/`）と紐づくコードの変更 | `just docbridge-check` |

実機での確認手順は `doc/ios-physical-device-debug.md` を参照する。
