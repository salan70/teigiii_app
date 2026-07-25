# Flutter Web QA プレビュー環境 (#254)

## 目的

シミュレータ/実機での動作確認コストを下げるため、dev QA 用の Flutter Web ミラーを用意する。

- PR ごとに Cloudflare Pages プレビューを自動デプロイし、URL を sticky コメントする
- ローカルでも `just web-preview` / `just web-serve` で URL/QR を出す

本番 Web 提供はスコープ外。Web 非対応の native 機能は `kIsWeb` で無効化する。

## 実行手順

1. Flutter Web 化（`web/` 生成、`dart:io` 除去、`TargetPlatformExtension` / Firebase options 修正）
2. native 依存の Web 無効化（ads / crashlytics / ATT / in_app_review / image_cropper）
3. backend に CORS を App Check より前へ追加（dev のみ・自プロジェクト Pages に限定）
4. GitHub Actions + `just` レシピ + Nix `qrencode`
5. Web ビルドと backend テストで検証

## 事前準備（console / secrets・コード外）

- Firebase(dev) に Web アプリ登録 → `FIREBASE_WEB_API_KEY` / `FIREBASE_WEB_APP_ID`
- App Check デバッグトークン発行・登録 → `APP_CHECK_DEBUG_TOKEN`
- Cloudflare Pages プロジェクト作成、`CLOUDFLARE_API_TOKEN` / `CLOUDFLARE_ACCOUNT_ID`
- GitHub secrets へ上記を登録

## 設計判断: App Check debug token の公開埋め込み

`APP_CHECK_DEBUG_TOKEN` は GitHub secrets 経由でビルド成果物（`index.html` / `main.dart.js`）に焼き込まれ、
`*.pages.dev` の公開 URL から誰でも閲覧できる。登録済み debug token は **dev** Firebase の App Check をバイパスできる。

許容する理由:

- 対象は everyone-teigi-**dev** のみ（prod には載せない）
- プレビューは使い捨てで、漏洩時は Firebase console から debug token を revoke して再発行できる
- Cloudflare Access で URL 自体を絞る案は、スマホ実機での QR 即時確認を優先するため今回は採らない

## 完了条件

- [x] `flutter build web`（dev define）が通る
- [x] Web 起動時に native 専用 API でクラッシュしない（コード上で無効化）
- [x] backend CORS: OPTIONS が App Check なしで通る（dev binding 時のみ）
- [x] CI workflow / just レシピが存在する
- [ ] console 準備（Firebase Web アプリ / App Check debug token / CF Pages / GitHub secrets）
- [ ] スマホ実機ブラウザで API 疎通確認
- [ ] PR に自動でプレビュー URL が貼られる（`WEB_PREVIEW_ENABLED=true` + secrets 後）

## 検証ログ

- `flutter build web --release --dart-define-from-file=dart_defines/dev.json` → success
- `flutter test test/feature/user_profile/` → pass
- `bun test` (backend unit, CORS 含む) → pass
