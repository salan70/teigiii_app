import { z } from "@hono/zod-openapi";

/** 日時は ISO 8601 UTC 文字列。DB 内部は unix ミリ秒 INTEGER で持ち、境界で変換する。 */
export const isoDateTime = z.iso.datetime();

/**
 * 統一エラー形式。code は機械判定用（例: word_already_exists / edit_window_expired）。
 */
export const errorResponseSchema = z
  .object({
    error: z.object({
      code: z.string().openapi({ example: "word_already_exists" }),
      message: z.string(),
    }),
  })
  .openapi("ErrorResponse");

/** keyset カーソルページネーションの共通クエリ。カーソルは不透明文字列。 */
export const paginationQuerySchema = z.object({
  cursor: z.string().optional(),
  limit: z.coerce.number().int().min(1).max(50).default(20),
});

/** ページネーションレスポンスの共通ラッパー */
export function paginatedSchema<T extends z.ZodType>(itemSchema: T) {
  return z.object({
    items: z.array(itemSchema),
    nextCursor: z.string().nullable(),
  });
}
