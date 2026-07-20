# flake.nix による開発環境管理への移行 + Flutter 3.41.8 アップグレード

> 注記: ディレクトリ再編に伴いパス表記を現行構成へ更新した（#230）。

## 目的

FVM とホスト依存ツールで構成された開発環境を flake.nix（Nix）管理へ移行し、あわせて Flutter を 3.13.6 → 3.41.8 へアップグレードする。ローカルと CI の環境差をなくし、Flutter バージョンの正本を flake.nix の 1 箇所にする。

## 決定事項（インタビューで確定）

| # | 論点 | 決定 |
|---|------|------|
| 1 | Flutter SDK 管理 | FVM 廃止。Nix で完全管理（389-app / 440 と同じ家内標準パターン: 公式リリース zip を fetchzip し、リポジトリ内 `.nix/flutter/<version>` に書き込み可能展開する flutter/dart ラッパー） |
| 2 | Flutter バージョン | **3.41.8**（マシン内の他プロジェクトで使用中の最新。fetchzip の URL/ハッシュは 389-app の flake から流用可） |
| 3 | スコープ | 環境移行とアプリの依存・コード移行を一括で実施 |
| 4 | flake のツール範囲 | flutter/dart ラッパー、CocoaPods、lcov/genhtml、just、git 等「Nix で管理できるものは原則すべて」。Xcode はホスト依存のまま。**Android は配信終了のため対象外**（JDK / Android SDK は入れない） |
| 5 | CI | **nix develop に統一**。subosito/flutter-action を廃止し、DeterminateSystems/nix-installer-action + `nix develop --command just <task>` へ。対象は check.yml / deliver.yml / bump-pull-request.yml |
| 6 | Android 資産 | deliver.yml の android job を削除。`android/` ディレクトリは残す（ビルド対象外として放置可） |
| 7 | タスクランナー | Makefile を削除し **justfile** へ移行（389-app と同運用）。旧 Makefile の壊れた coverage 絶対パスも解消 |
| 8 | 依存更新ポリシー | **必要最小限のバンプ**。Flutter 3.41.8 / 新 Dart で強制されるもの（Firebase 系、intl、google_mobile_ads 等）のみメジャー更新し、Riverpod / Freezed / auto_route は現メジャー内の最新パッチに留められるなら留める。Riverpod 3 等への更新は別作業 |
| 9 | direnv | `.envrc`（`use flake`）を追加 |
| 10 | Danger | **廃止**。Gemfile / Dangerfile / check.yml の danger step を削除 |
| 11 | 完了条件 | 下記「完了条件」参照。deliver.yml は実リリース時検証（本作業では未検証であることを明記） |

## 実行手順

### Phase 1: Nix 環境の導入
1. `flake.nix` を作成（389-app のパターンを流用: flutter/dart ラッパー、`PUB_CACHE=.nix/pub-cache`、darwin 用 shellHook で `SDKROOT` unset + xcrun clang 設定。ツール: just, cocoapods, lcov, git 等。Ruby / JDK / Android SDK は入れない）
2. `flake.lock` を生成（`nix flake lock`）して**コミット対象に含める**。nixpkgs リビジョンを固定し、ローカル・CI とも committed lock を使う
3. `.envrc`（`use flake`）を追加し、`direnv allow`
4. `.gitignore` に `.nix/` を追加
5. ロック済み環境の検証: `nix flake check` および `nix develop --command flutter --version` が 3.41.8 を返すことを確認

### Phase 2: 旧環境資産の整理
1. FVM 資産を削除: 追跡されている `.fvm/`（`fvm_config.json`）を削除（`.fvmrc` は元々存在しない。`.gitignore` の FVM 関連エントリも掃除）
2. `justfile` を作成し、`Makefile` を削除。タスクの責務を以下に分離する（旧 `make test` は coverage 生成〜macOS `open` まで一体で、CI の Ubuntu で壊れるため）:
   - `just setup` / `just mobile-generate` / `just analyze` / `just format`: 旧 Makefile 相当（fvm プレフィックス除去）
   - `just test`: `flutter test` のみ（CI で使用。OS 非依存）
   - `just coverage`: coverage 生成 + lcov フィルタ + HTML 生成（相対パス）
   - `just coverage-open`: macOS でレポートを開く任意タスク
3. Danger 廃止: `Gemfile` / `Dangerfile` を削除

### Phase 3: アプリの移行（必要最小限バンプ）
1. `mobile_app/pubspec.yaml` の `environment.sdk` を新 Dart に合わせて更新
2. `flutter pub upgrade` で解決を試み、解決不能な箇所のみメジャーバンプ（Firebase 系、intl、google_mobile_ads 等を想定）
3. `dart run build_runner build --delete-conflicting-outputs` で再生成
4. 非互換 API のコード修正（deprecated / removed API 対応。リファクタは行わない）
5. iOS deployment target の確定と統一: 依存解決後（Firebase 等が要求する最低バージョン判明後）に採用する最低 iOS バージョンを **1 つ確定**し、以下 3 箇所を同じ値に揃える（現状は 11.0 と 16.1 が混在）:
   - `ios/Podfile` の `platform :ios`（現在コメントアウト状態 → 有効化して確定値を設定）
   - Xcode project の `IPHONEOS_DEPLOYMENT_TARGET`（Runner: 11.0 ×3 / 16.1 ×3 が混在 → 全ビルド構成を統一）
   - `mobile_app/ios/Flutter/AppFrameworkInfo.plist` の `MinimumOSVersion`（現在 11.0）
6. `pod install` を実行し、iOS ビルドが通る状態にする

### Phase 4: CI の書き換え
1. `check.yml`: flutter-action → nix-installer-action + `nix develop --command just ...`。danger job / step を削除
2. `deliver.yml`: android job を削除。ios job を nix 経由に書き換え
3. `bump-pull-request.yml`: 同様に nix 経由へ（cider 実行）
4. nix ストアと Flutter zip のキャッシュ（magic-nix-cache 等）を設定し CI 時間の増加を緩和

### Phase 5: ドキュメント更新
1. README のセットアップ / 起動手順を nix develop / direnv / just ベースに更新（Flutter バージョン記載も更新）
2. CLAUDE.md のクイックリファレンス（make / fvm コマンド）を just に更新
3. **AGENTS.md** のクイックリファレンス（FVM 管理の記載、make / fvm コマンド）を同様に更新し、CLAUDE.md との整合を確認する。実装時は maintaining-ai-docs スキルを使用

### Phase 6: 検証
1. `nix develop` 内で `flutter analyze` / `flutter test` / `flutter build ios --no-codesign` がパス
2. シミュレータでアプリを起動し、ユーザーが主要画面を手動スモーク確認
3. PR を作成し check.yml（nix 経由）がグリーン

## 完了条件

- [ ] `nix develop`（または direnv）で flutter 3.41.8 / just / cocoapods / lcov が PATH に乗る
- [ ] `flake.lock` がコミットされ、`nix flake check` がパスする
- [ ] FVM（`.fvm/` 含む）/ Makefile / Danger 関連ファイルが削除されている
- [ ] iOS deployment target が Podfile / Xcode project / AppFrameworkInfo.plist で同一値に統一されている
- [ ] README / CLAUDE.md / AGENTS.md に fvm・make の記載が残っておらず、相互に整合している
- [ ] `flutter analyze` がエラー 0
- [ ] `flutter test` が全件パス
- [ ] `flutter build ios --no-codesign` が成功
- [ ] シミュレータでの手動スモーク確認（ユーザー実施）
- [ ] check.yml が nix 経由でグリーン
- [ ] deliver.yml は書き換え済みだが**未検証**（次回リリースで検証）と PR に明記

## リスク

- 3 年分のバージョンジャンプのため、想定外の非互換（pedantic_mono / custom_lint / mockito 等の世代差、iOS 最低バージョン引き上げ）が Phase 3 で発覚しうる。発覚時は「必要最小限」の原則で個別判断
- deliver.yml（TestFlight 配信）は実リリースまで完全検証できない
