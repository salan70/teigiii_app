---
name: implementing-ui-with-design-system
description: mobile_app の UI 実装をデザインシステム経由で行う。Flutter のウィジェット・画面・余白・色・タイポグラフィ・Ds コンポーネントを追加または変更する時に使用し、既存 Ds の探索から例外申請・必須検証までの判断順序を示す。
---

# デザインシステムによる UI 実装

`mobile_app/` の UI を実装・変更するとき、人間と AI が同じ選択手順を踏むための判断順序を定める。

**開始時の宣言:** 「implementing-ui-with-design-system スキルを使用して、デザインシステム経由で UI を実装します。」

## 正本

本スキルは仕様を持たない。値・命名・基準はすべて次を参照する。

| 参照先 | 内容 |
|---|---|
| `doc/specs/mobile-app-design-system.md` | 仕様の正本。トークン一覧、選択フロー、コンポーネント規約、運用ルール |
| `mobile_app/lib/core/design_system/` | 型付き Dart API の正本。`token/` と `component/` |
| `mobile_app/widgetbook/use_cases/` + `just mobile-widgetbook` | 見た目と状態の正本 |
| `doc/specs/mobile-app-design-system-audit.md` | 移行時の現状スナップショット |

**仕様本文をここへ複製しない。** 迷ったら仕様を開く。

## 判断順序

上から順に評価し、成立した時点で止める。

1. **既存の Ds コンポーネント / variant を検索する。**
   `ls mobile_app/lib/core/design_system/component/` で一覧し、`rg` で用途に近い型・名前付きコンストラクタを探す。
   既存 variant で足りるなら新規実装しない。
2. **Widgetbook use case と仕様を確認する。**
   `mobile_app/widgetbook/use_cases/` を読み、候補コンポーネントの light / dark・状態・長文ケースを把握する。
   カタログの目視確認はローカル実行が要るため、実行できない環境では use case のコードで代替し、目視未確認であることを報告する。
   仕様の「コンポーネント API 規約」で公開 API の受け取り可否を確認する。
3. **トークンと既存コンポーネントを組み合わせて実装する。**
   spacing / radius / size / elevation / opacity と色・文字トークンの選択は仕様 3 章の選択フローに従う。
   配置だけを担う widget は直接利用してよい（仕様 4 章の境界）。
4. **組み合わせで表現できない場合、新しい semantic use case かを判断する。**
   トークン追加は仕様「トークン追加基準」を、コンポーネント追加は「コンポーネント化する / しないの判断基準」を満たすかで判定する。
   満たすなら仕様・Widgetbook use case・テストを同一 PR で追加する。満たさないなら 5 へ。
5. **例外として直書きする場合は、理由と追跡 Issue を書く。**
   仕様「例外申請」節の形式（`ignore` コメント + 日本語の理由 1 行以上 + 追跡 Issue 番号）に従う。
   理由・追跡 Issue のない抑制は禁止。追跡 Issue がなければ `collaborating-on-github` で作成する。
6. **必須検証を実行する。**

## 破壊的な公開 API 変更

`Ds*` の公開 API を破壊的に変更するときは、**同一 PR で**利用箇所すべて・仕様・Widgetbook use case・対応するテストを更新する。
どれか 1 つでも次 PR に送らない。詳細な手順は仕様「破壊的な公開 API 変更」節を参照。

## 必須検証

完了を宣言する前に実行し、結果をエビデンスとして示す。

```bash
just mobile-analyze      # lint / format
just mobile-test         # unit / widget / a11y（golden は除外）
just mobile-ds-check     # 直書き違反のベースライン比較。色は即時失敗
just docbridge-check     # 仕様とコード宣言のリンク整合
```

ローカル限定（CI では実行しない）:

```bash
just mobile-widgetbook   # カタログを起動して目視確認
just mobile-test-golden  # 見た目を変えない移行の証明。生成物はコミットする
```

Cloud VM ではデバイス・シミュレータがなく `just mobile-widgetbook` と golden 生成を実行できない。
実行できない場合は未実施であることと、ローカルで必要な確認内容を報告する。

見た目の変化を伴う変更では、golden 差分を意図として説明できることを確認する。

## 完了

- 選んだコンポーネント / トークンと、その選択理由を報告する
- 例外申請を行った場合は、理由と追跡 Issue 番号を報告する
- 仕様・Widgetbook・テストの更新要否を明示する（不要な場合はその理由）
