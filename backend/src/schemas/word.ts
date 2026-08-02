import { z } from "@hono/zod-openapi";
import { errorResponseSchema } from "./common";

// 現行実装（definition_for_write.dart / string_regex.dart）に準拠
export const maxWordLength = 30;
export const maxReadingLength = 50;

/** よみに使える文字種（かな・英数字・基本的な記号のみ。漢字不可）。現行の combinedRegex と同一 */
export const readingPattern =
  /^[ ぁ-んゔァ-ンヴヷヸヹヺa-zA-Z0-9!#$%&()*+,\-./:;<=>?@[\\\]^_`{|}~（）「」『』ー]+$/;

export const wordSummarySchema = z
  .object({
    id: z.string(),
    word: z.string(),
    reading: z.string(),
  })
  .openapi("WordSummary");

/** みんなの辞書・検索結果の一覧アイテム */
export const wordListItemSchema = wordSummarySchema
  .extend({
    readingSubGroup: z.string(),
    publicDefinitionCount: z.number().int(),
  })
  .openapi("WordListItem");

/** 言葉ページのヘッダ情報 */
export const wordResponseSchema = wordSummarySchema
  .extend({
    readingSubGroup: z.string(),
    publicDefinitionCount: z.number().int(),
    isSavedByMe: z.boolean(),
    // 作成者修正（作成後 1 時間以内 + 他ユーザーの定義投稿・保存なし）が可能か。
    // 登録者が誰かは返さない（内部記録のみ）。
    isEditableByMe: z.boolean(),
  })
  .openapi("WordResponse");

/**
 * 明示登録の結果種別。
 *
 * - `created`: 言葉を新規作成した
 * - `promoted`: 既存の言葉に対し、最初の明示登録をこのリクエストが行った
 * - `alreadyPublic`: 既存の言葉で、この登録の前から明示登録されていた
 */
export const wordRegistrationResultSchema = z
  .enum(["created", "promoted", "alreadyPublic"])
  .openapi("WordRegistrationResult");

/** `POST /v1/words` のレスポンス。言葉に加えて登録結果の種別を返す。 */
export const createWordResponseSchema = wordResponseSchema
  .extend({
    registrationResult: wordRegistrationResultSchema,
  })
  .openapi("CreateWordResponse");

/** `GET /v1/words/lookup` のレスポンス。公開されている言葉がなければ null。 */
export const wordLookupResponseSchema = z
  .object({
    word: wordSummarySchema.nullable(),
  })
  .openapi("WordLookupResponse");

export const createWordRequestSchema = z
  .object({
    word: z.string().min(1).max(maxWordLength),
    reading: z.string().min(1).max(maxReadingLength).regex(readingPattern),
  })
  .openapi("CreateWordRequest");

export const updateWordRequestSchema = z
  .object({
    word: z.string().min(1).max(maxWordLength).optional(),
    reading: z.string().min(1).max(maxReadingLength).regex(readingPattern).optional(),
  })
  .openapi("UpdateWordRequest");

/** 修正時に同一表記が存在した場合の 409 レスポンス。既存の言葉を返す。 */
export const wordConflictResponseSchema = errorResponseSchema
  .extend({
    existingWord: wordSummarySchema,
  })
  .openapi("WordConflictResponse");
