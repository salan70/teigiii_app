---
name: analyzing-app-performance
description: 本番アプリのフレーム計測テレメトリを CLI で取得し、画面別ジャンク率やビルド間比較の所見を返す。パフォーマンス悪化の確認、リリース前後の比較、frame_stats の分析を依頼された時に使用する。
---

# アプリパフォーマンス分析

本番 `TELEMETRY_DB`（`teigiii-telemetry-prod`）に蓄積された画面別フレーム統計を、**ダッシュボードなし**で CLI + この skill から読む。

**主導線は `just perf-report`。** `just perf-query` は明示的な手動調査専用。分析タスクに raw SQL を使わない。

## 前提

1. ローカル環境に `CLOUDFLARE_API_TOKEN` を置く（リポジトリにコミットしない）
2. トークン権限は **D1 Read のみ**（Account → D1 → Read）。Write / Edit は付けない
3. 対象 DB は prod の `TELEMETRY_DB`（`teigiii-telemetry-prod`）

発行手順（Cloudflare Dashboard）:

1. My Profile → API Tokens → Create Token
2. Custom token。Permission: `Account` / `D1` / `Read`
3. Account Resources でこのアカウントを選択
4. 発行した値を shell だけに export する（例: `export CLOUDFLARE_API_TOKEN=...`）

検証:

```bash
just perf-query 'SELECT COUNT(*) AS n FROM frame_stats'
# 成功すること

# mutation は perf-query 側で弾かれる（多層防御）
just perf-query "INSERT INTO frame_stats (id) VALUES ('x')"
# "Only SELECT/WITH queries are allowed" で失敗すること

# トークン自体が D1 Read のみであることの確認（wrangler 直叩き）
cd backend && bunx wrangler d1 execute TELEMETRY_DB --env prod --remote --command "INSERT INTO frame_stats (id) VALUES ('x')"
# 権限エラーになること（構文エラーではなく permission / auth 系）
```


## コマンド

```bash
# AI 主導線。任意で build_number を渡して絞り込み
just perf-report
just perf-report 42

# 手動調査のみ
just perf-query 'SELECT screen_name, COUNT(*) AS n FROM frame_stats GROUP BY 1'
```

`perf-report` の JSON には次が含まれる:

| セクション | 内容 |
|---|---|
| `byScreen` | 画面別の slow build / slow raster / frozen 率とサンプル数 |
| `versionComparison` | `platform + flavor` ごとの最新 vs 直前 `build_number` 比較（`build_number` 指定時はその値を latest に固定） |
| `byDevice` | 端末モデル別内訳 |
| `byRefreshRate` | リフレッシュレート別内訳 |

各集計には必ず `sessionCount` と `frameCount` がある。比率だけを見て判断しない。

`build_number` 無指定の `byScreen` / `byDevice` / `byRefreshRate` は、リテンション期間内の **全 build / 全 platform を混ぜた集計**になる。回帰判定には使わず、`versionComparison` か `just perf-report <build_number>` を使う。

## スキーマ（`frame_stats`）

1 行 = 1 セッション × 1 画面。正本は `backend/src/db/telemetry-schema.ts`。

| 列 | 意味 |
|---|---|
| `session_id` | 端末セッションの使い捨て ID（利用者と紐づけない） |
| `screen_name` | 画面名 |
| `build_number` | 数値。**新旧判定はこの列**（`app_version` 文字列順は使わない） |
| `platform` / `flavor` | iOS/Android と dev/prod など |
| `refresh_rate_hz` | 端末リフレッシュレート。slow 判定予算の元 |
| `frame_count` | フレーム総数（分母） |
| `slow_build_count` | buildDuration が予算超 |
| `slow_raster_count` | rasterDuration が予算超 |
| `frozen_count` | totalSpan > 700ms |
| `recorded_at` | クライアント計測時刻 |
| `created_at` | サーバー受信時刻（リテンション基準） |

`user_id` もパーセンタイル列もない。

## 解釈基準

### サンプル数

個人アプリは低トラフィック。次を満たさない画面・strata は **「悪化」と断定しない**。

- 目安: `sessionCount < 5` または `frameCount < 1000` は所見で「サンプル不足」と明記する
- 比率が高くても分母が小さい行は外れ値扱いにする

### build 系と raster 系

| 指標 | 示唆 |
|---|---|
| `slowBuildRate` が高い | Dart 側の再構築・レイアウトが重い |
| `slowRasterRate` が高い | GPU / 描画（過剰な影、巨大画像、ネイティブビュー等）が重い |
| `frozenRate` が高い | 700ms 超の長時間フレーム（同期ブロック等） |

Phase 0 系のリスト構造問題の再発は、主に **build 側**に出やすい。

### バージョン比較

- 新旧は **`platform + flavor` ごとに数値 `build_number`** で決める
- `app_version` の辞書順比較は禁止（`2.10.0 < 2.9.0` になる）
- `just perf-report <build_number>` では、その値が latest 側に固定され、直前はそれより小さい最大値
- `previousBuildNumber: null` は「直前ビルド自体が無い」。直前ビルドはあるが当該画面が未観測のときは `previousBuildNumber` は埋まり、`previous.frameCount === 0`
- 行は latest 側の画面が起点。**直前にあって最新で消えた画面はレポートに出ない**（画面消失自体は別途 `perf-query` で確認）
- 比較対象の両側に十分なサンプルがあること。片側不足なら比較を保留する
- 端末構成比（60Hz / 120Hz）の変化だけで率が動く点に注意。厳密な回帰判定は Phase 3（層別化）の役割

### この skill でやらないこと

- 原因特定の断定（本番テレメトリは回帰検知用。原因はローカル profile + DevTools）
- raw SQL の乱用（`perf-query`）
- ダッシュボード構築
- 本番 D1 への書き込み

## 手順

1. `CLOUDFLARE_API_TOKEN` があることを確認する
2. `just perf-report`（必要なら対象 `build_number` 付き）を実行する
3. JSON を読み、サンプル不足の行を除外してから所見を書く
4. 所見には必ず画面名、比較した `build_number`、`sessionCount` / `frameCount`、build vs raster のどちらが動いたかを含める
5. 追加の切り口が必要なときだけ、ユーザーに確認したうえで `perf-query` を使う

クライアント契約の正本: `doc/specs/app-performance-telemetry.md`  
サーバー側: `doc/specs/workers-api-server.md` の「フレーム計測テレメトリ」
