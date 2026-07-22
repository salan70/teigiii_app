# iOS 実機デバッグ（iOS 26 / Flutter 3.41）

鬼瓦（iPhone 16 / iOS 26.5）での調査結果に基づく運用メモ。アプリ側の不具合ではなく、Apple のメモリ保護変更と Flutter の回避策の組み合わせが原因。

## 結論（使い分け）

| 目的 | 推奨 | 理由 |
|------|------|------|
| 日常の実装・hot reload | **シミュレータ debug** | JIT 制限なし。最速 |
| 実機の見た目・端末固有挙動 | **実機 `--profile`（無線可）** | AOT。LLDB JIT ペナルティなし |
| 実機で debug / hot reload | **USB 接続の debug** | 無線 debug は実用不可レベル |
| 実機で無線 debug | 非推奨 | iOS 26 では使い物にならない |

## 何が起きているか

1. **iOS 18.4 / 26 の JIT 制限**  
   アプリ自身が実行可能メモリを `mprotect` で書き換えられない（`RUNTIME_EXCEPTION_ALLOW_JIT = NO`）。  
   参照: [flutter/flutter#163984](https://github.com/flutter/flutter/issues/163984)

2. **Flutter の回避策 = LLDB 経由で RX ページを書く**  
   `flutter config --enable-lldb-debugging` が必須（未設定だと debug 起動時に VM が落ちる）。  
   `ios/Flutter/ephemeral/flutter_lldb_helper.py` が `NOTIFY_DEBUGGER_ABOUT_RX_PAGES` を処理する。  
   ページごとにデバッガ往復が発生し、**ワイヤレスでは数百 ms〜秒単位**のストールになる。  
   参照: [flutter/flutter#175962](https://github.com/flutter/flutter/issues/175962)

3. **無線の Dart VM Service 発見**  
   Bonjour (`_dartVmService._tcp`) に依存。Local Network 許可が必要。  
   同 bundle id のシミュレータが動いていると mDNS が汚染され、接続に失敗しやすい。  
   参照: [flutter/flutter#144634](https://github.com/flutter/flutter/issues/144634)（2024〜の無線 VM 発見問題）

## 初回セットアップ（ホスト Mac）

```bash
# iOS 26 実機 debug に必須。マシン単位の設定。
flutter config --enable-lldb-debugging

# 確認（Feature flags に enable-lldb-debugging が出ること）
flutter doctor -v
```

実機側:

- 開発者モード ON
- 初回起動時の **ローカルネットワーク** ダイアログで許可（拒否済みならアプリを削除して再インストール）
- 設定 → Teigiii dev → ローカルネットワーク = ON

## コマンド

```bash
# 端末 ID 確認（wireless 表記に注意）
flutter devices

# 日常: シミュレータ debug
just mobile-run-dev-on DDCA5D1C-5B99-4ACD-A370-551F158CBE26

# 実機の動作確認（無線でも実用速度）: profile / AOT
just mobile-run-dev-profile-on 00008140-001A78C82147001C

# 実機 debug（USB 接続時のみ推奨。無線は重い）
just mobile-run-dev-on 00008140-001A78C82147001C
```

USB なのに `wireless` と出る場合は、Xcode の Devices and Simulators でネットワークデバッグを切り、ケーブル接続を優先する。Flutter は無線経路を選ぶと LLDB JIT が極端に遅くなる。

## 切り分けチェックリスト

1. `flutter doctor -v` に `enable-lldb-debugging` があるか  
2. `flutter devices` が `(wireless)` か USB か  
3. 同 bundle id のシミュレータ Runner が生きていないか（`pgrep -lf Runner.app/Runner`）  
4. `dns-sd -B _dartVmService._tcp` で実機ホスト名（例: `onigawarakarakihachirou.local`）が出るか。`127.0.0.1` / Mac ホスト名だけならシミュレータ汚染  
5. debug で重いが profile/release が軽い → アプリロジックではなく JIT/LLDB 側

## このリポジトリでの検証メモ（2026-07-22）

- 対象: 鬼瓦 毅八郎 `00008140-001A78C82147001C` / iOS 26.5 / Xcode 26.1 / Flutter 3.41.8
- LLDB 有効化後、無線 debug で `Dart execution mode: JIT` まで到達（起動自体は成功）
- 無線 debug は Flutter 自身が `Wireless debugging on iOS 26 may be slower than expected` を警告
- WebContent / Networking プロセス起動だけで数〜十数秒。操作は実用不可レベル
- 同一 bundle id のシミュレータが mDNS を汚染し、VM Service 発見がさらに不安定だった
