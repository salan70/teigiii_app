import { z } from "@hono/zod-openapi";
import { isoDateTime } from "./common";
import { definitionResponseSchema } from "./definition";
import { wordSummarySchema } from "./word";

/** 新しい公開定義のアクティビティ */
export const definitionActivitySchema = z
  .object({
    type: z.literal("definition"),
    occurredAt: isoDateTime,
    definition: definitionResponseSchema,
  })
  .openapi("DefinitionActivity");

/** 新しい言葉の登録アクティビティ。登録者は表示しないため word のみ返す。 */
export const wordRegisteredActivitySchema = z
  .object({
    type: z.literal("wordRegistered"),
    occurredAt: isoDateTime,
    word: wordSummarySchema,
  })
  .openapi("WordRegisteredActivity");

/**
 * 「見つける」の混在フィードアイテム。
 * discriminator を明示し、Dart クライアント生成器での oneOf 互換を確保する。
 */
export const discoverFeedItemSchema = z
  .discriminatedUnion("type", [definitionActivitySchema, wordRegisteredActivitySchema])
  .openapi("DiscoverFeedItem");
