# みんなの定義

みんなの定義は、ユーザーが自身の解釈や体験に基づいて言葉の「定義」を投稿し、共有することができるアプリです。

言葉の背後にある多様な価値観や感じるニュアンスを共有し、新しい視点や考え方を発見することができます。

TODO: DL用のリンク貼る

# リポジトリ構成

モノレポ構成です。ルートは横断の入口で、各プロダクトは次のディレクトリに分かれます。

```text
.
├── mobile_app/   # Flutter アプリ（iOS / Android）
├── backend/      # Cloudflare Workers API
├── doc/          # プロダクト横断の仕様・計画
├── nix/          # 共通開発環境
└── justfile      # ルートからのオーケストレーション
```

# 開発環境セットアップ

[Nix](https://nixos.org/download/) と direnv をインストール後、リポジトリで以下を実行します。

```sh
direnv allow
just setup
```

direnv を使わない場合は、先に `nix develop` で開発シェルへ入ってください。

`just setup` は `mobile_app/` と `backend/` の両方の依存関係を入れます。

# アプリ起動（run）

開発環境
```sh
just mobile-run-dev
```

本番環境
```sh
just mobile-run-prod
```

Xcode GUIから起動する場合は`mobile_app/ios/Runner.xcworkspace`を開き、開発環境は`dev`、本番環境は`prod` Schemeを選択します。Schemeに対応するBuild Configuration、Bundle ID、App Icon、Firebase設定、Dart Defineが自動的に選択されるため、Build Settingsを手動で変更する必要はありません。

# 使用技術
## Flutter

以下環境を使用しています。

Flutter 3.41.8 を `flake.nix` で固定しています。

また、状態管理はRiverpodを使用しています。

## Firebase

以下を使用しています。

- Authentication
- Firestore Database
- Storage
- Analytics
- Crashlytics

## GitHub Actions

CIの構築に使用しています。  
CIは、Pull Request作成時とPush時に、静的解析とテストの実行が行われるようにしています。

# 開発方針

## アーキテクチャ

[アーキテクチャについて](/doc/architecture.md)
に記載しています。

## GitHub関連

- Issueベースで開発する
- 開発時はdevelopブランチからブランチを切り、developブランチへプルリクエストを出してマージする
- ブランチ名は「feature/#〇〇（対応するIssueの番号）_〇〇（対応内容）」とする
- [VS Codeの拡張](https://marketplace.visualstudio.com/items?itemName=vivaxy.vscode-conventional-commits)を使用するなどして、commit時に「feat」「chore」などの接頭辞をつける

## テスト

- ~~ビジネスロジックに対してUnit Testを原則書く~~
  - ~~書かない場合は、理由や後で書く旨をコメントで残す~~
- ~~プライベート関数に対してはUnit Testを原則書かない~~
  - ~~書く場合は、理由をコメントで残す~~
- Unit Testは、作成が容易そうな関数、重要度が高そうな関数に対して書く
  - 理想は原則UnitTestを書くことだが、ユーザーが増えるまではこの方針で進める
- Widget Test, Integration Testは実装しない
  - ある程度ユーザーが増えたら実装予定
- テストはCIで自動実行する
- 動作確認は適宜行い、プルリクエスト作成時に確認内容や結果を記載する

## その他

- 使用するIDEはVS Codeを前提とする
