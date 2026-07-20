import { z } from "@hono/zod-openapi";
import { isoDateTime } from "./common";
import { maxBodyLength } from "./definition";
import { maxReadingLength, maxWordLength, readingPattern, wordSummarySchema } from "./word";

export const definitionVisibilitySchema = z
  .enum(["public", "private"])
  .openapi("DefinitionVisibility");

export const definitionDraftResponseSchema = z
  .object({
    id: z.uuid(),
    wordId: z.string().nullable(),
    word: z.string(),
    reading: z.string(),
    body: z.string(),
    visibility: definitionVisibilitySchema,
    finalizedDefinitionId: z.string().nullable(),
    createdAt: isoDateTime,
    updatedAt: isoDateTime,
  })
  .openapi("DefinitionDraftResponse");

export const putDefinitionDraftRequestSchema = z
  .object({
    wordId: z.string().nullable().optional(),
    word: z.string().max(maxWordLength),
    reading: z.string().max(maxReadingLength),
    body: z.string().max(maxBodyLength),
    visibility: definitionVisibilitySchema,
  })
  .openapi("PutDefinitionDraftRequest");

export const finalizeDefinitionDraftRequestSchema = z
  .object({
    confirmReadingMismatch: z.boolean().default(false),
  })
  .openapi("FinalizeDefinitionDraftRequest");

export const wordReadingMismatchResponseSchema = z
  .object({
    error: z.object({ code: z.literal("word_reading_mismatch"), message: z.string() }),
    existingWord: wordSummarySchema,
  })
  .openapi("WordReadingMismatchResponse");

export { maxBodyLength, maxReadingLength, maxWordLength, readingPattern };
