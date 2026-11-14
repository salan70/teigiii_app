# pstack の運用

公式の [pstack](https://github.com/cursor/plugins/tree/main/pstack) を固定版で取り込み、中核の Skill だけをリポジトリに置く。
作業の入口は [AGENTS.md](../AGENTS.md) の「エージェントの運用」に従う。

## 取り込んだもの

| 種類 | 置き場所 | 内容 |
| --- | --- | --- |
| 入口 | `.claude/skills/poteto-mode/` | 作業を Playbook へ振り分け、Principle の索引を持つ。Playbook 23 本 |
| Principle | `.claude/skills/principle-*/` | 24 個。判断を変えた Principle の名前を返答に書く |
| 作業の Skill | `.claude/skills/` | how、why、architect、interrogate、blast-radius、swarm、tdd、correct、no-comments、setup-pstack |
| 委譲の agent | `.claude/agents/` | `poteto-agent`、`comment-sicko` |
| モデルの割り当て | `.claude/rules/pstack-models.md` | 役割ごとの格と、provider ごとの格に対応するモデル |
| 上流の資料 | `tool/pstack/upstream/` | 導入ガイド、Claude Code の対応表、README、MIT LICENSE |

上流の本文は英語のまま変えない。
arena、reflect、recall、statechart など、上に挙げていない Skill は取り込まない。
`poteto-mode/scripts/` は bun に依存するため取り込まない。
必要になった Skill は、`tool/pstack/manifest.json` の `install` に上流のディレクトリと取り込み先を足し、`sync` で取得する。

## 読み込まれる経路

| 環境 | 経路 |
| --- | --- |
| Claude Code | `.claude/rules/pstack.md` と `pstack-models.md` を毎回読み込み、SessionStart hook（`.claude/settings.json`）がモデルの上書きを足す |
| Codex | [AGENTS.md](../AGENTS.md) から読む。Skill は `.agents/skills` のリンクから見える |
| Cursor | `.cursor/rules/pstack.mdc` から読む。Skill は `.agents/skills` のリンクから見える |

## プロジェクトの上書き

上流の本文は書き換えず、2 段の上書きで直す。

1. `.claude/rules/pstack.md` に、すべての pstack の Skill に共通する規則（パス、モデル、Git、委譲の費用）を置く。
2. 特定の手順を置き換える Skill には、`tool/pstack/overlays/` の原本を `sync` が本文の末尾に付ける。

| 原本 | 主な内容 |
| --- | --- |
| `poteto-mode.md` | architect と interrogate の起動条件を絞る。PR、Playbook、中断と再開をこのリポジトリの手順に合わせる |
| `setup-pstack.md` | 書き込み先をリポジトリ内にし、Claude と GPT のモデルで割り当てる |
| `swarm.md` | cloud agent を使わず、ローカルで最小の数だけ起動する |
| `no-comments.md`、`comment-sicko.md` | 比較の基準を develop にし、日本語のコメントを扱う |
| `why.md` | 使える情報源を git と GitHub に限る |
| `poteto-agent.md` | poteto-mode の場所を示す |

優先順位は、[AGENTS.md](../AGENTS.md) と利用者の CLAUDE.md が最も高く、次に `.claude/rules/pstack.md` と overlay、最後に上流の本文とする。

## モデルの割り当て

コミットする既定は provider を問わない形にし、日々の切り替えは git 管理外の上書きで行う。
provider は、スレッドを始めたモデルの provider を既定にする。もう一方は、利用者が会話で指示したときと、上書きで `provider` か `cross-provider: on` を指定したときだけ使う。
優先順位は、会話中の利用者の指示、上書き、コミットした既定の順とする。

| 置き場所 | 内容 | 変える頻度 |
| --- | --- | --- |
| `.claude/rules/pstack-models.md` | 役割ごとの格（`top`、`impl`、`mid`、`cheap`）と、provider ごとの格に対応するモデル | まれ。PR で変える |
| git の共通ディレクトリの `pstack-models.local.md` | 既定を上書きする行。git 管理外で、全 worktree が共有する | 随時。コミットしない |

Claude Code は SessionStart hook でセッションの開始ごとに、モデル表と上書きを表示する。
Codex と Cursor は `python3 tool/pstack/pstack.py models show` を実行して読む。
上書きは次のコマンドで 1 行ずつ書き換える。

```bash
python3 tool/pstack/pstack.py models path
python3 tool/pstack/pstack.py models set provider codex
python3 tool/pstack/pstack.py models set small edits codex:luna high
```

既定を変えるときは `setup-pstack` を実行するか、`pstack-models.md` を直接直す。

## 照合と更新

リポジトリのルートで実行する。

```bash
python3 tool/pstack/pstack.py status
python3 tool/pstack/pstack.py sync
python3 -m unittest tool.pstack.test_pstack
```

`status` は、取り込んだファイルから上書きを外して上流の SHA256 と照合する。
manifest にないファイルが取り込み先にあれば、それも異常として返す。
overlay の原本を変えたら `sync` を実行し、取り込み先に反映する。

上流を更新するときは、候補の commit を決めてから次を実行し、手動で更新する。

```bash
python3 tool/pstack/pstack.py propose-update --pin <40桁のcommit> --output <候補の出力先>
git diff --no-index tool/pstack/manifest.json <候補の出力先>
```

追加、削除、変更されたファイルの一覧と、本文の差分、ライセンス、overlay との食い違いを確認する。
問題がなければ候補を `manifest.json` に置き換えて `sync` を実行し、`status` とテストを通してから commit する。
