# モバイルアプリ デザインシステム仕様

Issue: #258（親） / 本仕様の確定: #259

本書はデザインシステムの**正本**。UI を実装する人間および AI エージェント
（Claude / Codex）は、実装前に本書を参照する。

現状のスナップショット（値の分布・コンポーネント台帳・移行難度）は
`doc/specs/mobile-app-design-system-audit.md` を参照。

## 1. 目的と原則

- 同じ入力から同じコンポーネントとトークンを選べる状態をつくる
- 正本はリポジトリ内の**型付き Dart API と本 Markdown 仕様**
- 初期導入では **Material 2（`useMaterial3: false`）と既存の視覚表現を維持する**
- 見た目の変更は本デザインシステムの目的ではない

### 対象外

- Material 3 移行
- ブランド・ビジュアルの刷新
- 既存全画面の一括移行
- 独立 Flutter package 化
- Figma / JSON / Tokens Studio を正本にすること
- Widgetbook Cloud の導入
- Flutter Web を製品プラットフォームとして対応すること（#254）

## 2. 配置と命名

- 実装場所: `mobile_app/lib/core/design_system/`
- 公開型はすべて `Ds` 接頭辞（`DsSpacing`、`DsFilledButton` など）
- 非公開の実装詳細は `_` 接頭辞とし、feature から参照させない
- **デザインシステムのコードは Web セーフに保つ**（`dart:io` に依存しない）。
  Web QA 環境（#254 / #275）でカタログとパイロット画面がビルドできる状態を維持する

## 3. トークン taxonomy

意味ベース（用途）で命名する。値ベースの名前（`gap16`、`greenPrimary`）を禁止する。

| 分類 | 型 | 対象 | 出典 |
|---|---|---|---|
| color | `ColorScheme` + `DsColors`（`ThemeExtension`） | 既存 `lightColorScheme` / `darkColorScheme` をそのまま維持。`likeColor` のような意味色のみ拡張 | 監査 3.6 |
| typography | `TextTheme` + `DsTypography` | 現行の実効値（`titleLarge` / `titleMedium` / `bodyLarge` + Flutter デフォルト）を固定してから意味名を与える | 監査 3.6 |
| spacing | `DsSpacing` | 4 の倍数スケール（4 / 8 / 16 / 24 / 32 / 40） | 監査 3.1 / 3.2 |
| radius | `DsRadius` | pill（48）、container（16）、shimmer（2） | 監査 3.3 |
| size | `DsSize` | アイコン（16 / 20 / 24）、その他の固定寸法 | 監査 3.2 |
| elevation | `DsElevation` | none(0) / hairline(0.1) / raised(3) | 監査 3.4 |
| opacity | `DsOpacity` | disabled 相当（0.3）など、実利用が確認できた範囲のみ | 監査 3.5 |

### トークン追加基準

次を**すべて**満たすときにのみトークンを追加する。

1. 2 箇所以上で同じ意味に使われている、または単独でも意味が明確に定義できる
2. 名前が値ではなく用途を表せる
3. 現に実装で使う（**将来要件だけを理由に追加しない**）

motion（アニメーション時間・カーブ）は監査で十分な実利用が確認できなかったため、
初期スコープではトークン化しない。

### 制約

- `ThemeData` の構築に呼び出し元の `BuildContext` を要求しない
  （現行 `getThemeData(ThemeMode, BuildContext)` は `BuildContext` を必要とする。#260 で解消する）
- feature から任意の生値を渡す API を作らない
- 外部デザインツールの出力を正本にしない

## 4. layout primitive と Ds component の境界

| 直接利用してよい | デザインシステム経由にする |
|---|---|
| `Row` / `Column` / `Stack` / `Expanded` / `Flexible` / `Align` / `Wrap` | 見た目や操作仕様を持つ要素すべて |
| `ListView` / `CustomScrollView` などのスクロール基盤 | ボタン、入力、リスト行、カード、ダイアログ、空・エラー・読み込み表示 |
| `Padding` / `SizedBox` / `Gap`（**値はトークン経由**） | アイコン、区切り線、バッジ、アバターなど視覚要素 |

判断基準: **その widget が「配置」だけを担うなら直接利用、「見え方」を決めるなら Ds 経由。**

### コンポーネント化する / しないの判断基準

Ds コンポーネントにする:

- 2 画面以上で同じ見た目・操作仕様が必要
- 状態（enabled / disabled / loading / error / empty）を持つ
- アクセシビリティ要件（タップ領域、コントラスト、セマンティクス）を伴う

Ds コンポーネントにしない:

- 特定の遷移先やドメイン知識を持つ（例: `ToProfileButton`）
- 単一画面でしか意味を持たないレイアウト
- 状態管理やページング挙動が主目的（例: `InfinityScrollWidget`）

## 5. コンポーネント API 規約

- **closed variant**: 用途別の名前付きコンストラクタまたは専用型で提供する。
  任意の `style` / `color` / `padding` override を原則提供しない
- 状態は enum または名前付きコンストラクタで表現し、bool の組み合わせで表現しない
- 必須の意味（ラベル、ハンドラ）は required 引数にする
- 既存の `ErrorAndRetryWidget.cannotInquire` / `.canInquire`、
  `ShimmerWidget.rectangular` / `.circular` を規約のリファレンス実装とする

### 初期コンポーネント最低セット（#261）

1. `DsFilledButton` / `DsOutlinedButton`
2. `DsDialog` / `DsConfirmDialog`
3. `DsEmptyView` / `DsErrorView` / `DsShimmer`
4. `DsListTile`
5. `DsSearchField`

### Widgetbook use case の最低セット

各公開コンポーネントについて、次を必ず用意する。

- light / dark 各 1
- 状態バリエーション（enabled / disabled / loading / error のうち、その型が持つもの）
- 最長文言・折り返しが発生するケース

## 6. 運用ルール

### 新規・変更 UI

- 新規 UI はデザインシステムの利用を必須とする
- 既存 UI は**変更時に**移行する。一括移行しない
- 既存違反はベースライン化し、CI では**新規違反・違反増加を失敗**させる（#262）
- 色の直書きは現時点で 0 件のため、ベースラインなしで即時失敗とする

### 例外申請

feature UI でデザイン値を直書きする場合、次を**両方**満たすこと。

```dart
// ignore: ds_hardcoded_value
// 理由: キーボード回避のための画面固有の下部余白。トークン化しない。
// 追跡: #NNN
const Gap(300),
```

- 理由を日本語で 1 行以上書く
- 追跡 Issue 番号を書く
- **理由・追跡 Issue のない lint 抑制を禁止する**

### 破壊的な公開 API 変更

`Ds*` の公開 API を破壊的に変更する場合、**同一 PR で**次をすべて更新する。

1. 利用箇所すべて
2. 本仕様
3. Widgetbook の use case
4. 対応するテスト

### パイロット

初期パイロットは次の 2 系統（#264）。

- `DictionaryEveryonePage`
- `DefinitionPostPage` / `WriteDefinitionBasePage`

いずれも**振る舞いと意図した見た目を変えずに**移行する。

## 7. 検証条件（後続 Issue への引き継ぎ）

| Issue | 検証条件 |
|---|---|
| #260 トークン | light / dark 双方で全トークンが解決できる unit / widget test。`ThemeData` 構築に `BuildContext` 不要。既存テーマ値を意図せず変更していないこと |
| #261 コンポーネント | 全公開コンポーネントに Widgetbook use case と widget test |
| #262 CI | golden test、Flutter Accessibility Guideline 検査、違反ベースライン比較を CI で実行 |
| #263 ドキュメント | 本仕様と主要コード宣言を DocBridge で双方向リンク（`just docbridge-check`） |
| #264 パイロット | 2 系統の移行前後で golden が一致、または差分を意図として説明できること |

共通: `just mobile-analyze`、`just mobile-test`、`just docbridge-check` が通ること。
