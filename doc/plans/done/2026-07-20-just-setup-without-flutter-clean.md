# just setup の clean 分離と justfile 整理 (#234)

## 目的

`just setup` / `mobile-setup` が毎回 `flutter clean` しないようにし、明示クリーン用レシピを分離する。あわせて justfile の命名非対称を解消する。

## 実行手順

1. `mobile-setup` から `flutter clean` を外し、`mobile-clean`（`flutter clean` のみ）を追加する
2. `backend-lint` を `backend-analyze` にハードリネームする（中身は lint + typecheck のまま）
3. justfile コメントと README を追従する
4. `just --list` と参照 grep で完了条件を確認する

## 完了条件

- [x] `just setup` / `just mobile-setup` が `flutter clean` を実行しない
- [x] `just mobile-clean` が存在する
- [x] `just backend-analyze` が旧 `backend-lint` 相当、`backend-lint` は存在しない
- [x] README に clean 分離が書かれている
- [x] Issue #234 の完了条件を満たす
