# UI レビュー用カタログ

画面と Ds コンポーネントの各状態を撮影し、1 つのサイトに並べる。
UI レビューはこのカタログをブラウザで見て行う。
UI を変えたエージェントも、該当する対象を撮り直して確認する。

## 日常の使い方

コマンドはリポジトリのルートで、`nix develop` の中（direnv 済みなら通常のシェル）から実行する。

```bash
just ui-review list                              # 対象と状態の一覧
just ui-review capture --all                     # 全対象を撮る（約 20 秒）
just ui-review capture --only screen.home        # 指定した対象だけ撮り直す（カンマ区切りで複数）
just ui-review serve                             # http://127.0.0.1:8343/ で確認する
```

出力は `artifacts/ui-review/` で、Git 管理外である。
`--only` は指定した対象だけを撮り直し、ほかの対象の結果は残す。
撮るたびに `index.html` と対象ごとのページを作り直す。

UI を変えたら、変えた画面とコンポーネントの ID を `--only` に渡して撮り直し、`serve` で見た目を確かめる。
一覧の「警告ありだけ」で、描画中に出た警告（はみ出しなど）を拾える。

## 撮影の仕組み

- 対象、状態、撮影条件は `mobile_app/tool/ui_review/targets.json` に書く。
- 画面の状態は `screens.dart`、コンポーネントの状態は `components.dart` に、同じ ID で登録する。
- 画面は widget test の中で provider を差し替えて、通常、空、読み込み中、エラーを作る。差し替えに使う fake と固定データは `fixtures.dart` にある。
- 撮影は `capture_test.dart` が行う。アプリのフォント（LINE Seed JP）とアイコンのフォントを読み込むので、文字とアイコンが四角にならない。
- 条件はライト、ダーク、幅 360、文字 1.5 倍の 4 つ（`targets.json` の `variants`）。ロケールは ja、画素密度は 2 倍である。

## 対象を追加する

1. `targets.json` に対象と状態を足す。
2. `screens.dart` か `components.dart` に、同じ ID の状態を足す。
3. `just ui-review capture --only <ID>` で撮り、結果を確かめる。

`targets.json` にあって登録のない状態は「未登録」として結果に出る。
画面か Ds コンポーネントを新設したら、対象に加えるか、`excluded` に理由を書く。

## 載せていない対象

`targets.json` の `excluded` に理由とともに列挙している。
一覧ページの末尾にも同じ内容が出る。

## 既知の制限

- 文中の絵文字は四角で描かれる。絵文字のフォントを読み込んでいないためである。
- ネットワーク画像は使わない。アバターは既定の画像で描く。
- 実機とシミュレータでの撮影、画像の差分による自動判定はしない。

## Widgetbook

操作して確かめたいときは、同じサイトの `/widgetbook/` を使う。
`just deploy-ui-review` が、撮影のあとに Web ビルドを載せる。
手元で載せるだけなら `just ui-review widgetbook` を実行する。
`widgetbook` は、ビルドの間だけ `mobile_app/.env` をプレースホルダに替え、終わると元に戻す。
手元の広告 ID や Firebase の値を、公開する成果物に入れないためである。
撮影は日付の表示がずれないよう、`TZ=Asia/Tokyo` で `flutter test` を実行する。
保守が負担になったら Widgetbook を廃止し、カタログに一本化する。

ツール自体（Python）の単体テストは次で実行する。

```bash
just ui-review-test
```

## 公開

公開先は `https://teigiii-ui.oda79.me/` である。
`oda79.me` の 1 階層下にしているのは、2 階層のホスト名が Universal SSL の対象外になるためである。

```bash
just deploy-ui-review    # capture --all → widgetbook → publish
```

`publish` は、Cloudflare Access の self-hosted アプリがこのホスト名にあり、利用者を絞った allow の policy（include が空でなく、`everyone` を含まない）を持つことを API で確かめてから、`wrangler deploy` を呼ぶ。
確かめられないときは、配らずに止まる。
配る中身は `wrangler.jsonc` の `assets.directory`（`artifacts/ui-review/`）で決まるので、`publish` に `--out` はない。
`workers.dev` とプレビュー URL は無効にしてある（`wrangler.jsonc`）。

### 初回の準備（Cloudflare 側）

次の設定は `just deploy-ui-review` を初めて実行する前に、1 度だけ行う。

1. `oda79.me` のゾーンがあるアカウントで、Zero Trust の Access アプリ（self-hosted）を `teigiii-ui.oda79.me` に作る。
2. そのアプリに、見られる利用者のメールアドレスを許可する allow の policy を付ける。
3. API トークンを作る。権限は Workers Scripts の編集、Access のアプリとポリシーの読み取り、アカウントの読み取り、`oda79.me` のゾーンの読み取りと Workers Routes の編集（カスタムドメイン用）を含める。
4. トークンを `CLOUDFLARE_API_TOKEN` に入れるか、macOS のキーチェーンに保存する。

```bash
security add-generic-password -s cloudflare-ui-review -a "$USER" -w
```

アカウントが複数あるときは `CLOUDFLARE_ACCOUNT_ID` も指定する。

初回の deploy のあと、未認証のブラウザで `https://teigiii-ui.oda79.me/` を開き、Access のログイン画面に遷移することを確かめる。

設定を確かめるだけなら、`just ui-review publish --dry-run` が使える（Access の確認と deploy はしない）。

### 自動化

まず手動の `just deploy-ui-review` で運用する。
安定したら、`develop` への push で自動に deploy する。
