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

/** 登録時に同一表記が存在した場合の 409 レスポンス。既存の言葉を返す。 */
export const wordConflictResponseSchema = errorResponseSchema
  .extend({
    existingWord: wordSummarySchema,
  })
  .openapi("WordConflictResponse");
