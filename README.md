# みんなの定義

みんなの定義は、ユーザーが自身の解釈や体験に基づいて言葉の「定義」を投稿し、共有することができるアプリです。

言葉の背後にある多様な価値観や感じるニュアンスを共有し、新しい視点や考え方を発見することができます。

TODO: DL用のリンク貼る

# アプリ起動（run）

開発環境
```sh
flutter run --dart-define-from-file=dart_defines/dev.json
```

本番環境
```sh
flutter run --dart-define-from-file=dart_defines/prod.json
```

# 使用技術
## Flutter

以下環境を使用しています。

```sh
Flutter 3.13.6 • channel stable • https://github.com/flutter/flutter.git
Framework • revision ead455963c (4 days ago) • 2023-09-26 18:28:17 -0700
Engine • revision a794cf2681
Tools • Dart 3.1.3 • DevTools 2.25.0
```
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

## GitHub関連

- Issueベースで開発する
- 開発時はdevelopブランチからブランチを切り、developブランチへプルリクエストを出してマージする
- ブランチ名は「feature/#〇〇（対応するIssueの番号）_〇〇（対応内容）」とする
- [VS Codeの拡張](https://marketplace.visualstudio.com/items?itemName=vivaxy.vscode-conventional-commits)を使用するなどして、commit時に「feat」「chore」などの接頭辞をつける

## テスト

- ビジネスロジックに対してUnit Testを原則書く
  - 書かない場合は、理由や後で書く旨をコメントで残す
- プライベート関数に対してはUnit Testを原則書かない
  - 書かない場合は、理由をコメントで残す
- Widget Test, Integration Testは少なくとも初回リリースまでは実装しない
  - ある程度ユーザーが増えたら実装予定
- テストはCIで自動実行する
- 動作確認は適宜行い、プルリクエスト作成時に確認内容や結果を記載する

## その他

- 使用するIDEはVS Codeを前提とする
- Flutterのバージョン管理に[fvm](https://fvm.app/)を使う
  - 初回リリースまでFlutterバージョンは「3.13.6」を使用する
- UIで表示させる固定のテキストは専用のファイルで管理する（ハードコーディングしない）