import { OpenAPIHono, createRoute, z } from "@hono/zod-openapi";
import type { AuthenticationVariables } from "../auth/middleware";
import { BrowseService } from "../browse/browse-service";
import { paginatedSchema, paginationQuerySchema } from "../schemas/common";
import { definitionResponseSchema } from "../schemas/definition";
import {
  createWordRequestSchema,
  createWordResponseSchema,
  maxReadingLength,
  maxWordLength,
  updateWordRequestSchema,
  wordConflictResponseSchema,
  wordListItemSchema,
  wordLookupResponseSchema,
  wordResponseSchema,
} from "../schemas/word";
import { WordConflictError, WordService } from "../words/word-service";
import { authErrorResponses, authenticatedSecurity, errorContent, jsonContent } from "./helpers";

const wordIdParams = z.object({ id: z.string() });

const createWordRoute = createRoute({
  method: "post",
  path: "/words",
  tags: ["words"],
  summary: "言葉を明示登録する",
  description:
    "表記とよみはサーバーで前後トリム + NFC 正規化してから (表記, よみ) の完全一致で解決する。新規作成は 201、既存言葉への明示登録・公開昇格は 200。表記が同じでもよみが異なれば別の言葉として新規作成する。",
  security: authenticatedSecurity,
  request: {
    body: jsonContent(createWordRequestSchema, "登録内容"),
  },
  responses: {
    201: jsonContent(createWordResponseSchema, "新規に作成・明示登録された言葉"),
    200: jsonContent(createWordResponseSchema, "既存言葉への明示登録（公開昇格・再登録を含む）"),
    404: errorContent("未登録・削除済みユーザー（user_not_found）"),
    ...authErrorResponses,
  },
});

const lookupWordRoute = createRoute({
  method: "get",
  path: "/words/lookup",
  tags: ["words"],
  summary: "登録前の既存語チェック",
  description:
    "表記とよみをサーバーで前後トリム + NFC 正規化し、(表記, よみ) の完全一致で解決する。閲覧者にとって公開されている言葉だけを返し、非公開の言葉は存在を秘匿して null を返す。よみの文字種は検証しない（一致しなければ null になる）。",
  security: authenticatedSecurity,
  request: {
    query: z.object({
      word: z.string().min(1).max(maxWordLength),
      reading: z.string().min(1).max(maxReadingLength),
    }),
  },
  responses: {
    200: jsonContent(wordLookupResponseSchema, "公開されている一致した言葉。なければ null"),
    ...authErrorResponses,
  },
});

const listWordsRoute = createRoute({
  method: "get",
  path: "/words",
  tags: ["words"],
  summary: "みんなの辞書の言葉一覧（読み順）",
  security: authenticatedSecurity,
  request: {
    query: paginationQuerySchema.extend({
      // あかさたな行での絞り込み（words.reading_sub_group のラベル）
      subGroup: z.string().optional(),
      filter: z.enum(["all", "defined", "undefined"]).default("all"),
      // 表示中の言葉の絞り込み検索（表記・よみの部分一致）
      q: z.string().optional(),
    }),
  },
  responses: {
    200: jsonContent(paginatedSchema(wordListItemSchema), "言葉一覧（読み順）"),
    ...authErrorResponses,
  },
});

const getWordRoute = createRoute({
  method: "get",
  path: "/words/{id}",
  tags: ["words"],
  summary: "言葉ページのヘッダ情報を取得",
  security: authenticatedSecurity,
  request: { params: wordIdParams },
  responses: {
    200: jsonContent(wordResponseSchema, "言葉"),
    404: errorContent("言葉が存在しない（word_not_found）"),
    ...authErrorResponses,
  },
});

const updateWordRoute = createRoute({
  method: "patch",
  path: "/words/{id}",
  tags: ["words"],
  summary: "作成者修正（表記・よみ）",
  description:
    "作成後 1 時間以内かつ他ユーザーによる操作（定義投稿・保存）がない場合のみ、登録者本人が修正できる。条件はサーバーで検証する。",
  security: authenticatedSecurity,
  request: {
    params: wordIdParams,
    body: jsonContent(updateWordRequestSchema, "修正内容"),
  },
  responses: {
    200: jsonContent(wordResponseSchema, "修正後の言葉"),
    403: errorContent(
      "修正条件を満たさない（word_not_editable: 期限超過・他ユーザー操作あり・登録者以外）",
    ),
    404: errorContent(
      "言葉が存在しない（word_not_found）・未登録・削除済みユーザー（user_not_found）",
    ),
    409: {
      content: { "application/json": { schema: wordConflictResponseSchema } },
      description: "修正後の (表記, よみ) が登録済み（word_already_exists）",
    },
    ...authErrorResponses,
  },
});

const listWordDefinitionsRoute = createRoute({
  method: "get",
  path: "/words/{id}/definitions",
  tags: ["words"],
  summary: "言葉ページの定義一覧",
  description:
    "scope=mine は自分の定義、scope=others は他者の公開定義のみ、scope=all は自分 + 他者の公開定義の混在（旧 UI の言葉トップのパリティ）。sort=reactions はいいね数順。",
  security: authenticatedSecurity,
  request: {
    params: wordIdParams,
    query: paginationQuerySchema.extend({
      scope: z.enum(["mine", "others", "all"]).default("all"),
      sort: z.enum(["newest", "reactions"]).default("newest"),
    }),
  },
  responses: {
    200: jsonContent(paginatedSchema(definitionResponseSchema), "定義一覧"),
    404: errorContent("言葉が存在しない（word_not_found）"),
    ...authErrorResponses,
  },
});

const saveWordRoute = createRoute({
  method: "put",
  path: "/words/{id}/save",
  tags: ["words"],
  summary: "言葉を保存",
  security: authenticatedSecurity,
  request: { params: wordIdParams },
  responses: {
    204: { description: "保存完了（冪等）" },
    404: errorContent(
      "言葉が存在しない（word_not_found）・未登録・削除済みユーザー（user_not_found）",
    ),
    ...authErrorResponses,
  },
});

const unsaveWordRoute = createRoute({
  method: "delete",
  path: "/words/{id}/save",
  tags: ["words"],
  summary: "言葉の保存を解除",
  security: authenticatedSecurity,
  request: { params: wordIdParams },
  responses: {
    204: { description: "解除完了（冪等）" },
    ...authErrorResponses,
  },
});

type WordRouteEnvironment = {
  Bindings: { AVATAR_BASE_URL: string; DB: D1Database };
  Variables: AuthenticationVariables;
};

/** 修正時の (表記, よみ) 重複は 409 と既存の言葉で返す（レスポンス形状が通常のエラーと異なる）。 */
function wordConflictResponse(error: WordConflictError) {
  return {
    error: { code: error.code, message: error.message },
    existingWord: error.existingWord,
  };
}

export const wordRoutes = new OpenAPIHono<WordRouteEnvironment>()
  .openapi(createWordRoute, async (context) => {
    const result = await new WordService(context.env).create(
      context.get("firebaseUid"),
      context.req.valid("json"),
    );
    const body = { ...result.word, registrationResult: result.result };
    return context.json(body, result.result === "created" ? 201 : 200);
  })
  // `/words/{id}` より先に登録して、静的セグメントとして解決させる。
  .openapi(lookupWordRoute, async (context) => {
    const word = await new WordService(context.env).lookupPublic(
      context.get("firebaseUid"),
      context.req.valid("query"),
    );
    return context.json({ word }, 200);
  })
  .openapi(listWordsRoute, async (context) => {
    const result = await new WordService(context.env).list(
      context.get("firebaseUid"),
      context.req.valid("query"),
    );
    return context.json(result, 200);
  })
  .openapi(getWordRoute, async (context) => {
    const word = await new WordService(context.env).get(
      context.get("firebaseUid"),
      context.req.valid("param").id,
    );
    return context.json(word, 200);
  })
  .openapi(updateWordRoute, async (context) => {
    const service = new WordService(context.env);
    try {
      const word = await service.update(
        context.get("firebaseUid"),
        context.req.valid("param").id,
        context.req.valid("json"),
      );
      return context.json(word, 200);
    } catch (error) {
      if (error instanceof WordConflictError) {
        return context.json(wordConflictResponse(error), 409);
      }
      throw error;
    }
  })
  .openapi(listWordDefinitionsRoute, async (context) => {
    const result = await new BrowseService(context.env).listWordDefinitions(
      context.get("firebaseUid"),
      context.req.valid("param").id,
      context.req.valid("query"),
    );
    return context.json(result, 200);
  })
  .openapi(saveWordRoute, async (context) => {
    await new WordService(context.env).save(
      context.get("firebaseUid"),
      context.req.valid("param").id,
    );
    return context.body(null, 204);
  })
  .openapi(unsaveWordRoute, async (context) => {
    await new WordService(context.env).unsave(
      context.get("firebaseUid"),
      context.req.valid("param").id,
    );
    return context.body(null, 204);
  });
