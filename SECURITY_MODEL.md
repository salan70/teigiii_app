# セキュリティモデル

言葉の定義を投稿・共有するアプリ「みんなの定義」（teigiii）の脅威モデルである。
セキュリティスキャンと設計レビューで、何を守り、誰から守るかの前提として使う。

## 利用者が決めた前提

- 資産に優先順位は付けず、すべて同等に扱う。
- 攻撃者は下の「攻撃者」節のとおりとする。
- 内部 QA 用ツール（`ui_review`、`scenario_viewer` など）は対象外とする。
  ここだけに影響する指摘は優先度を下げる。
- 指摘には CVE と OWASP カテゴリのタグを付ける。

## コンポーネント

| 名前 | コード | 種類 |
| --- | --- | --- |
| teigiii-api | `backend/`（Hono、D1、R2、Cloudflare Workers） | 公開 API |
| teigiii-mobile | `mobile_app/` | 公開アプリ（iOS、Android） |
| teigiii-ci | `.github/workflows/` | CI/CD |

## 信頼境界とエントリポイント

- アプリは App Store と Google Play から誰でも入手でき、Firebase Authentication でアカウントを作れる。
  クライアントは信頼しない。
- teigiii-api はすべての経路で `X-Firebase-AppCheck` を検証する（`backend/src/auth/middleware.ts`）。
- `/v1/app-config` と `/v1/telemetry/frames` 以外は Firebase ID トークン（`Authorization: Bearer`）も要求する。
- D1 にユーザー、定義、単語を、R2 にアバターを保存する。
  所有者の確認の抜け（IDOR）と入力検証が主な論点である。

## 資産

- ユーザーのアカウント、定義の投稿・下書き、プロフィール、アバター。
- Cloudflare と Firebase の設定と課金。

## 攻撃者

- インターネット上の匿名者（公開 API に到達する）。
- 公開アプリの一般ユーザー（誰でもサインアップでき、他ユーザーのデータを狙う）。
- サプライチェーン（依存パッケージ、GitHub Actions）。

## 既存の対策

- App Check と Firebase ID トークンの検証。
  ID トークンの免除パスは完全一致で判定する。

## 対象外・許容リスク

- `mobile_app/tool/ui_review/`（内部 QA 用ツール）。
