---
name: verifying-environment
description: 検証失敗に PATH・バージョン・キャッシュ・ピン留め環境の差が疑われるときに使う。
---

# 環境検証

失敗したコマンドと実行場所を起点に、環境差とコードの失敗を切り分ける。
検証が成功している作業では追加の環境調査をしない。

## 確認する証拠

- `flake.nix`、mise、devbox、package manager などが定義する検証環境。
- 関連ツールの path と version の host・ピン留め環境での差。
- エラーに関係する cache、重複 process、worktree で欠落した設定。

`flake.nix` がある場合は `nix develop -c <command>` の結果と比較する。
ピン留め環境でも再現することを、既存の失敗と判断する前提にする。
cache は再生成可能と確認できる場合だけ削除する。

原因を裏付ける path、version、コマンド、エラーを報告する。
