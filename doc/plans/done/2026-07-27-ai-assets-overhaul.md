# AI assets の整理と導線整備（#286）

## 目的

AI assets（CLAUDE.md / AGENTS.md / skills / hooks）から死んだ参照と機能していない仕組みを排除し、既存ドキュメントへの導線を通す。詳細な問題一覧と決定事項は #286 を参照。

## 実行手順

### 1. フックの削除と修復

**削除するフック**（Claude / Codex 両方）:

- `session-start.sh` — 存在しない `wf-01-brainstorming` を読んでおり、注入自体も効いていない
- `stop-instinct-collect.sh` — 存在しない `/learn` を促す
- `session-reflect-reminder.sh` — 存在しない `/session-reflect` を促し、完了報告のたびに block する

対象ファイル: `.claude/hooks/{session-start,stop-instinct-collect,session-reflect-reminder}.sh`、`.codex/hooks/` の同名 3 つ。

**設定の更新**:

- `.claude/settings.json` — `SessionStart` ブロックごと削除、`Stop` から instinct / reflect の 2 エントリを削除
- `.codex/hooks.json` — 同様

**auto-format の修復**（`post-tool-use-auto-format.sh`、Claude / Codex 両方）:

- `dart` → `dart format "$file_path"`
- `ts|js|tsx|jsx` → `cd backend && bunx oxfmt "$file_path"`（`bun run format` と同じフォーマッタ）
- `md` / `swift` の分岐は実体が無いので削除
- 失敗を `|| true` で握り潰さない。現行スクリプトは末尾が無条件 `exit 0` のため、`|| true` を外すだけでは成功終了のままになる。フォーマッタが見つからない・失敗した場合は stderr に理由を出し、**exit 2** で終える（PostToolUse では exit 2 の stderr がエージェントに渡る。exit 1 はユーザー表示のみでエージェントが気づけない）

**Codex 側フックの契約**（`.codex/hooks.json` と `.codex/hooks/`）:

- `.codex/hooks.json` のコマンドが `/Users/odatetsuo/...` の絶対パス直書きになっており、別 checkout や Cloud 環境で壊れる。`bash "$(git rev-parse --show-toplevel)/.codex/hooks/<name>.sh"` 形式に置き換える
- 残すフックの「動作確認済み」は Claude 側で JSON を投入した範囲の話であり、Codex 実セッションでは未検証。`~/.codex/config.toml` に本リポジトリの `.codex/hooks.json` が `pre_tool_use` / `post_tool_use` / `session_start` / `stop` として登録されていること、および docbridge の Codex 版フックも `Edit|MultiEdit|Write` マッチャを使っていることは確認済みだが、`tool_name` の実値までは未確認
- したがって完了条件に「Codex 実セッションで `.ts` と `.dart` を 1 つずつ編集し、auto-format と docbridge-context が実際に発火する」E2E 検証を含める。発火しない場合は matcher と `tool_name` 判定を Codex の実値に合わせて修正する（発火しないことが確定するまで Codex 側フックの廃止は判断しない）

**残すフック**: `pre-tool-use-push-reminder.sh` / `post-tool-use-docbridge-context.sh` / `stop-debug-code-detect.sh` / `stop-docbridge-related-gate.sh`（Claude 側は JSON 投入で動作確認済み、Codex 側は上記 E2E で確認する）

### 2. メモリのネイティブ一本化

- `.claude/skills/managing-agent-memory/` と `.agents/skills/managing-agent-memory/` を削除
- `memories/ios-physical-debug/2026-07-22-summary.md` の内容を確認し、`doc/ios-physical-device-debug.md` に無い知見があれば移し、無ければ破棄したうえで `memories/` を削除
- `.gitignore:71` の `memories/` 行を削除
- `.claude/skills/continuous-learning/` と `.agents/skills/continuous-learning/` を削除（`/learn` 廃止に伴い受け皿が不要）

### 3. Codex スキルの絞り込み

`.agents/skills/` を次の 9 つに限定し、他は削除する:

git-operations / collaborating-on-github / implementing-ui-with-design-system / test-driven-development / systematic-debugging / receiving-code-review / refactoring-code / docbridge-sync / docbridge-annotate

削除対象: continuous-learning / managing-agent-memory / dispatching-parallel-agents / grilling / maintaining-ai-docs / syncing-ai-assets / porting-ai-assets-to-codex / docbridge-adopt / docbridge-link / docbridge-review

残す 9 つに `.Codex/` 等の存在しないパス参照が無いことを `rg` で確認する。

**運用記載の宛先を分ける**（現行 AGENTS.md:58 は Codex が持たないスキルの使用を Codex に指示していて成立しない）:

- CLAUDE.md — Claude 側スキルを追加・更新したら `porting-ai-assets-to-codex` で Codex への反映要否を判断する（移植を実行するのは Claude 側なので記載先はここ）
- AGENTS.md — Codex 側は 9 スキルのサブセットであるという事実のみ記載し、スキル名の指示は書かない

**削除名の全体監査**: 削除する 10 スキル名をリポジトリ全体（`doc/`、ルート md、`justfile`、`.github/`）に `rg` して、Codex から辿れなくなる参照が無いか確認する。`doc/specs/README.md` の `docbridge-link` / `docbridge-annotate` への言及は、Claude 側に両方残るため死んだ参照にはならないが、Codex 側に無いものは「Claude 側のみ」と補記する。`doc/porting-ai-assets-to-codex.md` は移植台帳なので今回の 9 スキル構成に合わせて更新する。

### 4. skill frontmatter の正規化

Claude 側 17 スキルと Codex 側 9 スキルの `SKILL.md` frontmatter を `name` + `description` の 2 キーに統一する。

- `autoInvoke:` / `triggers:` の内容は `description` に統合してからキーを削除する（Claude Code はこの 2 キーを読まないため、発動条件が選択機構に届いていない）
- `description` は「何をするか + いつ使うか（日本語のトリガー語を含む）」の形に揃える
- docbridge-* の英語 description も日本語に書き換える（外部正本由来のため、更新時に再差分が出ることは許容する）

### 5. ドキュメント導線の整備

**`doc/specs/README.md` を仕様一覧の入口にする**

現状は DocBridge の書き方説明のみで索引になっていない。既存の記載は残したうえで、7 本の仕様に「位置づけ」と「いつ読むか」を付けた一覧表を追加する。位置づけは次の 3 分類:

- **現行規範** — 実装が従うべき仕様（design-system / workers-api-server / new-ui-information-architecture / analytics-events）
- **補助資料** — 参考情報（README 自身の規約など）
- **履歴** — 特定時点のスナップショットで、現状とずれうるもの（design-system-audit / legacy-repository-api-mapping）

分類は着手時に各文書の中身を確認して確定する。これにより仕様が増えてもルート md の更新が不要になる。

**ルート md に参照地図を追加**（CLAUDE.md / AGENTS.md 双方に同内容）:

| ドキュメント | いつ読むか |
| --- | --- |
| `doc/architecture.md` | `mobile_app/` のレイヤー配置を判断する前 |
| `doc/specs/README.md` | 仕様の一覧と位置づけを確認する（個別仕様はここから辿る） |
| `doc/specs/mobile-app-design-system.md` | Ds コンポーネント・トークンを扱う前 |
| `doc/specs/workers-api-server.md` | backend の API を追加・変更する前 |
| `doc/ios-physical-device-debug.md` | iOS 実機で動作確認する前 |

**サブディレクトリ md を新設**: `mobile_app/CLAUDE.md`、`mobile_app/AGENTS.md`、`backend/CLAUDE.md`、`backend/AGENTS.md`

各サブ md に書く内容:

- そのディレクトリのレイヤー規約の要点と、詳細の参照先（重複させず参照に留める）
- 検証コマンドの選択規則
  - mobile_app: `just mobile-analyze` / `just mobile-test`、UI 変更時は `just mobile-ds-check`、見た目の変更時は `just mobile-test-golden`、`.dart` 追加・変更時は `just mobile-generate`、仕様と紐づくコード変更時は `just docbridge-check`
  - backend: `just backend-analyze` / `just backend-test`、スキーマ・ルート変更時は `just backend-generate`、`just docbridge-check`

CLAUDE.md / AGENTS.md 本体の重複と完了報告フォーマットは今回変更しない。

### 6. 検証

- `bash -n` で変更した全フックの構文確認
- 各フックに実際の JSON を流して期待どおり動くことを確認（auto-format は `.ts` と `.dart` で実ファイルが整形されること、フォーマッタ失敗時に stderr + exit 2 になること、削除したフックが settings から消えていること）
- `bun -e` で `.claude/settings.json` と `.codex/hooks.json` が妥当な JSON であることを確認
- **Codex 実セッションでの E2E**: `codex exec` で `.ts` と `.dart` を 1 つずつ編集し、auto-format と docbridge-context が実際に発火することを確認する。発火しなければ matcher / `tool_name` 判定を Codex の実値に合わせて修正し、再確認する
- 削除した 10 スキル名をリポジトリ全体に `rg` して、残存参照が無いことを確認
- `just analyze` と `just test`

## コミット分割

1. フック 3 つの削除と設定反映
2. auto-format の修復（終了状態の伝播を含む）
3. Codex フック設定の可搬パス化
4. メモリのネイティブ一本化（スキル 2 つ + `memories/` 削除）
5. Codex スキルの絞り込みと参照監査（`doc/porting-ai-assets-to-codex.md` の更新を含む）
6. frontmatter の正規化
7. ドキュメント導線（`doc/specs/README.md` 索引化 + ルート参照地図 + サブ md 4 つ）

ブランチ: `refactor/286-ai-assets-overhaul`、`develop` ベースで 1 PR（Draft → 検証後 Ready）。

## 完了条件

Issue #286 の受け入れ基準をすべて満たし、この plan を `doc/plans/done/` へ移動していること。
