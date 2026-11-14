# みんなの定義

みんなの定義は、ユーザーが自身の解釈や体験に基づいて言葉の「定義」を投稿し、共有できるアプリです。

言葉の背後にある多様な価値観や感じるニュアンスを共有し、新しい視点や考え方を発見できます。

- [App Store](https://apps.apple.com/jp/app/id6472884411)
- [Google Play](https://play.google.com/store/apps/details?id=com.toda.teigiii)

# リポジトリ構成

モノレポ構成です。ルートは横断の入口で、各プロダクトは次のディレクトリに分かれます。

```text
.
├── mobile_app/   # Flutter アプリ（iOS / Android）
├── backend/      # Cloudflare Workers API
├── doc/          # アーキテクチャと仕様
├── nix/          # 共通開発環境
└── justfile      # ルートからのオーケストレーション
```

# 使用技術

- mobile_app: Flutter 3.41.8（`flake.nix` で固定）、Riverpod、Freezed、auto_route
- backend: Cloudflare Workers、Hono、Drizzle、D1、R2
- Firebase: Authentication、App Check、Analytics、Crashlytics
- CI / CD: GitHub Actions

# 開発環境セットアップ

[Nix](https://nixos.org/download/) と direnv をインストール後、リポジトリで以下を実行します。

```sh
direnv allow
just setup
```

direnv を使わない場合は、先に `nix develop` で開発シェルへ入ってください。

`just setup` は `mobile_app/` と `backend/` の依存関係を導入するだけで、ビルドキャッシュは消しません。消すときは `just mobile-clean` を使います。

# アプリ起動（run）

開発環境

```sh
just mobile-run-dev
```

本番環境

```sh
just mobile-run-prod
```

Xcode GUI から起動する場合は `mobile_app/ios/Runner.xcworkspace` を開き、開発環境は `dev`、本番環境は `prod` Scheme を選択します。Scheme に対応する Build Configuration、Bundle ID、App Icon、Firebase 設定、Dart Define が自動的に選択されるため、Build Settings を手動で変更する必要はありません。

iOS 実機での確認手順は [doc/ios-physical-device-debug.md](doc/ios-physical-device-debug.md) を参照してください。

# 開発方針

- アーキテクチャは [doc/architecture.md](doc/architecture.md)、仕様は [doc/specs/README.md](doc/specs/README.md) にあります
- Issue を起点にし、`develop` ブランチから切ったブランチで作業して、`develop` へ Pull Request を出します
- commit message は `feat`、`fix`、`chore` などの接頭辞で始めます
- Unit Test は、作成が容易な関数と重要度が高い関数に書きます。Widget Test と Integration Test は、ユーザーが増えてから実装します
- 検証コマンド（`just analyze`、`just test` など）、CI、Agent 向けの運用は [AGENTS.md](AGENTS.md) を参照してください
