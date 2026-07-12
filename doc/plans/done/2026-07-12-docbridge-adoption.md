# DocBridge 導入

## 目的

コード（`lib/`）と Markdown 仕様書を双方向リンクする [DocBridge](https://github.com/salan70/docbridge) を導入する。
現時点で仕様書は存在しないが、将来 `doc/specs/` に仕様書を追加した時点で
リンク検証・エージェント向けコンテキスト注入・CI ゲートが即座に機能する状態を作る。

## 合意済みの設計判断

- **導入範囲**: フル導入（config / 実行環境 / justfile / Claude Code・Codex フック / スキル 5 種 / CI）
- **実行環境**: flake.nix の devShell に `pkgs.bun` を追加し、`bunx docbridge@0.5.0` でバージョンをピン留めして実行。`package.json` は持ち込まない
- **スキャン対象**: code = `lib/**/*.dart`、docs = `doc/specs/**/*.md`（新設）。`doc/plans/` や `doc/architecture.md` は対象外
- **CI**: 新規ワークフロー `docbridge.yml`（`paths-ignore` なし。既存 check.yml は md 変更でスキップされるため分離する）
  - `check` ジョブ: `docbridge check` — リンク切れで fail
  - `related-gate-report` ジョブ: PR 変更ファイルへの `related --gate` を informational 運用（fail させず sticky コメントで報告）
- **エージェント統合**: Claude Code / Codex 両対応。フック 2 種（編集時カウンターパート注入 = PostToolUse、未更新カウンターパート警告 = Stop）を `.claude/` と `.codex/` に別アセットとして配置。スキル 5 種は `.claude/skills/` と `.agents/skills/` の両方へコピー
- **作業単位**: 1 Issue + 1 PR

## 実行手順

1. GitHub Issue を作成（このスコープを記載）
2. ブランチ作成（`feature/#<issue>_docbridge-adoption`）
3. flake.nix の `toolPackages` に `pkgs.bun` を追加
4. `docbridge.config.json` を作成（dart: `lib/**/*.dart`、docs: `doc/specs/**/*.md`）
5. `doc/specs/README.md` を作成（ディレクトリの目的と `@doc`/`@code` の書き方への参照）
6. justfile に `docbridge-check` レシピを追加（`bunx docbridge@0.5.0 check`）
7. スキル導入: `bunx docbridge@0.5.0 init --agent-target both`（既存 config は上書きされない仕様）
8. フック導入: docbridge リポジトリの `examples/hooks/` から 2 スクリプトをコピーし、
   `.claude/hooks/` + `.claude/settings.json` と `.codex/hooks/` + `.codex/hooks.json` に登録
9. `.github/workflows/docbridge.yml` を作成（docbridge 本体の ci.yml の related-gate-report を流用）
10. 検証（完了条件参照）
11. コミット・push・PR 作成

## 完了条件

- [ ] `nix develop` 環境で `just docbridge-check` が成功する（`doc/specs/` にリンクゼロの状態でエラーにならないことを確認）
- [ ] Claude Code のフックが発火することを手動確認
- [ ] Codex 側は `/hooks` での信頼（trust）が必要なため、その手順を PR 本文に記載
- [ ] PR 上で docbridge.yml の CI が green
- [ ] PR 作成完了（マージはユーザーが判断）

## 将来課題（仕様書を書き始める段階で対応）

- **Freezed の doc コメント複製リスク**: Freezed は元クラスの doc コメントを
  `.freezed.dart` へ複製することがあり、`@doc` アノテーションが重複リンクになる可能性がある。
  glob に否定パターンがなく生成ファイルを除外できないため、最初のアノテーション追加時に
  挙動を検証し、運用ルール（トップレベル関数・非 Freezed クラスに付ける等）を決める
- **gate の blocking 化**: リンクグラフが十分密になり違反が稀になった時点で、
  `related-gate-report` を informational から required に昇格するか判断する
