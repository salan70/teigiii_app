# Issue #311: Flutter 非推奨 API の置換

## 目的

Flutter 3.41.8 で非推奨となっている `WillPopScope` と `Color.withOpacity` を、
戻る操作の抑止と既存の見た目を維持したまま現行 API へ置き換える。

## 実行手順

1. 戻る操作を常に抑止する対象 UI に widget test のセーフティネットを追加し、置換前に失敗を確認する。
2. `WillPopScope` 6 箇所を `PopScope(canPop: false)` へ置き換える。
3. `withOpacity` 11 箇所を `withValues(alpha:)` へ置き換え、完全透明色はデザインシステム仕様に沿って表現する。
4. 対象テストとリポジトリ全体のモバイル検証、デザインシステム検査、DocBridge、golden test を実行する。
5. 差分をセルフレビューし、完了した plan を `doc/plans/done/` へ移動する。

## 完了条件

- `mobile_app/lib`（対象外として明示された `surfaceVariant` の抑制を除く）に `WillPopScope` と `withOpacity(` が残っていない。
- 戻る操作を抑止する widget test が通る。
- `just mobile-analyze`、`just mobile-test`、`just mobile-ds-check`、`just docbridge-check` が通る。
- `just mobile-test-golden` が通り、意図しない見た目の差分がない。
- Issue #311 の変更だけがコミットされ、PR が作成されている。

## 実行結果

- `WillPopScope` 6 箇所を `PopScope(canPop: false)` へ置き換えた。
- `withOpacity` 11 箇所を `withValues(alpha:)` へ置き換えた。
- ローディングオーバーレイの完全透明色は、背面操作を遮断するヒットテストを維持するため `withValues(alpha: 0)` とした。
- 強制アップデートとメンテナンス表示がシステムの戻る操作で閉じないことを widget test で確認した。
- 非推奨 API の再混入を検出する回帰テストを追加した。
- alpha の丸め差による disabled button 4 枚の意図した差分を確認し、golden baseline を更新した。
- `mobile-analyze`、全 398 テスト、`mobile-ds-check`、`docbridge-check`、golden 31 テストが成功した。

## 振り返り

`withValues` は `withOpacity` と alpha の丸め方が異なるため、単純な API 置換でも disabled 色の golden が変わった。
今後の Flutter 非推奨色 API 移行でも、色を扱う Ds コンポーネントは golden 差分の範囲を確認してから baseline を更新する。
