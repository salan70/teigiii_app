# デザインシステム 現状監査と仕様確定（#259）

Parent: #258 / 本 Issue: #259

## 目的

既存 UI の「意図的なデザイン判断」と「偶発的な直書き」を区別し、後続の
`Ds*` トークン実装（#260）とコンポーネント実装（#261）の正本となる仕様を確定する。
見た目を刷新するための監査ではなく、**現状を再現可能にするための監査**とする。

本 Issue では production UI のコードを変更しない（成果物はドキュメントと監査スクリプトのみ）。

## 前提・制約

- Material 2（`useMaterial3: false`）と既存 light / dark 表現を維持する
- 正本はリポジトリ内の型付き Dart API と Markdown 仕様
- 独立 package 化せず `mobile_app/lib/core/design_system/` に置く前提で設計する
- #275（Flutter Web QA プレビュー / #254）は draft のまま並行。
  衝突を避けるため、本 Issue では `pubspec.yaml` / `justfile` / `.github/workflows/` を変更しない
- デザインシステムのコードは Web セーフ（`dart:io` 非依存）に保つ方針を仕様に明記する

## 実行手順

1. **監査スクリプトの整備**
   - `mobile_app/tool/design_system_audit/` に再実行可能な監査スクリプトを置く
   - 抽出対象: 直書きの色 / `TextStyle` / `EdgeInsets` / `BorderRadius` / `SizedBox` サイズ / `elevation`
   - 出力は機械可読な形式（TSV / JSON）で、件数と出現箇所を再現できること
2. **現状値の分類**
   - 抽出結果を「意図的な共通値」「意味が同じ重複値」「画面固有値」「不明」に分類する
   - light / dark、iOS / Android の意図的差分を切り分ける
3. **コンポーネント台帳の作成**
   - `core/common_widget/**` と feature UI の重複実装（ボタン、入力、リスト行、カード、
     ダイアログ、空・エラー・読み込み、ナビゲーション）を台帳化する
   - Ds 化する / しない の判断基準を添える
4. **仕様の確定**
   - `doc/specs/mobile-app-design-system.md` を作成する
   - semantic token の命名・責務・追加基準、layout primitive と Ds component の境界、
     closed variant、例外申請、破壊的変更、段階移行、違反ベースラインの作り方を定義する
   - 初期コンポーネントと Widgetbook use case の最低セットを確定する
5. **後続 Issue への受け渡し**
   - #260 / #261 / #262 が参照する公開 API 候補と検証条件を仕様内に記載する
   - 必要なら各 Issue にコメントで差分を共有する

## 完了条件

- [ ] 監査が再実行可能な手段（スクリプト + 手順）とともに記録されている
- [ ] token taxonomy と `Ds*` 命名規則が定義されている
- [ ] コンポーネント化する対象／しない対象の判断基準がある
- [ ] 新規・変更 UI のルールと既存 UI の段階移行ルールがある
- [ ] lint 例外に理由と追跡 Issue を要求する手順がある
- [ ] Material 2 と既存の意図した見た目の維持が明記されている
- [ ] Material 3 移行 / ブランド刷新 / 全画面移行が対象外として明記されている
- [ ] production UI の見た目・振る舞いを変更していない
- [ ] `just mobile-analyze` と `just mobile-test` が通る
