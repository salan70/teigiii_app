# Issue #269 prod rollout

## 目的

PR #267 の加算的な D1 migration と Worker を prod へ安全な順序で反映し、
以後も同じ手順を `just` recipe から再現できるようにする。

## 実行手順

1. `backend-deploy-prod` が `backend-migrate-prod` を先に実行することを
   `backend/test/justfile.test.ts` の Justfile 契約テストで固定する。
2. prod migration / deploy recipe を追加し、陳腐化した
   `backend-validate-prod` の説明を更新する。
3. backend の unit test、lint、typecheck、format check と
   `backend-validate-prod` を実行する。
4. prod の未適用 migration を確認し、migrate → deploy の順で反映する。
5. prod の migration 残がゼロであることと、主要 API フローを確認する。
6. plan を `doc/plans/done/` へ移動し、PR と Issue に結果を記録する。

## スモーク拡張の判断

`POST /v1/words` / `POST /v1/definitions` を既存の remote smoke に追加すると、
prod の公開辞書または個人辞書へテストデータを残す。言葉自体の削除 API がなく
完全な後始末ができないため、本 Issue では永続的な smoke script への追加を行わない。
対象契約は Worker integration test で検証し、prod では実際のリリース候補アプリから
主要フローを確認する。

## 完了条件

- `backend-migrate-prod` が prod D1 migration を実行する。
- `backend-deploy-prod` が migration 成功後にだけ prod Worker を deploy する。
- backend の関連検証と prod dry-run が成功する。
- prod Worker に PR #267 が反映されている。
- prod D1 の未適用 migration がゼロである。
- prod の主要フロー確認結果が Issue #269 に記録されている。
