# コントリビューションガイド

本プロジェクトへの貢献を検討いただきありがとうございます。このガイドでは、プロジェクトへの貢献方法について説明します。

## 目次

- [開発環境のセットアップ](#開発環境のセットアップ)
- [開発フロー](#開発フロー)
- [コーディング規約](#コーディング規約)
- [コミット規約](#コミット規約)
- [プルリクエスト](#プルリクエスト)
- [レビュープロセス](#レビュープロセス)

## 開発環境のセットアップ

### 前提条件

- [FVM (Flutter Version Manager)](https://fvm.app/) がインストールされていること
- VS Code（推奨IDE）
- Firebase プロジェクトへのアクセス権限

### セットアップ手順

```bash
# 1. リポジトリをクローン
git clone <repository-url>
cd teigiii_app

# 2. Flutter SDK をセットアップ（FVM経由）
fvm install

# 3. 依存関係をインストール
make setup

# 4. コード生成
make generate

# 5. 開発サーバーを起動
fvm flutter run --dart-define-from-file=dart_defines/dev.json
```

詳細は [開発環境セットアップガイド](./doc/development_setup.md) を参照してください。

## 開発フロー

### 1. Issue の確認・作成

- 新機能やバグ修正を行う前に、関連する Issue があるか確認してください
- 存在しない場合は、作業開始前に Issue を作成してください

### 2. ブランチの作成

`develop` ブランチから新しいブランチを作成します。

```bash
git checkout develop
git pull origin develop
git checkout -b feature/#123_add_user_profile
```

**ブランチ命名規則:**
- 機能追加: `feature/#[Issue番号]_[機能の説明]`
- バグ修正: `fix/#[Issue番号]_[修正の説明]`
- リファクタリング: `refactor/#[Issue番号]_[リファクタの説明]`

### 3. 開発

- [コーディング規約](./doc/coding_guidelines.md) に従って実装
- [アーキテクチャガイド](./doc/architecture.md) に従ってファイルを配置
- 必要に応じてテストを追加

### 4. コミット

Conventional Commits に従ったメッセージを記述します。

```bash
git add .
git commit -m "feat: ユーザープロフィール画面を追加"
```

### 5. プッシュ & プルリクエスト

```bash
git push origin feature/#123_add_user_profile
```

GitHub でプルリクエストを作成し、テンプレートに従って記入してください。

## コーディング規約

### 基本原則

- **可読性**: コードは読みやすく、理解しやすいものにする
- **一貫性**: プロジェクト全体で統一されたスタイルを維持
- **シンプルさ**: 必要以上に複雑にしない

### ファイル構成

```
lib/feature/[feature_name]/
├── presentation/     # UI関連（Widget以外）
├── application/      # 状態管理・ビジネスロジック
├── domain/           # Entity定義
├── repository/       # 外部通信
└── util/             # feature固有のユーティリティ
```

**重要**: Page Widget は `lib/core/page/` に配置します。

### 命名規則

| 種類 | パターン | 例 |
|------|---------|-----|
| Page | `〇〇Page` | `HomePage` |
| Widget | `〇〇{Type}` | `UserTile`, `SubmitButton` |
| Service | `〇〇Service` | `AuthService` |
| Repository | `〇〇Repository` | `UserRepository` |
| Entity | そのまま | `User`, `Definition` |

### インポート

```dart
// プロジェクト内: 相対パス
import '../domain/user.dart';

// プロジェクト外: 絶対パス
import 'package:flutter/material.dart';
```

詳細は [コーディング規約](./doc/coding_guidelines.md) を参照してください。

## コミット規約

### Conventional Commits

```
<type>: <description>

[optional body]

[optional footer]
```

### Type 一覧

| Type | 説明 |
|------|------|
| `feat` | 新機能の追加 |
| `fix` | バグ修正 |
| `refactor` | リファクタリング（機能変更なし） |
| `chore` | 雑務（依存関係更新、設定変更等） |
| `docs` | ドキュメントのみの変更 |
| `test` | テストの追加・修正 |
| `ci` | CI/CD設定の変更 |
| `style` | コードスタイルの変更（フォーマット等） |

### 例

```bash
# 新機能
git commit -m "feat: ユーザーフォロー機能を追加"

# バグ修正
git commit -m "fix: ログイン時のクラッシュを修正"

# リファクタリング
git commit -m "refactor: UserServiceの責務を分離"

# ドキュメント
git commit -m "docs: READMEにセットアップ手順を追加"
```

### VS Code 拡張

[Conventional Commits](https://marketplace.visualstudio.com/items?itemName=vivaxy.vscode-conventional-commits) 拡張の使用を推奨します。

## プルリクエスト

### 作成前のチェックリスト

- [ ] コードが正常にビルドされる（`fvm flutter build`）
- [ ] 静的解析でエラーがない（`fvm flutter analyze`）
- [ ] テストが通過する（`fvm flutter test`）
- [ ] コード生成が最新（`make generate`）
- [ ] 動作確認を実施した

### テンプレート

プルリクエスト作成時は、以下のテンプレートに従って記入してください:

```markdown
# 対象Issue
- #123

# やった事
- ユーザープロフィール画面を実装
- プロフィール編集機能を追加

# やらなかった事
- プロフィール画像のトリミング機能（別Issueで対応予定）

# 動作確認
- iOS シミュレータ (iPhone 15 Pro) で確認
- Android エミュレータ (Pixel 7) で確認

# その他
- 関連するデザインドキュメント: [リンク]
```

### CI チェック

プルリクエストを作成すると、以下が自動実行されます:

1. **静的解析** (`flutter analyze`)
2. **テスト** (`flutter test`)
3. **Danger** による自動レビュー

すべてのチェックが通過するまでマージできません。

## レビュープロセス

### レビュアーへのお願い

- 建設的なフィードバックを心がける
- 「なぜ」そうすべきかを説明する
- 良い点も指摘する

### レビュイーへのお願い

- フィードバックを素直に受け入れる
- 不明点は質問する
- 修正したらコメントで通知する

### マージ条件

- 最低1名のApprove
- すべてのCIチェックが通過
- コンフリクトが解消されている

## 質問・サポート

開発に関する質問は Issue で受け付けています。
