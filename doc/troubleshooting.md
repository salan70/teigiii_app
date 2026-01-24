# トラブルシューティングガイド

開発中によく遭遇する問題と解決方法をまとめています。

## 目次

- [セットアップ関連](#セットアップ関連)
- [ビルド・実行関連](#ビルド実行関連)
- [コード生成関連](#コード生成関連)
- [テスト関連](#テスト関連)
- [Firebase関連](#firebase関連)
- [iOS固有の問題](#ios固有の問題)
- [Android固有の問題](#android固有の問題)
- [その他](#その他)

---

## セットアップ関連

### FVM が見つからない

**エラー:**
```
zsh: command not found: fvm
```

**解決方法:**

```bash
# Dart pub でインストール
dart pub global activate fvm

# パスを追加（~/.zshrc または ~/.bashrc に追記）
export PATH="$PATH":"$HOME/.pub-cache/bin"

# シェルを再起動
source ~/.zshrc
```

または Homebrew でインストール:

```bash
brew tap leoafarias/fvm
brew install fvm
```

---

### Flutter SDK が見つからない

**エラー:**
```
Flutter SDK not found
```

**解決方法:**

```bash
# プロジェクトディレクトリで実行
cd teigiii_app
fvm install
fvm use 3.13.6

# 確認
fvm flutter doctor
```

---

### 依存関係の解決に失敗

**エラー:**
```
Because xxx depends on yyy ^1.0.0 which doesn't match any versions...
```

**解決方法:**

```bash
# キャッシュをクリア
fvm flutter clean
rm -rf pubspec.lock

# 再インストール
fvm flutter pub get
```

それでも解決しない場合:

```bash
# Flutter のキャッシュもクリア
fvm flutter pub cache repair
fvm flutter pub get
```

---

## ビルド・実行関連

### Gradle ビルドエラー（Android）

**エラー:**
```
FAILURE: Build failed with an exception.
```

**解決方法:**

```bash
# Gradle キャッシュをクリア
cd android
./gradlew clean
cd ..

# 再ビルド
fvm flutter clean
fvm flutter pub get
fvm flutter run --dart-define-from-file=dart_defines/dev.json
```

---

### CocoaPods エラー（iOS）

**エラー:**
```
[!] CocoaPods could not find compatible versions for pod "xxx"
```

**解決方法:**

```bash
cd ios
rm -rf Pods Podfile.lock
pod repo update
pod install
cd ..
```

CocoaPods 自体の問題の場合:

```bash
sudo gem install cocoapods
pod setup
```

---

### Dart Define ファイルが見つからない

**エラー:**
```
Could not find file dart_defines/dev.json
```

**解決方法:**

`dart_defines/` ディレクトリに `dev.json` と `prod.json` が存在するか確認:

```bash
ls dart_defines/
```

ファイルが存在しない場合は、チームメンバーから取得するか、テンプレートを作成:

```json
// dart_defines/dev.json
{
  "flavor": "dev"
}
```

---

### Hot Reload が動作しない

**解決方法:**

1. ターミナルで `r` キーを押してみる
2. `R` キーを押して Hot Restart を試す
3. 完全に停止して再実行:

```bash
# Ctrl+C でアプリを停止
fvm flutter run --dart-define-from-file=dart_defines/dev.json
```

---

## コード生成関連

### build_runner がエラー

**エラー:**
```
[SEVERE] Failed to generate code
```

**解決方法:**

```bash
# 生成済みファイルを削除して再生成
fvm flutter packages pub run build_runner clean
fvm flutter packages pub run build_runner build --delete-conflicting-outputs
```

または Makefile を使用:

```bash
make generate
```

---

### freezed で生成されたファイルにエラー

**エラー:**
```
The method 'xxx' isn't defined for the type '_$YyyImpl'
```

**解決方法:**

1. `*.freezed.dart` ファイルを削除
2. コード生成を再実行

```bash
find . -name "*.freezed.dart" -delete
make generate
```

---

### riverpod_generator のエラー

**エラー:**
```
Could not generate provider for xxx
```

**解決方法:**

アノテーションが正しいか確認:

```dart
// 正しい形式
@riverpod
Future<User> currentUser(CurrentUserRef ref) async { ... }

// Ref の命名は関数名 + "Ref"
// currentUser -> CurrentUserRef
```

---

## テスト関連

### テストが見つからない

**エラー:**
```
No tests found
```

**解決方法:**

テストファイル名が `_test.dart` で終わっているか確認:

```bash
# 正しい例
user_service_test.dart

# 間違った例
user_service_tests.dart
test_user_service.dart
```

---

### モックが生成されない

**エラー:**
```
MockXxx is not defined
```

**解決方法:**

1. `@GenerateMocks` アノテーションを確認:

```dart
@GenerateMocks([UserRepository])
void main() { ... }
```

2. コード生成を実行:

```bash
make generate
```

---

### テストがタイムアウト

**エラー:**
```
TimeoutException: Test timed out after 30 seconds
```

**解決方法:**

テストにタイムアウトを設定:

```dart
test('long running test', () async {
  // ...
}, timeout: Timeout(Duration(minutes: 2)));
```

または非同期処理が正しく完了しているか確認。

---

## Firebase関連

### Firebase の初期化エラー

**エラー:**
```
Firebase has not been initialized
```

**解決方法:**

1. `dart_defines/*.json` ファイルが存在するか確認
2. `lib/util/firebase_options/` のファイルが存在するか確認
3. 正しい環境で実行しているか確認:

```bash
# dev 環境
fvm flutter run --dart-define-from-file=dart_defines/dev.json

# prod 環境
fvm flutter run --dart-define-from-file=dart_defines/prod.json
```

---

### Firestore パーミッションエラー

**エラー:**
```
[cloud_firestore/permission-denied] Missing or insufficient permissions
```

**解決方法:**

1. Firebase コンソールで Firestore のルールを確認
2. 認証状態を確認（ログインが必要な場合）
3. 開発環境では一時的にルールを緩和（本番では厳格に）

---

### .env ファイルが読み込めない

**エラー:**
```
Unable to load .env file
```

**解決方法:**

1. プロジェクトルートに `.env` ファイルがあるか確認
2. ファイル形式が正しいか確認:

```
BANNER_ID_IOS=ca-app-pub-xxx/xxx
BANNER_ID_ANDROID=ca-app-pub-xxx/xxx
```

3. `flutter_dotenv` が pubspec.yaml の assets に含まれているか確認

---

## iOS固有の問題

### Xcode バージョンの問題

**エラー:**
```
Xcode version must be >= xxx
```

**解決方法:**

App Store から Xcode を最新版に更新してください。

---

### Provisioning Profile エラー

**エラー:**
```
No signing certificate "iOS Development" found
```

**解決方法:**

1. Xcode で Runner.xcworkspace を開く
2. Signing & Capabilities で Team を設定
3. 自動署名を有効化

```bash
open ios/Runner.xcworkspace
```

---

### iOS Simulator が起動しない

**解決方法:**

```bash
# シミュレータをリセット
xcrun simctl erase all

# または特定のシミュレータを再起動
xcrun simctl shutdown all
xcrun simctl boot "iPhone 15 Pro"
```

---

## Android固有の問題

### SDK ライセンスの問題

**エラー:**
```
Android license status unknown
```

**解決方法:**

```bash
fvm flutter doctor --android-licenses
# 全てのライセンスに 'y' で同意
```

---

### エミュレータが起動しない

**解決方法:**

1. Android Studio で AVD Manager を開く
2. 新しいエミュレータを作成するか、既存のものを削除して再作成
3. HAXM（Intel）または Hypervisor（ARM Mac）が有効か確認

---

### Multidex エラー

**エラー:**
```
Cannot fit requested classes in a single dex file
```

**解決方法:**

`android/app/build.gradle` で multidex を有効化:

```gradle
android {
    defaultConfig {
        multiDexEnabled true
    }
}

dependencies {
    implementation 'androidx.multidex:multidex:2.0.1'
}
```

---

## その他

### VS Code で補完が効かない

**解決方法:**

1. Dart Analysis Server を再起動:
   - `Cmd/Ctrl + Shift + P` → "Dart: Restart Analysis Server"

2. VS Code を再起動

3. `.dart_tool/` を削除して pub get:

```bash
rm -rf .dart_tool
fvm flutter pub get
```

---

### Git の変更が多すぎる

**原因:** コード生成ファイルがトラッキングされている

**解決方法:**

`.gitignore` に以下が含まれているか確認:

```
*.freezed.dart
*.g.dart
*.gr.dart
*.mocks.dart
```

既にコミットされている場合:

```bash
git rm --cached "*.freezed.dart"
git rm --cached "*.g.dart"
git rm --cached "*.gr.dart"
git rm --cached "*.mocks.dart"
git commit -m "chore: 自動生成ファイルをgitignore"
```

---

### メモリ不足エラー

**エラー:**
```
Dart VM out of memory
```

**解決方法:**

```bash
# Dart VM のメモリ制限を増やす
export DART_VM_OPTIONS="--old_gen_heap_size=4096"
fvm flutter pub get
```

---

## 問題が解決しない場合

1. エラーメッセージを検索
2. [Flutter GitHub Issues](https://github.com/flutter/flutter/issues) を確認
3. チームメンバーに相談
4. Issue を作成して報告

### 有用なデバッグ情報

問題を報告する際は以下の情報を含めてください:

```bash
# Flutter の環境情報
fvm flutter doctor -v

# 使用している Flutter バージョン
fvm flutter --version

# プロジェクトの依存関係
fvm flutter pub deps
```
