# コーディング規約

本ドキュメントでは、プロジェクト全体で一貫したコードを維持するための規約を定義します。

## 目次

- [基本原則](#基本原則)
- [Dart/Flutter スタイルガイド](#dartflutter-スタイルガイド)
- [命名規則](#命名規則)
- [ファイル構成](#ファイル構成)
- [インポート規則](#インポート規則)
- [Riverpod 規約](#riverpod-規約)
- [Widget 設計](#widget-設計)
- [エラーハンドリング](#エラーハンドリング)
- [コメント・ドキュメント](#コメントドキュメント)
- [テスト](#テスト)

## 基本原則

### 可読性優先

- コードは「書く時間」より「読む時間」の方が長い
- 明確で理解しやすいコードを書く
- トリッキーな実装より、シンプルな実装を選ぶ

### 一貫性

- プロジェクト内で統一されたスタイルを維持
- 既存のコードパターンに従う
- 新しいパターンを導入する場合はチームで合意

### YAGNI (You Aren't Gonna Need It)

- 必要になるまで機能を追加しない
- 過度な抽象化を避ける
- シンプルに保つ

## Dart/Flutter スタイルガイド

### フォーマット

- [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style) に従う
- 自動フォーマットを使用: `fvm flutter format .`
- 行の長さ制限: なし（`lines_longer_than_80_chars` は無効化）

### 静的解析

`analysis_options.yaml` で定義されたルールに従う:

```yaml
# 主要な設定
analyzer:
  plugins:
    - custom_lint
  exclude:
    - '**.freezed.dart'
    - '**.g.dart'

linter:
  rules:
    prefer_relative_imports: true
    lines_longer_than_80_chars: false
    sort_pub_dependencies: false
```

### 型の明示

```dart
// Good: 型を明示（特に公開API）
String getUserName(User user) {
  return user.name;
}

// Good: ローカル変数はvarでもOK（型が明らか）
final user = User(name: 'John');
var count = 0;

// Bad: 複雑な型でvarは避ける
var result = someComplexFunction(); // 型が不明瞭
```

### Null Safety

```dart
// Good: null許容型を適切に使用
String? optionalName;
final requiredName = optionalName ?? 'Default';

// Good: late を適切に使用（初期化が保証される場合）
late final UserService userService;

// Bad: 不必要な!演算子
final name = user.name!; // nullでないことが保証されているならnon-nullable型に
```

## 命名規則

### クラス名

| 種類 | パターン | 例 |
|------|---------|-----|
| Page | `〇〇Page` | `HomePage`, `SettingPage`, `UserProfilePage` |
| Widget (汎用) | `〇〇{WidgetType}` | `UserTile`, `SubmitButton`, `LoadingIndicator` |
| Widget (困ったら) | `〇〇Widget` | `ProfileHeaderWidget` |
| Service | `〇〇Service` | `AuthService`, `UserService` |
| Repository | `〇〇Repository` | `UserRepository`, `DefinitionRepository` |
| Entity | ドメイン名そのまま | `User`, `Definition`, `Word` |
| Controller | `〇〇Controller` | `FormController`, `AnimationController` |

### ファイル名

```
# クラス名をスネークケースに変換
HomePage       -> home_page.dart
UserTile       -> user_tile.dart
AuthService    -> auth_service.dart
UserRepository -> user_repository.dart

# Provider関連
〇〇Provider   -> 〇〇_provider.dart または 〇〇_state.dart
```

### 変数・関数名

```dart
// Good: 明確な名前
final isLoading = true;
final userList = <User>[];
Future<void> fetchUserProfile() async { ... }

// Bad: 略語や不明瞭な名前
final ld = true;      // 何の略？
final ul = <User>[]; // 意味不明
Future<void> fup() async { ... }
```

### Provider名

```dart
// Good: riverpod_generator を使用
@riverpod
Future<User> currentUser(CurrentUserRef ref) async { ... }
// 生成される Provider名: currentUserProvider

// 関数ベースの Provider
@Riverpod(keepAlive: true)
Stream<User?> userChanges(UserChangesRef ref) => ...;
```

### 定数

```dart
// Good: lowerCamelCase
const defaultPadding = 16.0;
const maxRetryCount = 3;

// Good: クラス内の定数
class AppConstants {
  static const defaultTimeout = Duration(seconds: 30);
}
```

## ファイル構成

### ディレクトリ構造

```
lib/
├── main.dart
├── core/
│   ├── page/              # 全てのPage Widget
│   ├── common_widget/     # 汎用Widget
│   │   ├── button/
│   │   └── dialog/
│   ├── common_provider/   # 汎用Provider
│   └── router/            # ルーティング設定
├── feature/
│   └── [feature_name]/
│       ├── presentation/  # UI（Widget以外）
│       ├── application/   # Service, Provider
│       ├── domain/        # Entity
│       ├── repository/    # 外部通信
│       └── util/          # feature固有util
└── util/
    ├── constant/
    ├── extension/
    ├── exception/
    └── ...
```

### ファイル配置ルール

| ファイル種類 | 配置場所 |
|------------|---------|
| Page Widget | `core/page/` |
| 汎用Widget | `core/common_widget/` |
| feature固有Widget | `feature/[name]/presentation/` |
| Service | `feature/[name]/application/` |
| Provider | `feature/[name]/application/` |
| Entity | `feature/[name]/domain/` |
| Repository | `feature/[name]/repository/` |
| 拡張メソッド | `util/extension/` |
| 定数 | `util/constant/` |

## インポート規則

### 相対パス vs 絶対パス

```dart
// プロジェクト内: 相対パスを使用
import '../domain/user.dart';
import '../../common_widget/button/submit_button.dart';

// プロジェクト外（パッケージ）: 絶対パスを使用
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
```

### インポート順序

```dart
// 1. Dart SDK
import 'dart:async';
import 'dart:io';

// 2. Flutter
import 'package:flutter/material.dart';

// 3. 外部パッケージ
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';

// 4. プロジェクト内（絶対パス）
import 'package:teigiii_app/util/logger.dart';

// 5. プロジェクト内（相対パス）
import '../domain/user.dart';
import './user_tile.dart';
```

### レイヤー間のインポート制限

| From / To | presentation | application | domain | repository |
|-----------|--------------|-------------|--------|------------|
| presentation | OK | OK | OK | **NG** |
| application | NG | OK | OK | OK |
| domain | NG | NG | OK | NG |
| repository | NG | NG | OK | NG |

**重要**: presentation から repository への直接アクセスは禁止

## Riverpod 規約

### Provider 定義

```dart
// Good: riverpod_generator を使用
@riverpod
class UserNotifier extends _$UserNotifier {
  @override
  Future<User> build() async {
    return _fetchUser();
  }
}

// Good: シンプルな Provider
@riverpod
Future<List<Definition>> definitions(DefinitionsRef ref) async {
  final repo = ref.watch(definitionRepositoryProvider);
  return repo.fetchAll();
}

// Good: keepAlive が必要な場合
@Riverpod(keepAlive: true)
Stream<User?> authState(AuthStateRef ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
}
```

### Provider 使用

```dart
// Widget内での使用
class UserProfilePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // watch: 値の変更を監視
    final userAsync = ref.watch(userProvider);

    // read: 一度だけ読み取り（コールバック内で使用）
    onPressed: () {
      ref.read(userNotifierProvider.notifier).updateUser();
    }

    return userAsync.when(
      data: (user) => UserProfile(user: user),
      loading: () => const LoadingIndicator(),
      error: (e, st) => ErrorWidget(error: e),
    );
  }
}
```

### AsyncValue のハンドリング

```dart
// Good: when を使用
userAsync.when(
  data: (user) => Text(user.name),
  loading: () => const CircularProgressIndicator(),
  error: (error, stack) => Text('Error: $error'),
);

// Good: maybeWhen でデフォルト指定
userAsync.maybeWhen(
  data: (user) => Text(user.name),
  orElse: () => const SizedBox.shrink(),
);
```

## Widget 設計

### StatelessWidget vs ConsumerWidget

```dart
// 状態を使用しない場合: StatelessWidget
class UserAvatar extends StatelessWidget {
  const UserAvatar({super.key, required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) { ... }
}

// Provider を使用する場合: ConsumerWidget
class UserProfile extends ConsumerWidget {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) { ... }
}
```

### Widget の分割

```dart
// Good: 小さく分割
class UserListPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const _AppBar(),
      body: const _UserList(),
    );
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar();
  // ...
}

class _UserList extends ConsumerWidget {
  const _UserList();
  // ...
}
```

### const の活用

```dart
// Good: 可能な限り const を使用
const padding = EdgeInsets.all(16);
const Text('Hello');
const SizedBox(height: 8);

// Widget も const constructor を定義
class UserCard extends StatelessWidget {
  const UserCard({super.key, required this.user});
  // ...
}
```

## エラーハンドリング

### Repository層

```dart
// Repository: 例外をスロー
class UserRepository {
  Future<User> fetchUser(String id) async {
    try {
      final doc = await _firestore.collection('users').doc(id).get();
      if (!doc.exists) {
        throw UserNotFoundException(id);
      }
      return User.fromJson(doc.data()!);
    } on FirebaseException catch (e) {
      throw RepositoryException('Failed to fetch user', e);
    }
  }
}
```

### Application層

```dart
// Service: 例外をハンドリングまたは再スロー
class UserService {
  Future<Result<User>> getUser(String id) async {
    try {
      final user = await _repository.fetchUser(id);
      return Result.success(user);
    } on UserNotFoundException {
      return Result.failure(UserError.notFound);
    } on RepositoryException catch (e) {
      logger.e('Failed to get user', error: e);
      return Result.failure(UserError.unknown);
    }
  }
}
```

### Presentation層

```dart
// Widget: ユーザーに適切なフィードバック
userAsync.when(
  data: (user) => UserProfile(user: user),
  loading: () => const LoadingIndicator(),
  error: (error, stack) {
    // エラーログ（開発時のみ）
    logger.e('User load error', error: error, stackTrace: stack);
    // ユーザーフレンドリーなメッセージ
    return const ErrorMessage('ユーザー情報を取得できませんでした');
  },
);
```

## コメント・ドキュメント

### いつコメントを書くか

```dart
// Good: なぜそうするかを説明
// Firebase の制限により、1回のクエリで取得できるのは最大500件
const maxBatchSize = 500;

// Good: 複雑なロジックの説明
// ユーザーのタイムゾーンに基づいて日付を変換
// Firebase は UTC で保存されているため
final localDate = utcDate.toLocal();

// Bad: 何をしているかの説明（コードを見ればわかる）
// ユーザーを取得
final user = await fetchUser();
```

### Doc コメント

```dart
/// ユーザーの認証状態を管理するサービス
///
/// Firebase Authentication を使用してユーザーの認証を行う。
/// 匿名認証、メール認証、ソーシャル認証に対応。
class AuthService {
  /// 匿名ユーザーとしてサインインする
  ///
  /// 既にサインインしている場合は何もしない。
  ///
  /// Throws:
  /// - [AuthException] 認証に失敗した場合
  Future<void> signInAnonymously() async { ... }
}
```

### TODO コメント

```dart
// TODO: Issue#123 でリファクタリング予定
// TODO(username): 期限2024-01-01 までに対応
```

## テスト

### テスト方針

- **重要度が高い**、または**作成が容易**な関数に対してテストを書く
- プライベート関数は原則テストしない
- Widget Test, Integration Test は将来的に追加予定

### テストファイル配置

```
test/
├── feature/
│   └── [feature_name]/
│       ├── application/
│       │   └── user_service_test.dart
│       └── domain/
│           └── user_test.dart
└── util/
    └── extension/
        └── string_extension_test.dart
```

### テストの書き方

```dart
void main() {
  group('UserService', () {
    late MockUserRepository mockRepository;
    late UserService service;

    setUp(() {
      mockRepository = MockUserRepository();
      service = UserService(mockRepository);
    });

    group('fetchUser', () {
      test('正常にユーザーを取得できる', () async {
        // Arrange
        when(mockRepository.fetchUser(any))
            .thenAnswer((_) async => testUser);

        // Act
        final result = await service.fetchUser('123');

        // Assert
        expect(result, equals(testUser));
        verify(mockRepository.fetchUser('123')).called(1);
      });

      test('ユーザーが存在しない場合は例外をスロー', () async {
        // Arrange
        when(mockRepository.fetchUser(any))
            .thenThrow(UserNotFoundException('123'));

        // Act & Assert
        expect(
          () => service.fetchUser('123'),
          throwsA(isA<UserNotFoundException>()),
        );
      });
    });
  });
}
```

## 参考資料

- [Effective Dart](https://dart.dev/guides/language/effective-dart)
- [Flutter Style Guide](https://github.com/flutter/flutter/wiki/Style-guide-for-Flutter-repo)
- [Riverpod Documentation](https://riverpod.dev/)
- [アーキテクチャガイド](./architecture.md)
