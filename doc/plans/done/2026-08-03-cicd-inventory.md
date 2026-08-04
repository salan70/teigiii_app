# CI/CD 棚卸しと backend CD の整備

## 目的

CI/CD のオーバーエンジニアリング・重複・死んだ資産を解消し、backend の deploy 経路に
「どのコードが出たか」の保証を与える。

前提として確認した事実:

- backend の deploy は dev / prod ともローカル手動（`just backend-deploy-*`、wrangler OAuth）。
  CI 側に Cloudflare Workers へ触る経路は存在しない。
- develop の branch protection に `required_status_checks` が **0 件**。
  レビュー承認も 0 人必須のため、**CI が赤でも merge できる**。
- PR の web preview が叩く backend は `dart_defines/dev.json` の `apiBaseUrl` 固定で、
  共有の dev Worker 1 個。**PR の backend 変更は preview に反映されない**。
- merge 戦略は merge commit のみ（squash / rebase 無効）。`pull_request` イベントは
  base 最新との仮想 merge を検証しているため、merge 後の develop push 検証はほぼ冗長。
- 未フォーマット: backend 3 ファイル / mobile 16 ファイル（うち 8 は生成物）。

## 方針の要点

**dev は CD 化する。prod はローカル手動を維持する。**

dev Worker を develop と一致させ続けることは、単に「最新に保つ」以上の意味を持つ。
mobile PR の preview は「この PR のフロント × develop の backend」を検証する前提で
成立しており、dev Worker が手動 deploy で漂流すると **全ての PR preview が
正体不明の backend を相手にする**ことになる。ここを自動化して初めて preview 機構の
前提条件が成立する。

一方 prod を CI 化して得られる実質的な利得は「作業ツリーの汚れが prod に出るのを防ぐ」
一点のみで、それは justfile のガード数行で得られる。CI 化すると prod 全権トークンを
GitHub に置く必要が生じ、攻撃面が増える。手数も増える。よって見送る。

## 実行手順

### 1. `check.yml` → `ci.yml` 改名と構造整理

- `.github/workflows/check.yml` を `ci.yml` にリネーム（`name: ci`）
- `concurrency.group` から冗長な `check-` プレフィックスを外し
      `${{ github.workflow }}-${{ github.ref }}` にする
- mobile 系ジョブ（`mobile-analyze` / `mobile-test`）に
      `if: github.event_name == 'pull_request'` を付与。
      develop push で走るのは `changes` → `backend-*` → `deploy-dev` のみとする
- 集約ジョブ `ci-passed` を追加（`needs` に全検証ジョブ、`if: always()`）。
      `skipped` は許容し `failure` / `cancelled` のみ落とす
- ファイル冒頭に「検証は PR、deploy は develop push」の役割分担をコメントで残す

### 2. dev CD の追加

- `ci.yml` に `deploy-dev` ジョブを追加
  - `needs: [backend-analyze, backend-test]`
  - `if: github.event_name == 'push' && github.ref == 'refs/heads/develop'`
  - 実行は `just backend-deploy-dev`（コマンド直書きしない。ローカルとの乖離を防ぐ）
  - `just` を CI に持ち込むため flake に `ci-backend` devShell（just + bun）を追加する。
    Nix は mobile ジョブで既に CI の依存なので、新しいサプライチェーンは増やさない
  - migration（本体 + テレメトリ）と `seed-dev` は一括自動のまま。
    dev D1 のデータは QA 用であり保全対象ではない。destructive migration を dev で
    先に流すこと自体が prod 前のリハーサルになる
- `backend-deploy-dev` から AVATAR_BASE_URL プレースホルダガードを外し、
      `backend-analyze` 側へ移設する（deploy 直前ではなく PR 時点で落とすべき性質）
- Cloudflare API token `CLOUDFLARE_API_TOKEN_DEV` を発行し repo secret に登録
  - 権限: Workers Scripts Edit + D1 Edit
  - 発行時に **D1 を DB 単位でスコープできるか確認する**。できない場合、
    dev token でも prod D1 に到達しうるため、この分割の効果は
    「`--env` 指定漏れによる Worker 取り違えの防止」に留まる旨をコメントに残す
  - 既存 `CLOUDFLARE_API_TOKEN`（Pages Edit）はそのまま web-preview 専用に残す

### 3. prod deploy のガード（justfile）

- `backend-deploy-prod` の依存チェーンから `backend-migrate-prod` /
      `backend-migrate-prod-telemetry` を外し、独立実行にする
  - 理由: deploy は `wrangler rollback` で可逆、migration は forward-only で不可逆。
    さらに順序が migration の性質で反転する（additive なら migrate → deploy、
    destructive なら deploy → migrate）。束ねると後者が扱えない
- `backend-deploy-prod` に事前ガードを追加
  - 作業ツリーが clean（`git diff --quiet && git diff --cached --quiet`）
  - HEAD が `origin/develop` と一致（push 済み）
  - その commit の CI が green（`gh api repos/{owner}/{repo}/commits/<sha>/check-runs`）
- `backend-analyze` に `backend-validate-prod`（既存 recipe、prod の dry-run）を
      1 ステップ追加し、prod の bindings 設定ミスを PR 時点で検出する

### 4. branch protection

- develop の required status checks に `ci-passed` **のみ**を登録
  - 全ジョブを個別に required にすると、`changes` gate で skip されたジョブが
    「未完了」扱いになり merge が永久にブロックされる
  - `docbridge / check` は **含めない**

### 5. 死んだ secrets の整理

- **先に `ANDROID_KEY_JKS_BASE64` の原本所在を確認する**。
      GitHub secret は読み出せないため、原本を失うと Play Store で同一アプリとして
      更新できなくなり回復手段がない。所在が確認できない場合、この 1 本は削除を保留する
- 削除: `ANDROID_KEY_ALIAS` / `ANDROID_KEY_PASSWORD` / `ANDROID_STORE_PASSWORD` /
      `GOOGLE_SERVICE_ACCOUNT_KEY_JSON_BASE64` / `OPENAI_API_KEY`
- `OPENAI_API_KEY` は削除に加えて **OpenAI 側で revoke** する
      （2023-11 から有効なままなら課金リスク）
- Android CD は当面やらない旨を明示する。着手するなら別 Issue

### 6. web-preview の整理

- `web-preview.yml` から `on.push`（develop）を削除。PR 限定にする
- sticky コメントの文言に「**backend は共有 dev Worker。この PR の backend 変更は
      含まれない**」を追記。現状の「実 everyone-teigi-dev / 実 D1」は
      backend が PR の内容だと誤読させる

### 7. format / lockfile

- `just format` で既存 drift を解消（backend 3 / mobile 16 ファイル）
- `just mobile-generate` の末尾に `dart format .` を繋ぐ
      （生成物 8 つが未フォーマットのため、これがないと build_runner のたびに CI が赤くなる）
- `backend-analyze` に `bun run format:check` を追加
- `mobile-analyze` に `dart format --set-exit-if-changed --output=none .` を追加
- `ci.yml` の backend ジョブの `bun install` を `bun install --frozen-lockfile` に統一
      （`web-preview.yml` は既に使用済み。同一 repo で厳密さが場所により違う状態を解消）
- `backend/test/justfile.test.ts` を新しい prod deploy の不変条件に合わせて書き換える
      （旧テストは「deploy が migration に依存する」ことを固定していた）

### 8. 機械的な重複・古さの解消

- Flutter bootstrap の 16 行（`check.yml` × 2 + `web-preview.yml` × 1 の完全同一コピペ）を
      `ci-nix-setup` composite action に取り込む
- `docbridge.yml` の 2 ジョブを 1 ジョブに統合（checkout + bun setup の重複排除）
- `tagging-when-merged.yml` の `actions/checkout@v3` → `@v4`
- `deliver.yml` の `IOS_CERTIFICATE_P12_P12_PASSWORD` を `IOS_CERTIFICATE_P12_PASSWORD` に修正
- `bunx docbridge@0.5.2` のバージョン重複（3 箇所）を 1 箇所に集約するか、許容を明記
- `web-preview.yml` の `concurrency.group` の冗長プレフィックスを外す
      （`ci.yml` / `docbridge.yml` と揃える）

### 9. 実行頻度の低いワークフローの closure 削減

- `deliver.yml` を `ci-nix-setup` + 新設 `ci-deliver` devShell に切り替える
  - default shell は openapi-generator-cli（JRE 込みで 151MB）/ lcov / bun / ripgrep /
    qrencode まで実体化するが、iOS リリースビルドで使うのは Flutter / just / git /
    jq / curl / CocoaPods だけ。macos runner は課金 10 倍なので削る価値が大きい
  - iOS ネイティブビルドのため、default と同じ darwin 向け環境調整
    （`SDKROOT` 等の unset、`CC` / `CXX` を xcrun から設定）を `ci-deliver` にも入れる
  - git は CocoaPods の spec repo 取得に必要なため落とさない
  - **Flutter SDK はキャッシュしない。** macos はキャッシュキーが Linux と別のため
    ~1.7GB を新規消費し、repo 上限 10GB の LRU で高頻度な PR CI 側の Linux キャッシュを
    追い出しうる。deliver はタグ push 時のみで 7 日失効に引っかかりやすく、
    macos runner での 1.7GB 転送自体も高くつく。pub のみキャッシュする
- `bump-pull-request.yml` の `just setup` を `just mobile-setup` に変える
  - `cider` を動かすのに backend の bun install は不要
  - こちらは ubuntu runner なので `flutter-Linux-*` キャッシュを ci.yml と共有でき、
    新規のキャッシュ枠を消費しない。`cache-flutter` は有効にする

## 意図的に採用しなかったもの

判断の記録として残す。再検討時にここを起点にする。

- **prod の CD 化（workflow_dispatch）** — 利得は「作業ツリーの汚れ防止」のみで、
  justfile ガードで代替可能。prod 全権トークンを GitHub に置くコストが上回る
- **GitHub Environment `production` + 承認ゲート** — prod を CI 化しないため不要になった。
  そもそも承認ボタンは migration の順序問題を解決しない
- **gradual rollout / `wrangler versions upload`** — 個人開発のトラフィックで
  段階配信する意味がなく、運用手順だけ増える
- **prod への post-deploy smoke test** — 認証不要エンドポイントが無く（App Check が全ルート必須）、
  App Check token は 1 時間で失効するため secret に固定できない。
  既存 `smoke-dev.sh` は user create / PATCH / avatar PUT を含み本番データを汚すので流用不可
- **PR ごとの dev Worker（`--name teigiii-api-pr-N`）** — D1 は共有せざるを得ず、
  Worker だけ分けても中途半端。個人開発には過剰
- **`workflow_run` による deploy 起動** — 起動元 PR との紐付けが弱く、ログ追跡も二度手間
- **`check.yml` の `changes` fallback の撤去** — `.vscode/` 等の変更で全ジョブが走るのは
  無駄だが、「黙って skip しない」という意図的な安全側の設計であり、現状維持

## 完了条件

- backend を変更した PR を develop に merge すると、`backend-analyze` / `backend-test`
      が green の場合にのみ dev Worker が自動更新される
- mobile のみの PR を merge したとき、develop push で mobile 系ジョブが走らない
- CI が赤い PR が develop に merge できない（`ci-passed` が required）
- `just format` が no-op になり、format 違反を含む PR が CI で落ちる
- `just backend-deploy-prod` が、作業ツリーが汚れている / push されていない /
      CI が green でない状態で拒否される
- prod の migration が `backend-deploy-prod` から独立して実行できる
- 未参照 secrets が GitHub から消えている（`ANDROID_KEY_JKS_BASE64` は原本確認後）
- Flutter bootstrap のコピペが 3 箇所から 1 箇所になっている
- `deliver.yml` が `workflow_dispatch`（`upload: false`）で成功し、IPA が生成される
      — タグ push でしか走らないため、merge 前にこの経路で検証する

## 実行結果

PR #320 で実施。コミットは 4 本（format drift / 本体 / closure 削減 / レビュー指摘対応）。

### 完了したもの

実行手順 1〜3、6〜9 はすべてコード側で完了し、`ci-passed` を含む CI が green。
`deliver.yml` は `workflow_dispatch`（`upload: false`）で実行し、
[run 30820171319](https://github.com/salan70/teigiii_app/actions/runs/30820171319) が
success（IPA 生成を確認、App Store Connect へのアップロードは skip）。所要 11m43s で、
変更前の 12m31s〜14m40s から 1〜3 分短縮。当初見込んだほどの効果ではなく、
ビルド時間の大半が Xcode のコンパイルであることが実測で分かった。

レビュー指摘を受けて、当初計画になかった修正を 2 件追加した。

- `ci.yml` の `paths-ignore` を撤去した。`ci-passed` を required にすると、
  path filter で workflow ごと起動しないケースで check run が生成されず Pending のまま
  残り、Markdown のみの PR が merge できなくなる。docs-only の develop push でも
  `ci-passed` が存在せず `backend-guard-prod` が prod deploy を拒否する。
  代わりに Markdown 以外の変更の有無を判定する `code` フィルタを追加し、
  「Markdown のみなら全ジョブ skip」「未知の非 Markdown なら両方実行」に分けた。
  このフィルタは `predicate-quantifier: 'every'` を別 step で指定する必要がある
  （既定の `some` では全ての `.md` が `**` に一致して除外パターンが無効化される）。
- `doc/specs/workers-api-server.md` を実装に合わせた。「dev / prod とも手動デプロイ」
  「どちらも migration 成功後に deploy」のままで、prod デプロイ手順にも
  「`backend-migrate-prod` の成功後にだけ deploy する」と書かれていた。
  仕様に従った操作者が古いスキーマに対して Worker を publish しうる状態だった。

### 未完了（コード外の手動作業。Issue #319 で追跡する）

実行手順 4（branch protection）と 5（死んだ secrets）は GitHub 上の操作であり、
この plan の実行では完了しない。

- `CLOUDFLARE_API_TOKEN_DEV` の発行と登録（Workers Scripts Edit + D1 Edit）。
  **これが無いと merge 後の初回 develop push で `deploy-dev` が失敗する。**
  発行時に D1 を DB 単位でスコープできるか確認する
- develop の required status checks に `ci-passed` を登録。
  `ci-passed` が develop 上に存在してからでないと設定できないため merge 後に行う
- 未参照 secrets の削除（`ANDROID_KEY_ALIAS` / `ANDROID_KEY_PASSWORD` /
  `ANDROID_STORE_PASSWORD` / `GOOGLE_SERVICE_ACCOUNT_KEY_JSON_BASE64` /
  `OPENAI_API_KEY`）。`OPENAI_API_KEY` は OpenAI 側での revoke も必要
- `ANDROID_KEY_JKS_BASE64` は原本所在を確認してから削除する

### 別途対応が必要（この plan の範囲外）

- `backend/test/schema.test.ts` の migration SQL テスト 13 件がローカルでのみ失敗する。
  develop 時点で既に発生しており CI（Linux）では通る。手元の `bun:sqlite` が
  `ALTER TABLE ... RENAME` を扱う際の挙動差が原因と見ている
- `doc/specs/workers-api-server.md` の「各 PR で ... OpenAPI 差分 ... を通す」は
  現状も事実ではない（`backend-analyze` に OpenAPI 差分検査は存在しない）。
  今回持ち込んだ乖離ではないため本 PR では触れていない
