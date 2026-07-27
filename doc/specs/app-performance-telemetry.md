# アプリのパフォーマンステレメトリ（クライアント側）

`mobile_app` が画面別のフレーム統計を集計してサーバーへ送るまでの仕様。受信 API・専用 D1・kill switch のサーバー側強制・リテンションは [workers-api-server.md](workers-api-server.md) の「フレーム計測テレメトリ」を正本とする。

## 目的と解像度

用途は**回帰検知と効果検証**であり、原因特定ではない。原因特定はローカル実機の profile ビルド + DevTools の役割で、本番データでは判別できない。

したがって送るのはカウンタだけとし、分布・パーセンタイルは持たない。パーセンタイルは端末ごとに算出しても母集団のパーセンタイルにならず、後からバージョン別・端末別に再集計できない。カウンタなら全行を SUM して割るだけで任意の切り口の比率が出る。

`user_id` は送らない。パフォーマンス分析に不要で、個人情報の取り扱いが増えるだけ。

<!-- @code mobile_app/lib/core/telemetry/frame_stats_collector.dart#FrameStatsCollector -->
## 遅延バッチと画面遷移境界の対応付け（契約）

`SchedulerBinding.addTimingsCallback` の配信は release ビルドで**約 1 秒ごとのバッチ**である（debug / profile は約 100ms ごと）。そのため「コールバック実行時点の現在画面に加算する」という素朴な設計では、遷移前に生成されたフレームが遷移後の画面へ計上される。`FrameTiming` のタイムスタンプは `DateTime` と epoch が一致しないため、wall-clock との突き合わせでも解決できない。

本アプリは**フレームの生成順序**で対応付ける。

1. 毎フレーム同期的に走る persistent frame callback で、生成済みフレーム数をリアルタイムに数える
2. 画面が変わった時点の生成済みフレーム数を、画面区間の境界として記録する
3. `addTimingsCallback` で届いた `FrameTiming` は到着順に 1 件ずつ序数を進め、その序数が属する区間へ加算する

`FrameTiming` は生成されたフレームごとに生成順で 1 件ずつ報告されるため、序数は生成時点の区間と一致する。バッチ配信が何秒遅れても、以下のいずれでも**旧画面のフレームが新画面へ混入しない**。

- 1 秒未満での連続遷移
- `AutoTabsRouter` のタブ切替（push / pop を伴わないため `didInitTabRoute` / `didChangeTabRoute` で拾い、nested stack の leaf route を記録する）
- 遷移直後の background 遷移

画面が一度も設定されていない間のフレーム、および区間の保持上限（64）を超えて捨てられた古い区間のフレームは計上しない。終了済み区間は、その区間の FrameTiming が揃う（報告済み序数が `endOrdinal` 以上になる）まで保持する。先に drain しても後から届く旧画面のフレームを欠落させない。

## ジャンク判定

判定は**端末のリフレッシュレートから算出した予算**（`1000 / refresh_rate` ms）に対して行う。120Hz 端末の予算は 8.3ms であり、60Hz 固定で判定すると端末間で slow の定義が崩れる。

- `slow_build_count`: `FrameTiming.buildDuration` が予算超
- `slow_raster_count`: `FrameTiming.rasterDuration` が予算超
- `frozen_count`: `FrameTiming.totalSpan` が 700ms 超

build と raster を分けて数えるのは、「Dart 側の再構築が重い」のか「GPU 描画が重い」のかが原因切り分けの最初の分岐だからである。

<!-- @code mobile_app/lib/core/telemetry/perf_telemetry_service.dart#PerfTelemetryService -->
<!-- @code mobile_app/lib/core/telemetry/frame_stats_client.dart#FrameStatsClient -->
## 送信

- 送信間隔は 1 分。加えて background へ回る時（`AppLifecycleListener.onPause` / `onDetach`）に送る
- 1 セッション中に同じ画面を複数回訪れた場合、送信時に画面名で合算して行数を減らす（カウンタなので単純加算でよい）
- 1 リクエストの画面数上限は 50（サーバー受け入れ上限と一致）。超過分は切り詰めて警告ログを出し、アプリ動作には影響させない
- 送信できなかった集計は再送しない。回帰検知が目的であり、数セッション分の欠落は結論を変えない
- 送信失敗はログのみで、アプリの動作へ一切影響させない
- `session_id` は端末のセッション単位で使い捨てる識別子で、利用者と紐づけない

**debug ビルドでは計測も送信も行わない。** JIT により build が遅く、release の傾向を歪めるため。dev / prod の別は `flavor` で判別する。

## kill switch

クライアント側の `perfTelemetryEnabled`（`GET /v1/app-config`）は**通信量削減の最適化**であり、即時停止の正ではない。`appConfigProvider` は `keepAlive` で起動時に一度しか取得しないため、フラグを false にしても起動中のセッションには反映されない。

即時停止は**受信 API 側の判定**で行う（[workers-api-server.md](workers-api-server.md)）。サーバーはリクエストごとにフラグを読み、false なら 1 行も保存しない。

## 分析導線

ダッシュボードは作らない。蓄積データの参照は CLI のみとする。

| コマンド | 用途 |
|---|---|
| `just perf-report [build_number]` | AI / 定型分析の主導線。画面別ジャンク率、`platform + flavor` ごとの `build_number` による最新 vs 直前比較、端末別・リフレッシュレート別内訳を JSON で返す。各集計にセッション数と `frame_count` 合計を含める |
| `just perf-query '<SQL>'` | 手動調査用の raw SQL。AI の代表導線にはしない |

どちらも prod の `TELEMETRY_DB` を対象とし、**D1 Read のみ**の `CLOUDFLARE_API_TOKEN` を必須とする。手順と指標の解釈は `.claude/skills/analyzing-app-performance/SKILL.md` を正本とする。新旧バージョンの判定は `app_version` 文字列順ではなく数値の `build_number` で行う。
