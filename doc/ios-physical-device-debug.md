# iOS 実機での確認（iOS 26 / Flutter 3.41）

実機の確認は、dev の Profile ビルドを入れて Mac から切り離して触る方法を既定にする。
iOS 26 の無線 debug が実用にならないためで、アプリ側の不具合ではない。

## 既定の手順: 1 コマンドでインストール

```bash
# 初回だけ。.env（gitignore 済み）に既定の端末を書く。例は .env.example
echo 'TEIGIII_DEVICE=<端末名か UDID>' >> .env   # 一覧: xcrun devicectl list devices

just device-dev                # 既定の端末へ dev をビルド → インストール → 起動
just device-dev <端末>         # 端末を指定する
SKIP_BUILD=1 just device-dev   # ビルド済みを入れ直すだけ
NO_LAUNCH=1 just device-dev    # 入れるだけで起動しない
```

- 実体は `mobile_app/scripts/install-device.sh`。`flutter build ios --profile --flavor dev` で作り、`xcrun devicectl` で入れて起動する
- 署名は `mobile_app/ios/Flutter/Dev.xcconfig` の手動署名（プロファイル `Teigiii Dev`）。App Store Connect の API キーは使わない。プロファイルに端末が含まれ、Xcode に入っている必要がある
- bundle ID は、ビルドした `Runner.app` の `Info.plist` から取る。`just mobile-check-ios-flavors` が検査する flavor 設定と同じ値になる
- Profile ビルドは `kReleaseMode` が偽なので、iOS の App Check は debug provider になる。`.env` の `APP_CHECK_DEBUG_TOKEN`（UUID）を書くと、起動時に `FIRAAppCheckDebugToken` として渡す。書かなければ端末ごとに自動生成され、Firebase に登録が要る
- `just device-prod` は prod を入れる。確認を挟む。prod の Profile は配布用プロファイルで署名するため、端末へ入らない場合がある
- 端末が見つからない、ロックされている、開発者モードが無効、などの失敗は、原因と対処を 1 行で出す

実機側の前提: 開発者モードが ON、Mac を信頼済み。

## debug / hot reload が要るとき

| 目的 | 推奨 | 理由 |
|------|------|------|
| 日常の実装・hot reload | シミュレータ debug | JIT 制限なし。最速 |
| 実機で debug / hot reload | USB 接続の debug | 無線 debug は実用不可レベル |

```bash
flutter config --enable-lldb-debugging    # 初回のみ。iOS 26 実機 debug に必須
just mobile-run-dev-on <端末 ID>          # シミュレータや、USB 接続の実機 debug
just mobile-run-dev-profile-on <端末 ID>  # flutter run で Profile を起動する（接続が残る）
```

USB なのに `wireless` と出る場合は、Xcode の Devices and Simulators でネットワークデバッグを切り、ケーブル接続を優先する。
実機の初回起動時の **ローカルネットワーク** ダイアログで許可する（拒否済みならアプリを削除して再インストール）。

## 原因の要約

- iOS 18.4 / 26 は、アプリ自身が実行可能メモリを書き換える JIT を禁じた（[flutter/flutter#163984](https://github.com/flutter/flutter/issues/163984)）
- Flutter の回避策は LLDB 経由で RX ページを書く方式で、ページごとにデバッガ往復が起き、無線では数百 ms〜秒単位で止まる（[flutter/flutter#175962](https://github.com/flutter/flutter/issues/175962)）
- 無線の Dart VM Service 発見は Bonjour に依存する。同 bundle ID のシミュレータが動いていると mDNS が汚染される（[flutter/flutter#144634](https://github.com/flutter/flutter/issues/144634)）
- Profile / Release は AOT なので、この影響を受けない

debug だけ重いときは、`flutter doctor -v` に `enable-lldb-debugging` があるか、`flutter devices` が `(wireless)` でないか、`pgrep -lf Runner.app/Runner` で同 bundle ID のシミュレータが生きていないかを確認する。
