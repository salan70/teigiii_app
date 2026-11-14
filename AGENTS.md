# AGENTS.md

teigiii プロジェクトのモノレポ。Claude Code / Codex / Cursor 共通の入口で、`CLAUDE.md` は置かない。
指示の優先順位は、ユーザーの指示、この文書、Skill の順とする。

- `mobile_app/`: Flutter / Dart アプリ（teigi_app、iOS / Android）。Riverpod、Freezed、auto_route
- `backend/`: Cloudflare Workers API。Hono、Drizzle、D1
- ルート: Nix flake、Just、DocBridge、CI、AI 資産

各ディレクトリの作業では `mobile_app/AGENTS.md` と `backend/AGENTS.md` も読む。

## 参照地図

| 文書 | いつ読むか |
| --- | --- |
| `doc/architecture.md` | `mobile_app/` のレイヤー配置を判断する前 |
| `doc/specs/README.md` | 仕様の一覧を確認する。個別仕様はここから辿る |
| `doc/specs/mobile-app-design-system.md` | Ds のコンポーネントとトークンを扱う前 |
| `doc/specs/workers-api-server.md` | backend の API を追加・変更する前 |
| `doc/ios-physical-device-debug.md` | iOS 実機で動作確認する前 |
| `doc/pstack.md` | pstack の導入範囲、上書き、更新手順を確認する前 |

## コマンド

`just setup`、`just analyze`、`just format`、`just test`、`just mobile-generate`、`just docbridge-check`。
clone 後に `just install-git-hooks` を 1 回実行する。共通の検査は `.githooks/pre-commit` と CI が担う。

## エージェントの運用

- 複数段階の作業は `.claude/rules/pstack.md` と `.claude/rules/pstack-models.md` に従う。`python3 tool/pstack/pstack.py models show` が git 管理外の上書きを出す。
- 作業は Issue から始め、1 Issue = 1 ブランチ = 1 PR とする。ブランチ、commit、PR、merge の規則は `.claude/rules/pstack.md` の Git and PRs に従う。
- `mobile_app/` の UI の実装・変更は `implementing-ui-with-design-system` を使う。
- 指示の正本はこのファイル。Skill は `.claude/skills/` に置き、Codex と Cursor は `.agents/skills` のリンクで同じものを読む。
- pstack から取り込んだファイルは直接編集しない。変更は `tool/pstack/overlays/` に書いて `sync` する。
- `docbridge` Skill は DocBridge が管理する。版を上げたら `bunx docbridge@<版> upgrade --force` で入れ替える。
- 依頼スコープ外の改善と、将来の仮想要件に備えたコードは書かない。

## 文章

- 結論と必要な行動を先に書く。賛辞と感情的な共感は書かない。
- 静的な Markdown は 1 文 1 行で書く。日本語と英数字やインラインコードの間には半角スペースを入れる。
- 計画は `doc/plans/YYYY-MM-DD-{slug}.md` に置き、完了したら `doc/plans/done/` へ移す。

## Cursor Cloud

- Nix を使わない。`bun`、`flutter`、`dart`、`just` は snapshot に入っている。
- `mobile_app/.env` は必須アセットで、無いと `flutter test` が失敗する。update script が自動生成する。
- backend の API は Firebase App Check が必須で、生 curl は 401 になる。検証は `just backend-test` で行う。
- 実機、エミュレータ、iOS シミュレータが無く、`flutter run` は使えない。lint、test、codegen だけ実行する。
