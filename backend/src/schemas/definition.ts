import { z } from "@hono/zod-openapi";
import { isoDateTime } from "./common";
import { userSummarySchema } from "./user";
import { maxReadingLength, maxWordLength, readingPattern, wordSummarySchema } from "./word";

// 現行実装（definition_for_write.dart）に準拠
export const maxBodyLength = 500;

export const definitionStatusSchema = z.enum(["public", "private"]).openapi("DefinitionStatus");

/** 定義の合成 DTO。word / author / いいね情報を埋め込んで返す。 */
export const definitionResponseSchema = z
  .object({
    id: z.string(),
    word: wordSummarySchema,
    author: userSummarySchema,
    body: z.string(),
    status: definitionStatusSchema,
    isEdited: z.boolean(),
    likesCount: z.number().int(),
    isLikedByMe: z.boolean(),
    // 作成（確定）時刻。
    finalizedAt: isoDateTime,
    // 本文の編集期限（finalized_at + 1 時間）。サーバー時計を正とするため明示的に返す。
    editableUntil: isoDateTime,
    createdAt: isoDateTime,
    updatedAt: isoDateTime,
  })
  .openapi("DefinitionResponse");

export const createDefinitionRequestSchema = z
  .object({
    // 旧クライアント互換: 既存 wordId を直接指定する
    wordId: z.string().optional(),
    // 新クライアント: 言葉の表記・よみを渡し、サーバー側で解決／内部作成する
    word: z.string().min(1).max(maxWordLength).optional(),
    reading: z.string().min(1).max(maxReadingLength).regex(readingPattern).optional(),
    body: z.string().min(1).max(maxBodyLength),
    status: definitionStatusSchema,
  })
  .superRefine((value, ctx) => {
    const hasWordId = value.wordId !== undefined && value.wordId !== "";
    const hasWord = value.word !== undefined;
    const hasReading = value.reading !== undefined;
    if (hasWordId) {
      if (hasWord || hasReading) {
        ctx.addIssue({
          code: "custom",
          message: "wordId and word/reading are mutually exclusive",
          path: ["wordId"],
        });
      }
      return;
    }
    if (!hasWord || !hasReading) {
      ctx.addIssue({
        code: "custom",
        message: "either wordId or both word and reading are required",
        path: hasWord ? ["reading"] : ["word"],
      });
    }
  })
  .openapi("CreateDefinitionRequest");

/**
 * 本文編集・状態遷移。
 * 許可される遷移: public↔private。作成後の wordId 変更・期限後の本文変更はサーバーで拒否する。
 */
export const updateDefinitionRequestSchema = z
  .object({
    wordId: z.string().optional(),
    body: z.string().min(1).max(maxBodyLength).optional(),
    status: definitionStatusSchema.optional(),
  })
  .openapi("UpdateDefinitionRequest");
