import { z } from "@hono/zod-openapi";
import { isoDateTime } from "./common";
import { userSummarySchema } from "./user";
import { wordSummarySchema } from "./word";

// 現行実装（definition_for_write.dart）に準拠
export const maxBodyLength = 500;

export const definitionStatusSchema = z
  .enum(["draft", "public", "private"])
  .openapi("DefinitionStatus");

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
    // 初めて public/private で確定した時刻。draft は null。
    finalizedAt: isoDateTime.nullable(),
    // 本文の編集期限（finalized_at + 1 時間）。サーバー時計を正とするため明示的に返す。
    editableUntil: isoDateTime.nullable(),
    createdAt: isoDateTime,
    updatedAt: isoDateTime,
  })
  .openapi("DefinitionResponse");

export const createDefinitionRequestSchema = z
  .object({
    wordId: z.string(),
    body: z.string().min(1).max(maxBodyLength),
    status: definitionStatusSchema,
  })
  .openapi("CreateDefinitionRequest");

/**
 * 本文編集・状態遷移・（下書きのみ）言葉の変更。
 * 許可される遷移: draft→public/private、public↔private。下書き戻し・期限後の本文変更はサーバーで拒否する。
 */
export const updateDefinitionRequestSchema = z
  .object({
    wordId: z.string().optional(),
    body: z.string().min(1).max(maxBodyLength).optional(),
    status: definitionStatusSchema.optional(),
  })
  .openapi("UpdateDefinitionRequest");
