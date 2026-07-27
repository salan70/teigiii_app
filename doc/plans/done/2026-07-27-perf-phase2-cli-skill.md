# Perf Phase 2 — CLI + skill（#290）

## 目的

Phase 1 で蓄積した `frame_stats` を、ダッシュボードなしで AI / CLI から参照できるようにする。

## 実行手順

1. `just perf-query` / `just perf-report` と `backend/scripts/perf/*` を追加する
2. `.claude/skills/analyzing-app-performance` を追加する
3. Codex 移植はしない判断を `doc/porting-ai-assets-to-codex.md` に追記する
4. 仕様に分析導線を追記し、Draft PR を出す

## 完了条件

- [x] `just perf-query` / `just perf-report` が定義されている
- [x] 分析導線が D1 Read のみの token を前提にしている
- [x] AI 主導線が `perf-report`、raw SQL は手動調査用に分離されている
- [x] 新旧判定が `platform + flavor` ごとの `build_number` である
- [x] 集計にサンプル数が含まれる
- [x] `analyzing-app-performance` skill がある
- [x] Codex 移植要否が台帳に反映されている
