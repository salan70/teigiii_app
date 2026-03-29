# Instinct Engine — 抽出・マッチング・書き込み手順

## データファイル

`~/.claude/instincts/instincts.json`

ファイルが存在しない場合、ディレクトリとファイルを作成する:

```json
{"version": 2, "instincts": []}
```

## 収集手順（/learn または Stop フック後）

### Step 1: セッション分析

現在のセッションを振り返り、以下を特定する:

1. **成功パターン**: うまくいったアプローチ、効果的だった手法
2. **失敗パターン**: エラーを引き起こした、またはユーザーに修正されたアプローチ
3. **発見**: プロジェクト固有の規約、ツールの特性、ドメイン知識

各パターンは以下の形式で抽出する:
- **pattern**: 簡潔な自然言語の行動指針（「〜する」「〜を避ける」形式）
- **context**: 関連タグ（言語名、フレームワーク名、ドメイン名）

### Step 2: 既存 instinct とのマッチング

instincts.json を読み込み、抽出した各パターンについて:

1. **意味的に同じ instinct が存在する場合**: observations を +1、confidence を +0.15（上限 1.0）、last_seen と sources を更新
2. **矛盾する instinct が存在する場合**: 既存 instinct の confidence を -0.3。矛盾の判定基準:
   - そのパターンに従った結果、エラー・テスト失敗・ユーザーからの修正指示が発生した
   - 曖昧な場合は信頼度を変更しない（保守的アプローチ）
3. **新規パターンの場合**: 新しい instinct を以下のテンプレートで追加:
   ```json
   {
     "id": "inst-YYYYMMDD-NNN",
     "pattern": "抽出したパターン文字列",
     "context": ["関連タグ"],
     "confidence": 0.5,
     "observations": 1,
     "first_seen": "YYYY-MM-DD",
     "last_seen": "YYYY-MM-DD",
     "sources": ["session-YYYY-MM-DD"]
   }
   ```
4. **ユーザーが明示的に否定した場合**: confidence を 0.0 に設定（無効化）

### Step 3: ID 生成

- 形式: `inst-YYYYMMDD-NNN`（NNN は 3 桁ゼロパディング）
- instincts.json 内の同日 ID の最大連番 +1
- 999 を超えた場合は 4 桁に拡張

### Step 4: 書き込み

更新した instincts.json を書き戻す。

### Step 5: 結果報告

追加・更新した instinct をユーザーに報告する。

## 表示手順（/instincts）

instincts.json を読み込み、confidence >= 0.5 のものを context タグ別・信頼度降順で以下の形式で表示:

```
## Instincts (confidence >= 0.5)

### {context} ({count})
- {confidence bar} `{pattern}` ({confidence}, {observations}回確認)
```

信頼度バー: 0.0-0.2=●○○○○, 0.2-0.4=●●○○○, 0.4-0.6=●●●○○, 0.6-0.8=●●●●○, 0.8-1.0=●●●●●

confidence < 0.5 の instinct は表示しないが、`/instincts --all` で全件表示可能。

## 他スキルからの参照

wf-01（brainstorming）や wf-03（writing-plans）の開始時:

1. instincts.json を読み込む
2. 現在の作業に関連する context タグの instinct を抽出
3. confidence >= 0.5 のものを簡潔に表示
4. 設計・計画に反映できるパターンがあれば提案する
