# 開発環境セットアップガイド

本ドキュメントでは、開発環境の構築手順を詳細に説明します。

## 目次

- [必要な環境](#必要な環境)
- [FVM のインストール](#fvm-のインストール)
- [プロジェクトのセットアップ](#プロジェクトのセットアップ)
- [VS Code の設定](#vs-code-の設定)
- [Firebase の設定](#firebase-の設定)
- [環境変数の設定](#環境変数の設定)
- [アプリの実行](#アプリの実行)
- [開発ツール](#開発ツール)

## 必要な環境

### 必須

| ツール | バージョン | 用途 |
|--------|----------|------|
| FVM | 最新版 | Flutter バージョン管理 |
| Flutter | 3.13.6 | フレームワーク（FVM経由） |
| Dart | 3.1.3 | 言語（Flutter に付属） |
| VS Code | 最新版 | IDE |

### オプション（プラットフォーム別）

| プラットフォーム | 必要なツール |
|----------------|-------------|
| iOS | Xcode, CocoaPods |
| Android | Android Studio, Android SDK |
| Web | Chrome |

## FVM のインストール

FVM (Flutter Version Manager) を使用してFlutterバージョンを管理します。

### macOS / Linux

```bash
# Homebrew でインストール（推奨）
brew tap leoafarias/fvm
brew install fvm

# または Dart pub でインストール
dart pub global activate fvm
```

### Windows

```bash
# Chocolatey でインストール
choco install fvm

# または Dart pub でインストール
dart pub global activate fvm
```

### インストール確認

```bash
fvm --version
```

## プロジェクトのセットアップ

### 1. リポジトリのクローン

```bash
git clone <repository-url>
cd teigiii_app
```

### 2. Flutter SDK のインストール

```bash
# プロジェクトで指定されたバージョンをインストール
fvm install

# 使用するバージョンを確認
fvm list
```

### 3. 依存関係のインストール

```bash
# Makefile を使用（推奨）
make setup

# または直接実行
fvm flutter clean
fvm flutter pub get
```

### 4. コード生成

```bash
# Makefile を使用（推奨）
make generate

# または直接実行
fvm flutter packages pub run build_runner build --delete-conflicting-outputs
```

これにより以下が生成されます:
- `*.freezed.dart` - freezed による Entity
- `*.g.dart` - riverpod_generator による Provider
- `*.gr.dart` - auto_route によるルーター
- `*.mocks.dart` - mockito によるモック（テスト用）

## VS Code の設定

### 必須の拡張機能

1. **Flutter** - Flutter開発サポート
2. **Dart** - Dart言語サポート

### 推奨の拡張機能

3. **Conventional Commits** - コミットメッセージ作成支援
4. **Error Lens** - インラインエラー表示
5. **GitLens** - Git履歴の可視化

### プロジェクト設定

`.vscode/settings.json` が既に設定されています:

```json
{
  "dart.flutterSdkPath": ".fvm/flutter_sdk",
  "search.exclude": {
    "**/*.freezed.dart": true,
    "**/*.g.dart": true,
    "**/*.gr.dart": true
  }
}
```

### デバッグ設定

`.vscode/launch.json` で以下の設定が利用可能:

- **Debug dev** - 開発環境でデバッグ実行
- **Debug prod** - 本番環境でデバッグ実行

## Firebase の設定

### Firebase プロジェクトへのアクセス

Firebase コンソールへのアクセス権限が必要です。プロジェクト管理者に連絡してください。

### 設定ファイル

以下のファイルが必要です（リポジトリには含まれません）:

```
lib/util/firebase_options/
├── firebase_options_dev.dart   # 開発環境用
└── firebase_options_prod.dart  # 本番環境用
```

### iOS 固有の設定

```
ios/
├── GoogleService-Info-dev.plist   # 開発環境用
└── GoogleService-Info-prod.plist  # 本番環境用
```

### Android 固有の設定

```
android/app/
├── google-services-dev.json   # 開発環境用
└── google-services-prod.json  # 本番環境用
```

## 環境変数の設定

### .env ファイルの作成

プロジェクトルートに `.env` ファイルを作成:

```bash
# .env ファイルの内容
BANNER_ID_IOS=ca-app-pub-xxxxxxxx/xxxxxxxx
BANNER_ID_ANDROID=ca-app-pub-xxxxxxxx/xxxxxxxx
```

**注意**: `.env` ファイルはGitにコミットしないでください（.gitignore に設定済み）

### Dart Define ファイル

環境別の設定は `dart_defines/` に格納:

```
dart_defines/
├── dev.json   # 開発環境
└── prod.json  # 本番環境
```

## アプリの実行

### 開発環境

```bash
# コマンドライン
fvm flutter run --dart-define-from-file=dart_defines/dev.json

# VS Code
# F5 を押して "Debug dev" を選択
```

### 本番環境

```bash
# コマンドライン
fvm flutter run --dart-define-from-file=dart_defines/prod.json

# VS Code
# F5 を押して "Debug prod" を選択
```

### 特定デバイスでの実行

```bash
# 利用可能なデバイス一覧
fvm flutter devices

# 特定デバイスで実行
fvm flutter run -d <device-id> --dart-define-from-file=dart_defines/dev.json

# 例: iOS シミュレータ
fvm flutter run -d "iPhone 15 Pro" --dart-define-from-file=dart_defines/dev.json

# 例: Chrome
fvm flutter run -d chrome --dart-define-from-file=dart_defines/dev.json
```

## 開発ツール

### Makefile コマンド

| コマンド | 説明 |
|---------|------|
| `make setup` | 依存関係のクリーン & インストール |
| `make generate` | コード生成 |
| `make test` | テスト実行 & カバレッジレポート生成 |

### よく使うコマンド

```bash
# 静的解析
fvm flutter analyze

# テスト実行
fvm flutter test

# 特定のテストファイルを実行
fvm flutter test test/feature/auth/application/auth_service_test.dart

# ビルド（Android）
fvm flutter build apk --dart-define-from-file=dart_defines/prod.json

# ビルド（iOS）
fvm flutter build ios --dart-define-from-file=dart_defines/prod.json
```

### Device Preview

開発時に複数デバイスのプレビューが可能です（`device_preview` パッケージ）。
`main.dart` で有効化されている場合、アプリ内でデバイスを切り替えられます。

## プラットフォーム固有の設定

### iOS

```bash
# CocoaPods のインストール
sudo gem install cocoapods

# Pod の更新
cd ios && pod install && cd ..

# Xcode を開く（必要に応じて）
open ios/Runner.xcworkspace
```

### Android

Android Studio で以下を設定:
1. Android SDK のインストール
2. Android エミュレータの作成
3. 必要な SDK ツールのインストール

```bash
# Android ライセンスの承認
fvm flutter doctor --android-licenses
```

## トラブルシューティング

よくある問題と解決方法については [トラブルシューティングガイド](./troubleshooting.md) を参照してください。

## 確認

セットアップが正しく完了したか確認:

```bash
# Flutter の状態確認
fvm flutter doctor

# プロジェクトのビルド確認
fvm flutter build apk --debug --dart-define-from-file=dart_defines/dev.json

# テストの実行確認
fvm flutter test
```

すべてのチェックが通れば、開発を開始できます。
