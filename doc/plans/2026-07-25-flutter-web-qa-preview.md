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

### backend / Cloudflare（既存と同じ）

- デプロイ認証は `wrangler login` の OAuth のみ。ローカルに `CLOUDFLARE_API_TOKEN` は置かない
- Worker の公開識別子は `backend/wrangler.toml` の vars（Firebase project ID / number など）
- Worker 用の Wrangler secret は現状なし（App Check / Auth は公開 JWKS 検証）
- CI の Pages deploy だけ GitHub secrets の `CLOUDFLARE_API_TOKEN` / `ACCOUNT_ID` を使う

### Web QA 追加分（Flutter ビルド用・ルート `.env`）

AdMob と同じくリポジトリ直下 `.env` に書く（gitignore）:

- `FIREBASE_WEB_API_KEY`
- `FIREBASE_WEB_APP_ID`
- `APP_CHECK_DEBUG_TOKEN`

### Pages Basic Auth（Cloudflare 上の Pages secrets）

- `WEB_PREVIEW_BASIC_AUTH_USER` / `WEB_PREVIEW_BASIC_AUTH_PASSWORD`
- `--env preview` が本命（production 枠も使うなら両方）
- パスワードは PR / README に書かない

## 設計判断: Pages 専用 Basic 認証 + App Check debug token

public リポでも実 `everyone-teigi-dev` / 実 D1 でフル疎通したい。匿名 Auth があるため、
Pages URL を開ける人 = 共有 dev DB に書ける人、になる。

そのため **Web QA プレビュー（Cloudflare Pages）だけ** Basic 認証を必須にする
（`mobile_app/web/_worker.js`）。native / Workers API / prod には付けない。
LAN の `just web-serve` も対象外（ローカルネット前提）。

`APP_CHECK_DEBUG_TOKEN` は GitHub secrets 経由でビルド成果物に焼き込まれるが、
Basic 認証の内側にしか出てこない。登録済み debug token は **dev** Firebase の App Check を
バイパスできるため、Basic 認証のパスワード漏洩時は token も revoke / 再発行する。

## 完了条件

- [x] `flutter build web`（dev define）が通る
- [x] Web 起動時に native 専用 API でクラッシュしない（コード上で無効化）
- [x] backend CORS: OPTIONS が App Check なしで通る（dev binding 時のみ）
- [x] CI workflow / just レシピが存在する
- [ ] console 準備（Firebase Web アプリ / **App Check debug token を Web アプリに登録** / CF Pages / GitHub secrets / Pages Basic Auth secrets）
  - `exchangeDebugToken` が 403 のときは未登録か、Web API key の HTTP referrer 制限に `*.pages.dev` が無い
- [ ] スマホ実機ブラウザで API 疎通確認（Basic Auth 通過後）
- [ ] PR に自動でプレビュー URL が貼られる（`WEB_PREVIEW_ENABLED=true` + secrets 後）

## 検証ログ

- `flutter build web --release --dart-define-from-file=dart_defines/dev.json` → success
- `flutter test test/feature/user_profile/` → pass
- `bun test` (backend unit, CORS 含む) → pass
