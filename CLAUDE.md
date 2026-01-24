# CLAUDE.md - AI エージェント向けガイドライン

このドキュメントは、AI エージェントが本プロジェクトを効率的に理解し、開発を支援するためのガイドラインです。

## プロジェクト概要

**みんなの定義** - ユーザーが自身の解釈や体験に基づいて言葉の「定義」を投稿し、共有できる Flutter アプリケーション。

## クイックリファレンス

### 主要コマンド

```bash
# 環境セットアップ
make setup

# コード生成（freezed, riverpod_generator, auto_route）
make generate

# 開発環境で実行
fvm flutter run --dart-define-from-file=dart_defines/dev.json

# 本番環境で実行
fvm flutter run --dart-define-from-file=dart_defines/prod.json

# テスト実行
fvm flutter test

# 静的解析
fvm flutter analyze
```

### 技術スタック

| 技術 | バージョン | 用途 |
|------|----------|------|
| Flutter | 3.13.6 (FVM管理) | フレームワーク |
| Dart | 3.1.3 | 言語 |
| Riverpod | 2.4.3 | 状態管理 |
| auto_route | 7.8.3 | ルーティング |
| Firebase | 各種 | バックエンド |

## アーキテクチャ

### ディレクトリ構造

```
lib/
├── main.dart              # エントリーポイント
├── core/                  # アプリ共通機能
│   ├── page/              # Page Widget（全ての画面）
│   ├── common_widget/     # 汎用UIコンポーネント
│   ├── common_provider/   # 汎用Provider
│   └── router/            # ナビゲーション設定
├── feature/               # 機能別モジュール
│   └── [feature_name]/
│       ├── presentation/  # UI関連（Widget以外）
│       ├── application/   # 状態管理・ビジネスロジック
│       ├── domain/        # Entity定義
│       ├── repository/    # 外部通信（Firebase等）
│       └── util/          # feature固有のユーティリティ
└── util/                  # アプリ全体のユーティリティ
    ├── constant/          # 定数定義
    ├── extension/         # Dart拡張メソッド
    └── ...
```

### 4層アーキテクチャ

| レイヤー | 責務 | Flutter依存 | 主なクラス |
|---------|------|-------------|----------|
| presentation | UI表示・ユーザー操作 | あり | Widget, Controller |
| application | 状態管理・ビジネスロジック | なし | Service, Provider |
| domain | Entity定義・ドメインロジック | なし | Entity (freezed) |
| repository | 外部通信・データ永続化 | なし | Repository |

### 重要な設計原則

1. **Page Widget は `core/page/` に配置** - feature/presentation ではない
2. **依存の方向**: presentation → application → domain ← repository
3. **application層はFlutter非依存**: material/cupertino をインポートしない

## コーディング規約

### 命名規則

| 種類 | 命名パターン | 例 |
|------|------------|-----|
| Page | `〇〇Page` | `HomePage`, `SettingPage` |
| Widget | `〇〇{WidgetType}` | `UserTile`, `SubmitButton` |
| Service | `〇〇Service` | `AuthService`, `UserService` |
| Repository | `〇〇Repository` | `UserRepository` |
| Entity | そのまま | `User`, `Definition` |
| Provider (関数) | `〇〇Provider` | `userProvider` |

### ファイル名

- クラス名をスネークケースに変換: `HomePage` → `home_page.dart`
- Provider関連: `〇〇_provider.dart` または `〇〇_state.dart`

### インポート規則

```dart
// プロジェクト内は相対パスを使用
import '../domain/user.dart';

// プロジェクト外（パッケージ）は絶対パスを使用
import 'package:flutter/material.dart';
```

### コード生成

以下のファイルは自動生成されるため、**直接編集しない**:

- `*.freezed.dart` - freezed による Entity
- `*.g.dart` - riverpod_generator による Provider
- `*.gr.dart` - auto_route によるルーター
- `*.mocks.dart` - mockito によるモック

コード生成が必要な場合:

```bash
make generate
```

## 開発フロー

### ブランチ戦略

- `main` - 本番リリース用
- `develop` - 開発統合ブランチ
- `feature/#〇〇_xxx` - 機能開発（Issue番号 + 内容）

### コミットメッセージ

Conventional Commits を使用:

```
feat: 新機能追加
fix: バグ修正
refactor: リファクタリング
chore: 雑務（依存関係更新等）
docs: ドキュメント更新
test: テスト追加・変更
ci: CI/CD設定変更
```

### テスト

- Unit Test は `作成が容易` または `重要度が高い` 関数に対して記述
- テストファイルは本体と同じディレクトリ構造で `test/` に配置
- モックは mockito を使用

## AI エージェントへの注意事項

### コード変更時の確認事項

1. **`make generate` の必要性確認**
   - Entity（freezed）を変更した場合
   - Provider（riverpod_generator）を追加・変更した場合
   - ルート（auto_route）を追加・変更した場合

2. **テストの実行**
   - 変更したファイルに対応するテストがあれば実行
   - `fvm flutter test` でテスト全体を実行

3. **静的解析**
   - `fvm flutter analyze` でエラーがないことを確認

### よくある作業パターン

#### 新しい機能（feature）を追加する場合

```
lib/feature/[new_feature]/
├── presentation/     # UI（Widget以外）
├── application/      # Service, Provider
├── domain/           # Entity
└── repository/       # 外部通信
```

1. domain/ に Entity を定義（freezed使用）
2. repository/ に Repository を作成
3. application/ に Service/Provider を作成
4. presentation/ に UI コンポーネントを作成
5. core/page/ に Page Widget を追加
6. core/router/ にルートを追加
7. `make generate` を実行

#### 既存機能を修正する場合

1. 該当するfeatureディレクトリを特定
2. レイヤー（presentation/application/domain/repository）を確認
3. 変更を実施
4. 必要に応じて `make generate`
5. テストを実行

### 避けるべきこと

- `*.freezed.dart`, `*.g.dart`, `*.gr.dart` ファイルの直接編集
- application層への Flutter パッケージ（material/cupertino）インポート
- presentation から repository への直接アクセス
- テストなしで重要なビジネスロジックを変更

## ファイル検索のヒント

### 機能を探す場合

```bash
# 特定のfeatureを探す
ls lib/feature/

# Pageを探す
ls lib/core/page/
```

### クラス・関数を探す場合

```bash
# クラス定義を探す
grep -r "class UserService" lib/

# Providerを探す
grep -r "@riverpod" lib/feature/[feature_name]/application/
```

## 関連ドキュメント

- [アーキテクチャ詳細](./doc/architecture.md)
- [コーディング規約](./doc/coding_guidelines.md)
- [開発環境セットアップ](./doc/development_setup.md)
- [トラブルシューティング](./doc/troubleshooting.md)
- [コントリビューションガイド](./CONTRIBUTING.md)

## FAQ

### Q: fvm が見つからない

FVM（Flutter Version Manager）がインストールされていない場合:

```bash
dart pub global activate fvm
```

### Q: コード生成後にエラーが出る

```bash
make setup
make generate
```

### Q: Firebase関連のエラー

- `dart_defines/dev.json` または `dart_defines/prod.json` が存在するか確認
- `.env` ファイルが存在するか確認（AdMob ID等）

### Q: テストが失敗する

```bash
# まず依存関係を更新
make setup

# モックを再生成
make generate

# テスト実行
fvm flutter test
```
