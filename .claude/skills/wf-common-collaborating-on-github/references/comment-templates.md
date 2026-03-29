# コメントテンプレート

## レビュースコープの確認（必須）

```txt
レビュー対応スコープを選択してください:

- minimum: 必須修正項目のみ対応
- recommended: minimum + 効果の高い改善も対応

どちらのスコープで進めるか指定してください（明示的な選択がない限り作業を開始しません）。
```

## レビュースコープの再確認（スコープ外の作業が必要な場合）

```txt
確認が必要です。現在のスコープ（{current_scope}）を超える修正が必要です。

- 追加作業: {description}
- 影響範囲: {affected_area}

スコープを拡大するか、現在の範囲内に留めるか選択してください。
```

## Issue の進捗コメント

```txt
進捗報告:

- 完了: {what_was_done}
- 結果: {outcome}
- 次のアクション: {next_step}
- ブロッカー: {none_or_description}
```

## PR レビュー対応コメント

```txt
レビューありがとうございます。対応内容は以下の通りです:

- カテゴリ: {must-fix / question / discussion}
- フィードバック: {summary}
- 実施した対応: {fix_description}
- 補足: {additional_context_if_needed}
```

## 先送り（延期）コメント

```txt
フィードバックありがとうございます。
この項目は先送りとし、スレッドは解決しません。

- 理由: {why_deferred}
- 次のアクション: {planned_approach}
- 時期: {YYYY-MM-DD or estimate}
```

## PR レビュー対応完了コメント

```txt
レビュー対応完了。

- スコープ: {minimum / recommended}
- 返信済みスレッド: {count}
- 解決済みスレッド: {count}
- 先送り: {count}
- 先送り一覧: {none / #comment-id ...}
- 残項目: {none / description}
```
