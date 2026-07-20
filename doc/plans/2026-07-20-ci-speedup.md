# CI 高速化（キャッシュ + path 分離）

## 目的

PR 向け `check` / `docbridge` の壁時計を短縮する。直近成功 run では setup（~110s）がジョブの約 6 割で、analyze/test の 2 ジョブで二重実行されていた。

| 現状 | 目標（キャッシュヒット時の見積もり） |
|------|--------------------------------------|
| check 全体 ~3分 | ~1–1.5分（両方変更時） |
| backend のみ PR | ~30–60秒（Flutter setup を走らせない） |
| docbridge ~96秒 | ~20–40秒（Nix を外す） |

## 方針

1. Flutter / pub / bun の `actions/cache`（Magic Nix Cache は初回 CI で throttle + オーバーヘッドのため不採用）
2. `dorny/paths-filter` で mobile / backend を分離
3. `concurrency: cancel-in-progress`
4. docbridge / backend は Nix なし（`oven-sh/setup-bun`）
5. mobile のみ Nix（Flutter ツールチェーン）
6. FlakeHub Cache（有料）は使わない

## 実行手順

1. `.github/actions/ci-nix-setup` を追加（Nix + Flutter/pub キャッシュ）
2. `.github/actions/ci-bun-setup` を追加（setup-bun + bun キャッシュ）
3. `check.yml` を changes + mobile(Nix) / backend(Bun) 各 analyze/test の 4 jobs に書き換え
4. `docbridge.yml` を setup-bun 化し concurrency を追加
5. 初回 CI で Magic Nix Cache の throttle を確認したため除去し、backend を Nix なしに修正
6. Issue #237 → Draft PR #238

## 完了条件

- [x] Issue と Draft PR が存在する
- [x] `check.yml` が mobile/backend を path で分離し、キャッシュ + concurrency を持つ
- [x] `docbridge.yml` が Nix なしで動く構成になっている
- [x] PR 本文に検証観点（時間比較・skip 動作）が書かれている
- [ ] 修正後の check 壁時計が変更前（~3分）以下であること（キャッシュヒット時）

実行完了後、本ファイルを `doc/plans/done/` へ移動してコミットする。
