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

<!-- @code mobile_app/lib/core/design_system/theme/ds_theme.dart#buildDsThemeData -->
<!-- @code mobile_app/lib/core/design_system/token/ds_colors.dart#DsColors -->
<!-- @code mobile_app/lib/core/design_system/token/ds_typography.dart#DsTypography -->
## 3. トークン taxonomy

意味ベース（用途）で命名する。値ベースの名前（`gap16`、`greenPrimary`）を禁止する。

| 分類 | 型 | 対象 | 出典 |
|---|---|---|---|
| color | `ColorScheme` + `DsColors`（`ThemeExtension`） | 既存 `lightColorScheme` / `darkColorScheme` をそのまま維持。`likeColor` のような意味色のみ拡張 | 監査 3.6 |
| typography | `TextTheme` + `DsTypography` | 現行の実効値（`titleLarge` / `titleMedium` / `bodyLarge` + Flutter デフォルト）を固定してから意味名を与える | 監査 3.6 |
| spacing | `DsSpacing` | 3.1 の公開 member | 監査 3.1 / 3.2 |
| radius | `DsRadius` | 3.2 の公開 member | 監査 3.3 |
| size | `DsSize` | 3.3 の公開 member | 監査 3.2 |
| elevation | `DsElevation` | 3.4 の公開 member | 監査 3.4 |
| opacity | `DsOpacity` | 3.5 の公開 member | 監査 3.5 |

以下 3.1〜3.5 が **#260 が実装する公開 API の確定リスト**。値は現行の実効値をそのまま採用し、
見た目を変えない。写像表に無い値は 3.6 の個別判定表で扱う。

<!-- @code mobile_app/lib/core/design_system/token/ds_spacing.dart#DsSpacing -->
### 3.1 `DsSpacing`

| member | 値 | 用途 |
|---|---:|---|
| `tight` | 4 | アイコンと文言など、密結合した要素の間 |
| `inline` | 8 | 同一ブロック内で隣接する要素の間 |
| `item` | 16 | リスト項目・フォーム部品など、独立した要素の間 |
| `section` | 24 | セクションの間 |
| `block` | 32 | 画面内の大きなまとまりの間 |
| `screenEnd` | 40 | 画面末尾・空表示まわりの余白 |
| `screenHorizontal` | 16 | 画面本文の左右 padding |
| `screenContent` | 24 | 画面本文の内周 padding |
| `containerContent` | 16 | カード・タイル・ダイアログの内周 padding |

同じ値でも役割が違えば別 member にする（`item` と `screenHorizontal` は共に 16）。
**写像表のキーは（構文カテゴリ, 値）の組**であり、値だけでは決まらない。

#### 選択フロー

1. 要素の**内側**の余白か、要素**間**の余白か
2. 内側 — 画面本文の左右なら `screenHorizontal`、画面本文の内周なら `screenContent`、
   カード・タイル・ダイアログの内周なら `containerContent`
3. 間 — 結びつきが強い順に `tight` → `inline` → `item` → `section` → `block`、
   画面末尾なら `screenEnd`

#### `Gap` の写像

| 現行 | member |
|---|---|
| `Gap(4)` | `DsSpacing.tight` |
| `Gap(8)` | `DsSpacing.inline` |
| `Gap(16)` | `DsSpacing.item` |
| `Gap(24)` | `DsSpacing.section` |
| `Gap(32)` | `DsSpacing.block` |
| `Gap(40)` | `DsSpacing.screenEnd` |

#### `EdgeInsets` の写像

| 現行 | member |
|---|---|
| `symmetric(horizontal: 16)` / `only(left: 16, right: 16)` | `screenHorizontal` |
| `all(16)` | `containerContent` |
| `all(24)` / `symmetric(vertical: 24)` / `symmetric(horizontal: 24)` / `only(top: 24, left: 24, right: 24)` | `screenContent` |
| `only(top: 16)` / `only(bottom: 16)` | `item` |
| `only(top: 8)` / `symmetric(vertical: 8)` | `inline` |
| `only(top: 32)` | `block` |
| `only(top: 8, bottom: 40)` / `only(top: 40, bottom: 16)` | `inline` / `screenEnd` / `item` の組み合わせ |

`only(left: 16, right: 16)` は `symmetric(horizontal: 16)` と同義の重複値であり、写像時に集約する。

<!-- @code mobile_app/lib/core/design_system/token/ds_radius.dart#DsRadius -->
### 3.2 `DsRadius`

| member | 値 | 用途 |
|---|---:|---|
| `pill` | 48 | ボタン・アバターなど pill 型の要素 |
| `field` | 40 | 検索・入力フィールド |
| `container` | 16 | ダイアログ・カード・メニュー |
| `subtle` | 4 | スナックバー・ローディング表示の弱い角丸 |
| `shimmer` | 2 | shimmer の矩形 |

<!-- @code mobile_app/lib/core/design_system/token/ds_size.dart#DsSize -->
### 3.3 `DsSize`

| member | 値 | 用途 |
|---|---:|---|
| `iconSmall` | 16 | 本文に添えるアイコン |
| `iconMedium` | 20 | 標準のアクションアイコン |
| `iconLarge` | 24 | 単独で意味を持つアイコン |
| `avatarIcon` | 40 | プロフィール系の大アイコン |

`SizedBox` による固定高（検索フィールドの 80 など 4 件）はトークンにせず、
対応する Ds コンポーネント内部へ閉じる。

<!-- @code mobile_app/lib/core/design_system/token/ds_elevation.dart#DsElevation -->
### 3.4 `DsElevation`

| member | 値 | 用途 |
|---|---:|---|
| `none` | 0 | 既定。AppBar / ダイアログ / ボタン |
| `hairline` | 0.1 | AppBar / BottomNavigationBar の境界表現 |

`elevation: 3` は FAB 専用（5 章で Ds 対象外と定めた）ため、
「現に実装で使う」基準を満たさずトークン化しない。

<!-- @code mobile_app/lib/core/design_system/token/ds_opacity.dart#DsOpacity -->
### 3.5 `DsOpacity`

| member | 値 | 用途 |
|---|---:|---|
| `disabled` | 0.3 | 無効状態・オーバーレイの遮蔽 |

0.4 / 0.8 は単独利用でありコンポーネント内部へ閉じる。`withOpacity(0)` は
不透明度ではなく透明色の指定なので `Colors.transparent` を使う。

### 3.6 写像表で決まらない値の個別判定

以下は #260 が個別に処理する。行番号は対象コミット `5c366b7` 時点のもの。

| 箇所 | 現行 | 判定 |
|---|---|---|
| `definition_detail_page.dart:78` | `Gap(2)` | `tight`（4）へ丸める |
| `profile_tile.dart:107` | `Gap(20)` | `item`（16）へ丸める |
| `word_page_shimmer.dart:23` | `Gap(26)` | `section`（24）へ丸める |
| `setting_page.dart:158` | `Gap(72)` | 例外申請。アカウント削除ボタンを他導線から隔離する画面固有余白 |
| `word_registration_page.dart:200`, `write_definition_base_page.dart:131` | `Gap(300)` | 例外申請。キーボード回避の下部余白 |
| `post_definition_fab.dart:150` ほか | `Gap(10)` / `radius 28` / `elevation 3` / `opacity 0.35` / `padding(20, 12)` | FAB は Ds 対象外。例外申請 |
| `word_search_result_page.dart:67` | `symmetric(horizontal: 36)` | `screenContent`（24）との差分意図を確認し、無ければ集約 |
| `dictionary_everyone_page.dart:36`, `user_search_page.dart:17` | `symmetric(horizontal: 40)` | ~~`DsSearchField` 内部へ閉じる~~ → **呼び出し側に残す**（#264 で判断を訂正。下記参照） |
| `word_page_shimmer.dart:15` | `symmetric(horizontal: 20)` | `DsShimmer` 利用側で `screenHorizontal` へ集約 |
| `dictionary_word_index_list.dart:111` | `symmetric(horizontal: 16, vertical: 6)` | `DsListTile` 内部へ閉じる |
| `setting_page.dart:43` | `only(left: 24, right: 20)` | 左右非対称の意図が読めない。`screenContent` へ集約 |
| `like_widget.dart:34` | `only(top: 4, right: 4, bottom: 4)` | タップ領域の調整。`DsIconButton` 内部へ閉じる |
| `self_definition_action_icon_button.dart:201` | `only(top: 16, bottom: 8)` | `DsDialog` の `contentPadding` として内部へ閉じる |
| `overlay_force_update_dialog.dart`, `overlay_in_maintenance_dialog.dart` | `radius 8` | `DsDialog` 移行時に `container`（16）へ統一。golden 差分を意図として説明する |
| `changeable_profile_image.dart` | `size: 28` / `opacity 0.8` | コンポーネント内部値として閉じる |
| `select_post_type_button.dart` | `size: 8` | 装飾ドット。コンポーネント内部値として閉じる |

### #264 での判断の訂正

`DsSearchField` の外枠（高さ・左右余白）は、監査時点では「コンポーネント内部へ閉じる」と
判断していたが、**呼び出し元によって値が違う**ことがパイロット移行で判明した。

| 画面 | 高さ | 左右余白 |
|---|---|---|
| `DictionaryEveryonePage` | 80 | 40 |
| `WordSearchResultPage` | 指定なし | 36 |
| `UserSearchPage` | 80 | 40 |

内部へ閉じると `WordSearchResultPage` の見た目が変わるため、呼び出し側に残して
例外申請した。統一は #280 で扱う。

`Gap(300)`（キーボード回避）は予定どおり例外申請とし、仕組みでの置き換えを #281 で扱う。

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
- **状態は見た目にも反映する**。disabled は「同じ色を [DsOpacity.disabled] で薄くしたもの」で
  表し、専用の色トークンは増やさない。操作可否が見た目で判別できない状態を作らない
- 必須の意味（ラベル、ハンドラ）は required 引数にする
- 既存の `ErrorAndRetryWidget.cannotInquire` / `.canInquire`、
  `ShimmerWidget.rectangular` / `.circular` を規約のリファレンス実装とする

<!-- @code mobile_app/lib/core/design_system/component/ds_button.dart#DsFilledButton -->
<!-- @code mobile_app/lib/core/design_system/component/ds_button.dart#DsOutlinedButton -->
<!-- @code mobile_app/lib/core/design_system/component/ds_dialog.dart#DsDialog -->
<!-- @code mobile_app/lib/core/design_system/component/ds_dialog.dart#DsConfirmDialog -->
<!-- @code mobile_app/lib/core/design_system/component/ds_feedback.dart#DsEmptyView -->
<!-- @code mobile_app/lib/core/design_system/component/ds_feedback.dart#DsErrorView -->
<!-- @code mobile_app/lib/core/design_system/component/ds_feedback.dart#DsShimmer -->
<!-- @code mobile_app/lib/core/design_system/component/ds_list_tile.dart#DsListTile -->
<!-- @code mobile_app/lib/core/design_system/component/ds_search_field.dart#DsSearchField -->
<!-- @code mobile_app/lib/core/design_system/component/ds_icon_button.dart#DsIconButton -->
<!-- @code mobile_app/lib/core/design_system/component/ds_text_field.dart#DsTextField -->
### 初期コンポーネント最低セット（#261）

1. `DsFilledButton` / `DsOutlinedButton`
2. `DsDialog` / `DsConfirmDialog`
3. `DsEmptyView` / `DsErrorView` / `DsShimmer`
4. `DsListTile`
5. `DsSearchField`
6. `DsIconButton`（`self_definition_action_icon_button` / `other_user_action_icon_button` で
   サイズ・padding の直書きが重複している。監査 4.2）
7. `DsTextField`（検索以外の汎用テキスト入力。`singleLine` / `multiline` の closed variant を持つ）

`DsTextField` は #259 時点の最低セットに含めていなかったが、パイロットの
`DefinitionPostPage` / `WriteDefinitionBasePage` が `TextFormField` を 6 箇所で使っており、
これなしでは入力系パイロットが成立しないため #261 のスコープに含める。
`controller` / `focusNode` / `validator` / `maxLength` は受け取るが、
`InputDecoration` や `TextStyle` は公開 API で受け取らない。

#### 初期セットに含めないものと根拠

| 対象 | 根拠 |
|---|---|
| FAB | 実利用は `post_definition_fab.dart` の 1 箇所のみ。定義投稿への遷移というドメイン知識と独自の展開アニメーションを持ち、「2 画面以上で同じ見た目・操作仕様」を満たさない。4 章の基準どおり feature 側の責務とし、#261 でも扱わない |
| motion | 監査でトークン化に足る実利用が確認できなかった（3 章） |

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

### 違反検出（`ds_check`）

`mobile_app/tool/ds_check.dart`（analyzer の AST 走査）で検出する。CI の `mobile-analyze` job で実行する。

```bash
just mobile-ds-check              # 検査（CI と同じ）
just mobile-ds-baseline-update    # baseline 再生成
```

| ルール ID | 対象 |
|---|---|
| `ds_hardcoded_color` | `Color(0x...)` / `Colors.<名前>` |
| `ds_hardcoded_text_style` | `TextStyle(...)` の直接生成 |
| `ds_hardcoded_spacing` | `Gap` / `EdgeInsets.*` / `SizedBox(width:, height:)` の数値リテラル |
| `ds_hardcoded_radius` | `BorderRadius.circular` / `Radius.circular` の数値リテラル |
| `ds_forbidden_widget` | Material のボタン・入力・`AlertDialog` / `ListTile` / `IconButton` の直接利用 |
| `ds_suppression_without_reason` | 理由・追跡 Issue のない `// ignore:` |

対象は `lib/**`。`lib/core/design_system/**`、`lib/util/**`、generated（`*.g.dart` / `*.freezed.dart` / `*.gr.dart`）は除外する。

判定:

- baseline（`mobile_app/tool/ds_baseline.json`、ファイル × ルールの件数）に無い違反、または件数超過で**失敗**
- `ds_hardcoded_color` と `ds_suppression_without_reason` は baseline 対象外で**常に 0 件必須**
- baseline を下回ったら成功するが「baseline を更新せよ」と警告する。違反を減らした PR で `just mobile-ds-baseline-update` を実行してコミットする

### 既存 `core/common_widget` の扱い

`core/common_widget` の共通ウィジェット（ボタン、ダイアログ、エラー表示、shimmer）は
Ds コンポーネントの前身にあたる。**実体を `design_system/component/` へ移設し、
旧パスは `@Deprecated` な `typedef` として残す**。

- 二重実装を作らない（見た目の修正漏れを防ぐ）
- 非パイロット画面は旧パス経由でそのまま動く（一括移行にしない）
- `@Deprecated` のメッセージに移行先と追跡 Issue を必ず書く

```dart
@Deprecated('DsFilledButton を使う。全参照の移行後に削除する (#278)')
typedef FilledButtonWidget = DsFilledButton;
```

旧 typedef の全廃は #278 で追跡する。

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

## 6.5 実行方法

| 目的 | コマンド | CI |
|---|---|---|
| 静的解析 | `just mobile-analyze` | ✓ |
| テスト（golden 除く） | `just mobile-test` | ✓ |
| デザインシステム違反検出 | `just mobile-ds-check` | ✓ |
| Widgetbook の build 検証 | `just mobile-widgetbook-build` | ✓ |
| 仕様とコードのリンク検証 | `just docbridge-check` | ✓ |
| カタログをローカル起動 | `just mobile-widgetbook` | — |
| golden の比較 | `just mobile-test-golden` | — |
| golden の撮り直し | `just mobile-test-golden-update` | — |
| 違反 baseline の再生成 | `just mobile-ds-baseline-update` | — |

`just mobile-ds-baseline-update` は**違反が減ったときだけ**実行する。
増えたときに実行して通すのは禁止。例外が必要なら 6 章の例外申請を使う。

## 7. 検証条件（後続 Issue への引き継ぎ）

| Issue | 検証条件 |
|---|---|
| #260 トークン | light / dark 双方で全トークンが解決できる unit / widget test。`ThemeData` 構築に `BuildContext` 不要。既存テーマ値を意図せず変更していないこと |
| #261 コンポーネント | 全公開コンポーネントに Widgetbook use case と widget test |
| #262 CI | Flutter Accessibility Guideline 検査（Ds コンポーネント）と違反ベースライン比較を CI で実行。golden は下記のとおり CI 対象外 |
| #263 ドキュメント | 本仕様と主要コード宣言を DocBridge で双方向リンク（`just docbridge-check`） |
| #264 パイロット | 2 系統の移行前後で golden が一致、または差分を意図として説明できること |

共通: `just mobile-analyze`、`just mobile-test`、`just docbridge-check` が通ること。

### golden test の位置づけ

golden は**移行検証用のローカルツール**とし、**CI では実行しない**。

- 開発は macOS、CI は `ubuntu-latest` であり、同一 Flutter でもラスタライズ結果が一致しない
- CI を正本にすると、UI を変えるたびに golden 更新のための CI 往復が必要になる
- 一方で「パイロット移行で見た目が変わっていないこと」の証明には golden が要る。
  同一マシンで移行前後を撮り比べる用途であれば環境差の問題は発生しない

運用:

- golden test には `@Tags(['golden'])` を付ける
- `just mobile-test` は `--exclude-tags golden`。CI もこれを使う
- `just mobile-test-golden` をローカルで実行する。生成物はコミットする
- golden を CI に常設化するかは #277 で判断する

アクセシビリティ検査は **Ds コンポーネントのみ** CI 必須とする。
既存画面へ一括適用すると初回から大量に失敗し、見た目を変えない方針とも衝突するため。
