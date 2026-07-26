# デザインシステム 現状監査結果（2026-07-25 時点）

Issue: #259（親: #258）

本書は監査の**スナップショット**。規範（守るべきルール）は
`doc/specs/mobile-app-design-system.md` を正本とする。

- 対象コミット: `5c366b7`（develop）
- 対象: `mobile_app/lib/**`（生成ファイル `*.g.dart` / `*.freezed.dart` を除く 188 ファイル）

## 1. 再実行手順

```bash
cd mobile_app
dart run tool/design_system_audit/audit.dart             # カテゴリ別・ファイル別サマリ
dart run tool/design_system_audit/audit.dart --tsv       # 明細（診断用。行番号を含む）
dart run tool/design_system_audit/audit.dart --baseline  # 安定 ID 単位の件数（比較用。7 章）
```

スクリプトは正規表現ベースで、1 行 1 カテゴリにつき 1 件までを数える。
厳密な AST 解析ではないため、絶対値ではなく**傾向とベースライン**として扱う。
テーマ定義そのもの（`lib/util/constant/{color_scheme,text_theme,theme_data}.dart`）は
意図的な正本として除外している。

## 2. 集計結果

検出件数 290 件 / 62 ファイル。

| カテゴリ | 件数 | 所見 |
|---|---:|---|
| gap | 140 | `Gap(n)` が余白の主要イディオム。トークン化の最優先対象 |
| padding | 79 | `EdgeInsets.*` の直書き。値は 16 / 24 に集中 |
| radius | 19 | 角丸。48（ボタン）と 16（ダイアログ・カード）が支配的 |
| icon-size | 18 | 20 / 24 / 16 に集中 |
| elevation | 15 | 大半が `0`。実質 3 値のみ |
| opacity | 12 | `withOpacity(0.3)` が支配的 |
| size-box | 4 | 固定高（例: 検索フィールド 80） |
| text-style | 2 | インライン `TextStyle` はほぼ存在しない |
| font-size | 1 | 同上 |
| color-literal / color-named | 0 | **feature UI に色の直書きは存在しない** |

### 直書きの多いファイル（上位 10）

| 件数 | ファイル |
|---:|---|
| 18 | `lib/core/page/setting_page.dart` |
| 17 | `lib/core/page/definition_detail_page.dart` |
| 14 | `lib/feature/user_profile/presentation/profile_tile.dart` |
| 13 | `lib/feature/definition/presentation/self_definition_action_icon_button.dart` |
| 11 | `lib/feature/user_profile/presentation/profile_widget.dart` |
| 11 | `lib/feature/definition/presentation/definition_tile.dart` |
| 10 | `lib/core/page/definition_edit_page.dart` |
| 8 | `lib/feature/word/presentation/word_page_shimmer.dart` |
| 8 | `lib/core/common_widget/error_and_retry_widget.dart` |
| 8 | `lib/core/page/profile_edit_page.dart` |

## 3. 値の分類

分類の定義:

- **意図的な共通値** — 複数箇所で同じ意味に使われており、そのままトークン化する
- **重複値** — 意味は同じだが表現がばらついており、トークンへ集約する
- **画面固有値** — 特定画面の事情による値。トークン化せず、コンポーネント内部か例外として扱う
- **不明** — 意図が読み取れず、#260 実装時に個別判断する

### 3.1 余白（`Gap` 実測値）

| 値 | 出現 | 分類 |
|---:|---:|---|
| 8 | 47 | 意図的な共通値 |
| 16 | 42 | 意図的な共通値 |
| 24 | 26 | 意図的な共通値 |
| 4 | 10 | 意図的な共通値 |
| 32 | 4 | 意図的な共通値 |
| 40 | 4 | 意図的な共通値 |
| 2 / 10 / 20 / 26 | 各 1 | 不明（4 の倍数から外れる。#260 で個別判断） |
| 72 | 1 | 画面固有値 |
| 300 | 2 | 画面固有値（入力画面のキーボード回避用の下部余白） |

**4 の倍数スケール（4 / 8 / 16 / 24 / 32 / 40）が全体の 98% を占める。**
2 / 10 / 20 / 26 は 4 件のみで、視覚差がほぼないためトークンへ丸める候補。

### 3.2 パディング（`EdgeInsets` 実測値）

| 値 | 出現 | 分類 |
|---|---:|---|
| `symmetric(horizontal: 16)` | 12 | 意図的な共通値（画面横 padding） |
| `all(16)` | 11 | 意図的な共通値 |
| `symmetric(vertical: 24)` | 10 | 意図的な共通値 |
| `symmetric(horizontal: 24)` | 8 | 意図的な共通値 |
| `only(top: 16)` / `only(bottom: 16)` | 各 5 | 意図的な共通値 |
| `all(24)` | 5 | 意図的な共通値 |
| `only(left: 16, right: 16)` | 2 | **重複値**（`symmetric(horizontal: 16)` と同義） |
| `symmetric(horizontal: 36)` / `(horizontal: 20, vertical: 12)` / `(horizontal: 16, vertical: 6)` | 各 1 | 不明 |
| `only(left: 24, right: 20)` / `only(top: 4, right: 4, bottom: 4)` | 各 1 | 画面固有値 |

### 3.3 角丸

| 値 | 出現 | 分類 |
|---:|---:|---|
| 48 | 6 | 意図的な共通値（pill 型ボタン） |
| 16 | 4 | 意図的な共通値（ダイアログ・カード） |
| 40 / 28 / 8 / 4 | 各 2 | 画面固有値〜不明 |
| 2 | 1 | 意図的な共通値（shimmer の矩形） |

### 3.4 標高

`0` が 13 件、`0.1` が 2 件（AppBar / BottomNavigationBar）、`3` が 2 件。
**実質 3 段階しかないため、そのままトークン化できる。**

### 3.5 不透明度

`withOpacity(0.3)` が 8 件で支配的。`0.35` / `0.4` / `0.8` / `0` が各 1 件。
0.3 と 0.35 は重複値。監査で実利用が確認できたのはこの範囲のみで、
motion（アニメーション時間・カーブ）はトークン化に足る実利用が確認できなかった。

### 3.6 色・タイポグラフィ

**色の直書きは feature UI に 1 件も存在しない。** すべて
`Theme.of(context).colorScheme.*` 経由。`Colors.*` の直接利用は
`theme_data.dart` の `Colors.transparent`（splash 無効化）のみ。

タイポグラフィも `Theme.of(context).textTheme.*` に統一されており、
インライン `TextStyle` は 2 箇所（`like_widget.dart`、`adaptive_overflow_text.dart`）のみ。
いずれも `colorScheme` の色を差し込むための `copyWith` 相当の用途。

**結論: 色とタイポは既に統制済み。#260 の実質的な作業対象は余白・角丸・サイズ・標高・不透明度。**
ただし `textTheme` は `titleLarge` / `titleMedium` / `bodyLarge` の 3 つしか
明示定義がなく、残りは Flutter デフォルトに依存している。意味ベース化には
現行の実効値を固定する作業が必要。

## 4. コンポーネント台帳

### 4.1 既存の共通コンポーネント（`lib/core/common_widget/`）

| 現行 | 行数 | Ds 化 | 備考 |
|---|---:|---|---|
| `button/filled_button.dart`（`PrimaryFilledButton` / `TertiaryFilledButton`） | 93 | する | 既に closed variant。命名を `Ds` 系へ寄せる |
| `button/outlined_button.dart` | 93 | する | 同上 |
| `button/to_profile_button.dart` / `to_search_user_button.dart` / `to_setting_button.dart` | 19-37 | **しない** | 遷移先を持つ画面固有 widget。DS ではなく feature 側の責務 |
| `dialog/base_dialog.dart` | 21 | する | 角丸 16・contentPadding などの直書きをトークン化 |
| `dialog/confirm_dialog.dart` | 58 | する | closed variant（確認・破壊的操作） |
| `dialog/loading_dialog.dart` | 43 | する | |
| `error_and_retry_widget.dart` | 122 | する | 既に named constructor で closed variant 化済み |
| `simple_empty_widget.dart` | 25 | する | empty ステートの正本 |
| `shimmer_widget.dart` | 37 | する | loading ステートの正本。`rectangular` / `circular` の closed variant |
| `adaptive_overflow_text.dart` | 42 | する | |
| `infinity_scroll_widget.dart` | 326 | 保留 | 表示だけでなくページング挙動を持つ。#261 で分離可否を判断 |
| `cupertino_refresh_indicator.dart` | 71 | する | OS 差分を内包する数少ない箇所 |
| `stickey_tab_bar_deligate.dart` | 41 | 保留 | `SliverPersistentHeaderDelegate` の実装。レイアウト基盤寄り |

### 4.2 feature 側にある重複実装の候補

| パターン | 実装箇所 | 所見 |
|---|---|---|
| shimmer による loading 表示 | `definition_tile_shimmer` / `word_tile_shimmer` / `word_page_shimmer` / `profile_tile_shimmer` / `profile_widget_shimmer` | `ShimmerWidget` の組み合わせで各所に再実装。骨格の組み方が重複 |
| リスト行（tile） | `definition_tile` / `word_tile` / `profile_tile` / `word_registered_tile` | 余白・角丸の直書きが集中。共通の行レイアウトを Ds 化する候補 |
| アイコンボタン | `self_definition_action_icon_button` / `other_user_action_icon_button` | サイズ・padding の直書きが重複 |
| 検索テキストフィールド | `search_user_text_field` / `search_word_text_field` | ほぼ同型。入力コンポーネントの最有力候補 |
| オーバーレイダイアログ | `overlay_force_update_dialog` / `overlay_in_maintenance_dialog` / `confirm_agreement_dialog` | `BaseDialog` を経由しないものがある |

### 4.3 初期コンポーネント最低セット（#261 のスコープ候補）

1. `DsFilledButton` / `DsOutlinedButton`（既存 2 種の移植）
2. `DsDialog`（`BaseDialog` 相当）+ `DsConfirmDialog`
3. `DsEmptyView` / `DsErrorView` / `DsShimmer`（空・エラー・読み込みの 3 ステート）
4. `DsListTile`（4.2 のリスト行の共通形）
5. `DsSearchField`（検索テキストフィールドの共通形）
6. `DsIconButton`（4.2 のアイコンボタン重複の共通形）

FAB は実利用が `post_definition_fab.dart` の 1 箇所のみで、遷移先と独自アニメーションを
持つため対象外（正本仕様 5 章）。

## 5. OS 差分 / light-dark 差分

### 5.1 OS 差分

- 明示的な分岐は `TargetPlatformExtension.when`（`lib/util/extension/target_platform_extension.dart`）に集約済み
- UI での実利用は `overlay_force_update_dialog.dart` の 1 箇所のみ（ストア遷移文言）。
  残りは Firebase 設定・広告 ID・端末情報といった非 UI 用途
- **一方でアイコンは 25 ファイルが `CupertinoIcons` を使い、Material の `Icons.` は 2 ファイルのみ。**
  すなわち「iOS 風アイコンを両 OS で使う」ことが事実上のデザイン判断になっている
- `CupertinoActivityIndicator` が 22 箇所、`CupertinoSliverRefreshControl` が 3 箇所

→ OS 固有差分は「明示分岐」ではなく「Cupertino 系 widget の常用」という形で存在する。
仕様ではこれを**意図的な共通デザイン言語**として明文化する。

### 5.2 light / dark 差分

- `ThemeMode` による分岐は `main.dart` の `theme` / `darkTheme` のみ
- feature UI に `Brightness` 分岐は存在せず、すべて `ColorScheme` の解決に委ねている
- `lightColorScheme` / `darkColorScheme` は `primary`（`0xFF0BBBA1`）を共有し、
  `secondary` も同値。M3 のトーナルパレットではなく手書きの対で構成されている

## 6. パイロット 2 系統の現状

### 6.1 `DictionaryEveryonePage`（47 行）

- `Gap(16)` → 固定高 `SizedBox(height: 80)` → `EdgeInsets.symmetric(horizontal: 40)` と、
  検索フィールド周辺に直書きが集中
- `AppBar` の `leading` / `actions` は `ToSettingButton` / `ToProfileButton` に分離済みで、
  移行時に触る必要がない
- 移行難度: **低**。余白と固定高のトークン化で完結する

### 6.2 `DefinitionPostPage` / `WriteDefinitionBasePage`（118 / 142 行）

- `EdgeInsets.all(24)` の本文 padding、`Gap(8)` / `Gap(16)` / `Gap(300)`
- `TextFormField` を `InputDecoration(border: InputBorder.none)` で直に使用しており、
  入力コンポーネントの Ds 化対象そのもの
- `Gap(300)` はキーボード回避のための画面固有値。トークン化せず理由をコメントで残す
- `WriteDefinitionBasePage` は既に DocBridge リンク（`@doc`）を持つ
- 移行難度: **中**。入力コンポーネントの API 設計が前提になる

## 7. 違反ベースラインの作り方（#262 への引き継ぎ）

### 7.1 安定 ID

比較の単位は次の 3 つ組とする。

```
ID = (category, path, 正規化した snippet)
```

正規化規則（`audit.dart` の `_normalize`）:

1. 文字列リテラルを `''` へマスクする（表示文言の変更で ID を変えない）
2. 連続する空白を 1 つに畳む
3. 末尾の `,` `;` を除去する

**行番号は ID に含めない。** `--tsv` の `line` 列は人が該当箇所を開くための
**診断専用**であり、比較には使わない。行番号を比較に含めると、既存違反より前への
無関係な行追加だけで以降がすべて「新規」になる。

### 7.2 ベースラインの形式と比較

同一 ID は同一ファイル内に複数回現れるため、ベースラインは
**ID → 件数の multiset** とする。`--baseline` がこの形式を出力する。

```bash
dart run tool/design_system_audit/audit.dart --baseline \
  > tool/design_system_audit/baseline.tsv
# category  path  normalized  count
```

CI の判定:

| 差分 | 結果 |
|---|---|
| ベースラインに無い ID が出現 | **失敗** |
| 既存 ID の count が増加 | **失敗** |
| 既存 ID の count が減少 / ID が消滅 | 成功（ベースライン更新を促す） |

件数だけの比較では「既存 1 件の削除と新規 1 件の追加」が相殺されるが、
ID 単位で見るため相殺は起きない。

### 7.3 ベースラインの更新が許される場合

1. 既存 UI を Ds へ移行し、count が減る PR
2. ファイル移動 / rename を含む PR — ID に `path` を含むため全件が新規扱いになる。
   この場合はベースラインの再生成を許可する。ただし `path` を除いた
   `(category, 正規化 snippet)` 別の合計 count が増えていないことを PR で確認し、
   理由を PR 本文に記す

上記以外での「count が増える方向のベースライン更新」を禁止する。

`path` を ID から外せば move に強くなるが、別ファイルへのコピー&ペーストを見逃し、
修正箇所も特定できなくなるため採用しない。AST fingerprint は #262 で
「AST ベースの custom lint と軽量スクリプトを比較して方式を決める」ことになっており、
本 Issue では先取りしない。

### 7.4 色の扱い

色は現時点で 0 件のため、`color-literal` / `color-named` は
**ベースラインなしの即時失敗**ルールにできる。
