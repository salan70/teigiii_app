/**
 * 配信済み v1.2.1+11 との後方互換シム（#322）。
 *
 * v1.2.1 の生成クライアントは `MyDictionaryOverview` / `DefinedWordItem` の `draftCount` を
 * 必須キーとして検査するため、これを欠いたレスポンスを返すと「あなたの辞書」一覧が parse エラーで落ちる。
 * 下書き機能自体は廃止済みで、サーバーが返せる値は常に 0 になる。
 *
 * 契約（OpenAPI）には戻さず、配信レスポンスにだけ定数を足す。契約に必須で戻すと、
 * シム撤去時にその時点の配信済みアプリを再び壊すため。`OpenAPIHono` はレスポンスを検証しないので、
 * スキーマ外のキーはそのまま wire に出る。
 *
 * `min_app_version_ios` / `min_app_version_android` を v1.2.1 より上へ引き上げた後、
 * このファイルと `routes/me.ts` の呼び出し、`worker-test/compat-v1_2_1.workers.ts` を削除する。
 */

/**
 * レスポンス body に `draftCount: 0` を足す。型は契約どおりのまま扱う。
 *
 * @doc doc/specs/workers-api-server.md#配信済みアプリとの後方互換
 */
export function withDraftCount<T extends object>(value: T): T {
  return { ...value, draftCount: 0 } as T;
}

/** ページレスポンスの各要素に `draftCount: 0` を足す。 */
export function withDraftCountItems<T extends { items: object[] }>(page: T): T {
  return { ...page, items: page.items.map(withDraftCount) } as T;
}
