# CI Flutter 高速化（slim shell + bootstrap 分離）

## 目的

`check.yml` の mobile-analyze / mobile-test を短縮する。直近成功 run ではジョブ ~2.5 分のうち setup（Nix + `nix develop`）が約 7 割。

## 現状の内訳（キャッシュヒット時）

| ステップ | 時間 | 主因 |
|---------|------|------|
| CI Nix setup | ~30s | Nix 安装 + Flutter キャッシュ展開 |
| Install dependencies | ~75s | `flutterSrc` 実現 ~52s + 不要パッケージ ~20s |
| Analyze / Test | ~35–50s | 実作業 |

不要パッケージの closure 概算: openapi-generator ~470MB、lcov ~375MB、bun ~140MB。

## 方針

1. `bootstrap-flutter` を分離し、runtime の `flutter`/`dart` ラッパーは `flutterSrc` 非依存にする
2. `devShells.ci-mobile`（flutter / dart / just のみ）を追加
3. `check.yml` は `nix develop .#ci-mobile` を使い、Flutter キャッシュ miss 時のみ `nix run .#bootstrap-flutter`
4. Magic Nix Cache / FlakeHub は使わない（前回 #237 で不採用）

## 実行手順

1. `flake.nix` を上記どおり変更
2. `ci-nix-setup` に Flutter キャッシュ hit 出力を追加
3. `check.yml` の mobile jobs を更新
4. ローカルで wrapper 参照・ci-mobile・bootstrap を検証
5. Issue #273 → Draft PR（`closes #273`）

## ローカル検証結果

- `flutter` ラッパーの store 参照に `flutterSrc`（`*-source`）なし / `bootstrap-flutter` にはあり
- `devShells.ci-mobile` closure ~103MB vs `default` ~6.2GB（openapi / bun / lcov / bootstrap を含まない）
- 既存 `.nix/flutter` で `nix develop .#ci-mobile --command flutter --version` 成功
- `nix develop`（default）も従来どおり成功
- 未 bootstrap 時は `nix run .#bootstrap-flutter` を案内して exit 1
- 既存 stamp では `bootstrap-flutter` が early-exit

## 完了条件

- [x] Issue と Draft PR がある
- [ ] キャッシュヒット時に `Install dependencies` が ~75s から大幅短縮される（CI で確認）
- [x] ローカル `nix develop`（default）の Flutter 利用が従来どおり動く
- [x] 無関係な `prod.xcscheme` 変更を含めない

実行完了後、本ファイルを `doc/plans/done/` へ移動してコミットする。
