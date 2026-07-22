# Firebase Analytics 強化（#251）

## 目的

機能利用率・ファネル・リテンション判断に使える計測基盤を入れる。

## 実行手順

1. `doc/specs/analytics-events.md` を現行コードに合わせて正本化（存在しない draft / word_updated は除外）
2. Phase 0: `FirebaseAnalytics` provider + `AnalyticsService` facade + `app_launched` / auth イベント + `setUserId`
3. Phase 1: `FirebaseAnalyticsObserver` を router に配線
4. Phase 2–4: application 層の成功パスにイベント差し込み
5. facade / 主要 service の自動テスト
6. `just mobile-analyze` / 関連テスト

## 完了条件

- [x] カタログ正本が存在する
- [x] 必須イベントが facade 経由で application 層からのみ送信される
- [x] `setUserId` がログイン後セット・アカウント削除でクリア
- [x] facade と主要成功パスの自動テストがある
- [x] Crashlytics logger と混同していない
