import { z } from "@hono/zod-openapi";
import { definitionResponseSchema } from "./definition";
import { wordSummarySchema } from "./word";

/** あなたの辞書の概要画面用の合成 DTO */
export const myDictionaryOverviewSchema = z
  .object({
    definedWordCount: z.number().int(),
    savedWordCount: z.number().int(),
    recentDefinitions: z.array(definitionResponseSchema),
  })
  .openapi("MyDictionaryOverview");

/** 定義済みの言葉一覧（言葉単位・状態別件数つき） */
export const definedWordItemSchema = z
  .object({
    word: wordSummarySchema,
    publicCount: z.number().int(),
    privateCount: z.number().int(),
  })
  .openapi("DefinedWordItem");

/** 他ユーザーの公開辞書の一覧アイテム（言葉単位・公開定義のみ） */
export const userDictionaryItemSchema = z
  .object({
    word: wordSummarySchema,
    publicCount: z.number().int(),
  })
  .openapi("UserDictionaryItem");

/** 保存した言葉の一覧アイテム。定義済みかどうかはシステム側で判定して返す。 */
export const savedWordItemSchema = z
  .object({
    word: wordSummarySchema,
    isDefinedByMe: z.boolean(),
    publicCount: z.number().int(),
  })
  .openapi("SavedWordItem");
