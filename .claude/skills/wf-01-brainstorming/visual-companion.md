# ビジュアルコンパニオンガイド

ブレインストーミング中にモックアップ、図、オプションを表示するためのブラウザベースのビジュアルコンパニオン。

## 使用するタイミング

セッション単位ではなく質問単位で判断します。基準: **見た方が読むより理解しやすいか？**

**ブラウザを使用** — コンテンツ自体がビジュアルな場合:

- **UI モックアップ** — ワイヤーフレーム、レイアウト、ナビゲーション構造、コンポーネントデザイン
- **アーキテクチャ図** — システムコンポーネント、データフロー、関連図
- **ビジュアルの並列比較** — 2 つのレイアウト、配色、デザイン方向性の比較
- **デザインの洗練** — 見た目、間隔、ビジュアル階層に関する質問
- **空間的な関係** — ステートマシン、フローチャート、ER 図を図として描画

**ターミナルを使用** — コンテンツがテキストまたは表形式の場合:

- **要件とスコープの質問** — 「X とは何か？」「どの機能がスコープ内か？」
- **概念的な A/B/C の選択** — 言葉で説明されるアプローチから選ぶ
- **トレードオフリスト** — メリット・デメリット、比較表
- **技術的な判断** — API 設計、データモデリング、アーキテクチャのアプローチ選択
- **確認質問** — 答えが言葉であり、ビジュアルの好みではないもの

UI に関する質問が自動的にビジュアルの質問になるわけではありません。「どんなウィザードが欲しい？」は概念的 — ターミナルを使用。「どちらのウィザードレイアウトがしっくりくる？」はビジュアル — ブラウザを使用。

## 仕組み

サーバーがディレクトリ内の HTML ファイルを監視し、最新のファイルをブラウザに配信します。あなたが HTML コンテンツを書くと、ユーザーはブラウザでそれを見てクリックでオプションを選択できます。選択は `.events` ファイルに記録され、次のターンであなたが読み取ります。

**コンテンツフラグメント vs 完全なドキュメント:** HTML ファイルが `<!DOCTYPE` または `<html` で始まる場合、サーバーはそのまま配信します（ヘルパースクリプトのみ注入）。それ以外の場合、サーバーは自動的にフレームテンプレートでラップし、ヘッダー、CSS テーマ、選択インジケーター、すべてのインタラクティブインフラを追加します。**デフォルトではコンテンツフラグメントを書いてください。** ページの完全な制御が必要な場合のみ完全なドキュメントを書きます。

## セッションの開始

```bash
# 永続化付きでサーバーを起動（モックアップはプロジェクトに保存）
scripts/start-server.sh --project-dir /path/to/project

# 戻り値: {"type":"server-started","port":52341,"url":"http://localhost:52341",
#           "screen_dir":"/path/to/project/.superpowers/brainstorm/12345-1706000000"}
```

レスポンスの `screen_dir` を保存してください。ユーザーに URL を開くよう伝えます。

**接続情報の確認:** サーバーは起動 JSON を `$SCREEN_DIR/.server-info` に書き込みます。バックグラウンドでサーバーを起動して stdout をキャプチャしなかった場合、そのファイルを読んで URL とポートを取得してください。`--project-dir` を使用した場合は `<project>/.superpowers/brainstorm/` でセッションディレクトリを確認してください。

**注意:** `--project-dir` にプロジェクトルートを渡すと、モックアップファイルが `.superpowers/brainstorm/` に永続化され、サーバー再起動後も残ります。指定しない場合、ファイルは `/tmp` に置かれ、停止時に削除されます。まだ追加されていなければ `.superpowers/` を `.gitignore` に追加するようユーザーに伝えてください。

**プラットフォーム別のサーバー起動:**

**Claude Code (macOS / Linux):**
```bash
# デフォルトモードで動作 — スクリプト自体がサーバーをバックグラウンド化
scripts/start-server.sh --project-dir /path/to/project
```

**Claude Code (Windows):**
```bash
# Windows は自動検出でフォアグラウンドモードを使用し、ツール呼び出しをブロックします。
# サーバーが会話ターンをまたいで生存するよう、Bash ツール呼び出しで run_in_background: true を設定してください。
scripts/start-server.sh --project-dir /path/to/project
```
Bash ツール経由で呼び出す際は `run_in_background: true` を設定してください。次のターンで `$SCREEN_DIR/.server-info` を読んで URL とポートを取得します。

**Codex:**
```bash
# Codex はバックグラウンドプロセスを回収します。スクリプトは CODEX_CI を自動検出して
# フォアグラウンドモードに切り替えます。通常どおり実行してください — 追加フラグは不要です。
scripts/start-server.sh --project-dir /path/to/project
```

**Gemini CLI:**
```bash
# --foreground を使用し、シェルツール呼び出しで is_background: true を設定して
# プロセスがターンをまたいで生存するようにしてください
scripts/start-server.sh --project-dir /path/to/project --foreground
```

**その他の環境:** サーバーは会話ターンをまたいでバックグラウンドで実行し続ける必要があります。環境がデタッチされたプロセスを回収する場合は `--foreground` を使用し、プラットフォームのバックグラウンド実行メカニズムでコマンドを起動してください。

ブラウザから URL に到達できない場合（リモート/コンテナ環境で一般的）、ループバック以外のホストをバインドしてください:

```bash
scripts/start-server.sh \
  --project-dir /path/to/project \
  --host 0.0.0.0 \
  --url-host localhost
```

`--url-host` で返される URL JSON に表示されるホスト名を制御します。

## ループ

1. **サーバーの生存を確認**し、`screen_dir` 内の新しいファイルに **HTML を書き込む**:
   - 書き込みの前に毎回 `$SCREEN_DIR/.server-info` の存在を確認。存在しない場合（または `.server-stopped` が存在する場合）、サーバーは停止しています — 続行前に `start-server.sh` で再起動してください。サーバーは 30 分間の非アクティブ後に自動終了します。
   - セマンティックなファイル名を使用: `platform.html`、`visual-style.html`、`layout.html`
   - **ファイル名は再利用しない** — 各画面は新しいファイル
   - Write ツールを使用 — **cat/heredoc は使わない**（ターミナルにノイズが出力される）
   - サーバーは自動的に最新のファイルを配信

2. **ユーザーに期待する内容を伝えてターンを終了:**
   - URL を毎回リマインド（最初だけでなく毎ステップ）
   - 画面の内容を簡潔に説明（例: 「ホームページの 3 つのレイアウトオプションを表示しています」）
   - ターミナルで回答するよう依頼: 「ご確認の上、感想をお聞かせください。オプションをクリックで選択することもできます。」

3. **次のターン** — ユーザーがターミナルで回答した後:
   - `$SCREEN_DIR/.events` が存在すれば読み取る — ユーザーのブラウザ操作（クリック、選択）が JSON 行として記録されている
   - ユーザーのターミナルテキストと統合して全体像を把握
   - ターミナルメッセージが主要なフィードバック。`.events` は構造化された操作データを提供

4. **反復または前進** — フィードバックが現在の画面を変更する場合は新しいファイルを書く（例: `layout-v2.html`）。現在のステップが検証されてから次の質問に進む。

5. **ターミナルに戻る際はアンロード** — 次のステップでブラウザが不要な場合（例: 確認質問、トレードオフの議論）、古いコンテンツをクリアするために待機画面をプッシュ:

   ```html
   <!-- filename: waiting.html (or waiting-2.html, etc.) -->
   <div style="display:flex;align-items:center;justify-content:center;min-height:60vh">
     <p class="subtitle">ターミナルで続行中...</p>
   </div>
   ```

   これにより、会話が進んでいるのに解決済みの選択肢を見続けることを防ぎます。次のビジュアルの質問が出てきたら、通常どおり新しいコンテンツファイルをプッシュします。

6. 完了まで繰り返す。

## コンテンツフラグメントの書き方

ページ内に入るコンテンツだけを書いてください。サーバーが自動的にフレームテンプレート（ヘッダー、テーマ CSS、選択インジケーター、すべてのインタラクティブインフラ）でラップします。

**最小限の例:**

```html
<h2>どちらのレイアウトが良いですか？</h2>
<p class="subtitle">読みやすさとビジュアル階層を考慮してください</p>

<div class="options">
  <div class="option" data-choice="a" onclick="toggleSelect(this)">
    <div class="letter">A</div>
    <div class="content">
      <h3>シングルカラム</h3>
      <p>クリーンで集中的な読書体験</p>
    </div>
  </div>
  <div class="option" data-choice="b" onclick="toggleSelect(this)">
    <div class="letter">B</div>
    <div class="content">
      <h3>2 カラム</h3>
      <p>サイドバーナビゲーション付きメインコンテンツ</p>
    </div>
  </div>
</div>
```

これだけです。`<html>`、CSS、`<script>` タグは不要です。サーバーがすべて提供します。

## 利用可能な CSS クラス

フレームテンプレートは以下の CSS クラスを提供します:

### オプション (A/B/C の選択肢)

```html
<div class="options">
  <div class="option" data-choice="a" onclick="toggleSelect(this)">
    <div class="letter">A</div>
    <div class="content">
      <h3>タイトル</h3>
      <p>説明</p>
    </div>
  </div>
</div>
```

**複数選択:** コンテナに `data-multiselect` を追加すると、ユーザーが複数のオプションを選択できます。クリックするたびに項目がトグルされます。インジケーターバーに選択数が表示されます。

```html
<div class="options" data-multiselect>
  <!-- 同じオプションマークアップ — ユーザーが複数を選択/解除可能 -->
</div>
```

### カード (ビジュアルデザイン)

```html
<div class="cards">
  <div class="card" data-choice="design1" onclick="toggleSelect(this)">
    <div class="card-image"><!-- モックアップコンテンツ --></div>
    <div class="card-body">
      <h3>名前</h3>
      <p>説明</p>
    </div>
  </div>
</div>
```

### モックアップコンテナ

```html
<div class="mockup">
  <div class="mockup-header">プレビュー: ダッシュボードレイアウト</div>
  <div class="mockup-body"><!-- モックアップ HTML --></div>
</div>
```

### 分割ビュー (左右並列)

```html
<div class="split">
  <div class="mockup"><!-- 左 --></div>
  <div class="mockup"><!-- 右 --></div>
</div>
```

### メリット/デメリット

```html
<div class="pros-cons">
  <div class="pros"><h4>メリット</h4><ul><li>利点</li></ul></div>
  <div class="cons"><h4>デメリット</h4><ul><li>欠点</li></ul></div>
</div>
```

### モック要素 (ワイヤーフレームの構成要素)

```html
<div class="mock-nav">Logo | Home | About | Contact</div>
<div style="display: flex;">
  <div class="mock-sidebar">ナビゲーション</div>
  <div class="mock-content">メインコンテンツエリア</div>
</div>
<button class="mock-button">アクションボタン</button>
<input class="mock-input" placeholder="入力フィールド">
<div class="placeholder">プレースホルダーエリア</div>
```

### タイポグラフィとセクション

- `h2` — ページタイトル
- `h3` — セクション見出し
- `.subtitle` — タイトル下の補助テキスト
- `.section` — 下マージン付きコンテンツブロック
- `.label` — 小さい大文字のラベルテキスト

## ブラウザイベントのフォーマット

ユーザーがブラウザでオプションをクリックすると、操作が `$SCREEN_DIR/.events` に記録されます（1 行 1 JSON オブジェクト）。新しい画面をプッシュするとファイルは自動的にクリアされます。

```jsonl
{"type":"click","choice":"a","text":"Option A - Simple Layout","timestamp":1706000101}
{"type":"click","choice":"c","text":"Option C - Complex Grid","timestamp":1706000108}
{"type":"click","choice":"b","text":"Option B - Hybrid","timestamp":1706000115}
```

完全なイベントストリームはユーザーの探索パスを示します — 決定前に複数のオプションをクリックすることがあります。最後の `choice` イベントが通常は最終選択ですが、クリックのパターンから迷いや好みが読み取れ、質問する価値があるかもしれません。

`.events` が存在しない場合、ユーザーはブラウザを操作していません — ターミナルテキストのみを使用してください。

## デザインのコツ

- **質問に応じて忠実度を調整** — レイアウトの質問にはワイヤーフレーム、洗練の質問には洗練されたデザイン
- **各ページで質問を説明** — 「どちらが選びますか」ではなく「どちらのレイアウトがよりプロフェッショナルに感じますか？」
- **前進する前に反復** — フィードバックが現在の画面を変更するなら新しいバージョンを書く
- **1 画面あたり 2〜4 オプション**まで
- **重要な場合は実際のコンテンツを使用** — 写真ポートフォリオなら実際の画像（Unsplash）を使う。プレースホルダーコンテンツはデザインの問題を隠す。
- **モックアップはシンプルに** — レイアウトと構造に集中し、ピクセルパーフェクトなデザインは不要

## ファイル命名

- セマンティックな名前を使用: `platform.html`、`visual-style.html`、`layout.html`
- ファイル名は再利用しない — 各画面は新しいファイル
- 反復用: バージョンサフィックスを追加 `layout-v2.html`、`layout-v3.html`
- サーバーは変更時刻が最新のファイルを配信

## クリーンアップ

```bash
scripts/stop-server.sh $SCREEN_DIR
```

セッションで `--project-dir` を使用した場合、モックアップファイルは `.superpowers/brainstorm/` に残り、後で参照できます。`/tmp` セッションのみ停止時に削除されます。

## リファレンス

- フレームテンプレート (CSS リファレンス): `scripts/frame-template.html`
- ヘルパースクリプト (クライアントサイド): `scripts/helper.js`
