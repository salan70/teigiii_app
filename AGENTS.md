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
| `doc/guides/ui-review.md` | UI を変えて見た目を確認する前、UI レビュー用カタログ（`just ui-review`）を使う前 |
| `doc/ios-physical-device-debug.md` | iOS 実機で動作確認する前 |
| `doc/pstack.md` | pstack の導入範囲、上書き、更新手順を確認する前 |

## コマンド

- 検証の入口は `just check-changed`（変更範囲）と `just check`（全体）。出力は要約で、全文はログに書かれる。mobile / backend の選択は CI と同じ `.github/changes-filter*.yml` を読む。
- そのほか `just setup`、`just format`、`just mobile-generate`、`just backend-generate`、`just docbridge-check`。
- Git hook は lefthook（`lefthook.yml`）。direnv で Nix の shell に入ると自動で入り、worktree でも効く。pre-commit は整形、`docbridge-check`、Markdown のリンク切れをステージした内容（index）で検査する。pre-push は push 対象が現在の HEAD のときだけ、commit から決めた変更範囲を作業ツリーで検証する。HEAD と違う ref の push は警告して飛ばし、CI に任せる。

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
- ユーザーの主張に誤りがあれば率直に指摘する。不確実な事項は断定せず、確認手段か根拠を示す。
- 静的な Markdown は 1 文 1 行で書く。日本語と英数字やインラインコードの間には半角スペースを入れる。
- 計画は Issue に書き、計画用の文書ファイルは置かない。

## Cursor Cloud

- Nix を使わない。`bun`、`flutter`、`dart`、`just` は snapshot に入っている。
- `mobile_app/.env` は必須アセットで、無いと `flutter test` が失敗する。update script が自動生成する。
- backend の API は Firebase App Check が必須で、生 curl は 401 になる。検証は `just backend-test` で行う。
- 実機、エミュレータ、iOS シミュレータが無く、`flutter run` は使えない。lint、test、codegen だけ実行する。
