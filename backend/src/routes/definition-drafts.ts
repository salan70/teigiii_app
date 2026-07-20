import { OpenAPIHono, createRoute, z } from "@hono/zod-openapi";
import type { AuthenticationVariables } from "../auth/middleware";
import {
  DefinitionDraftService,
  WordReadingMismatchError,
} from "../definition-drafts/definition-draft-service";
import { paginatedSchema, paginationQuerySchema } from "../schemas/common";
import {
  definitionDraftResponseSchema,
  finalizeDefinitionDraftRequestSchema,
  putDefinitionDraftRequestSchema,
  wordReadingMismatchResponseSchema,
} from "../schemas/definition-draft";
import { definitionResponseSchema } from "../schemas/definition";
import { authErrorResponses, authenticatedSecurity, errorContent, jsonContent } from "./helpers";

const draftIdParams = z.object({ id: z.uuid() });

const putDraftRoute = createRoute({
  method: "put",
  path: "/definition-drafts/{id}",
  tags: ["definition-drafts"],
  summary: "定義 Draft を冪等に保存",
  security: authenticatedSecurity,
  request: {
    params: draftIdParams,
    body: jsonContent(putDefinitionDraftRequestSchema, "Draft の入力内容"),
  },
  responses: {
    200: jsonContent(definitionDraftResponseSchema, "保存された Draft"),
    400: errorContent("全項目空（draft_empty）"),
    404: errorContent("Draft・言葉・ユーザーが存在しない"),
    ...authErrorResponses,
  },
});

const getDraftRoute = createRoute({
  method: "get",
  path: "/definition-drafts/{id}",
  tags: ["definition-drafts"],
  summary: "本人の定義 Draft を取得",
  security: authenticatedSecurity,
  request: { params: draftIdParams },
  responses: {
    200: jsonContent(definitionDraftResponseSchema, "Draft"),
    404: errorContent("本人の未確定 Draft が存在しない（definition_draft_not_found）"),
    ...authErrorResponses,
  },
});

const listDraftsRoute = createRoute({
  method: "get",
  path: "/me/definition-drafts",
  tags: ["definition-drafts"],
  summary: "本人の未確定 Draft 一覧（更新日時降順）",
  security: authenticatedSecurity,
  request: { query: paginationQuerySchema },
  responses: {
    200: jsonContent(paginatedSchema(definitionDraftResponseSchema), "Draft 一覧"),
    ...authErrorResponses,
  },
});

const deleteDraftRoute = createRoute({
  method: "delete",
  path: "/definition-drafts/{id}",
  tags: ["definition-drafts"],
  summary: "本人の Draft を冪等に削除",
  security: authenticatedSecurity,
  request: { params: draftIdParams },
  responses: { 204: { description: "削除完了" }, ...authErrorResponses },
});

const finalizeDraftRoute = createRoute({
  method: "post",
  path: "/definition-drafts/{id}/finalize",
  tags: ["definition-drafts"],
  summary: "Draft を定義として冪等に確定",
  security: authenticatedSecurity,
  request: {
    params: draftIdParams,
    body: jsonContent(finalizeDefinitionDraftRequestSchema, "既存語のよみ不一致確認"),
  },
  responses: {
    200: jsonContent(definitionResponseSchema, "確定済み定義"),
    400: errorContent("必須項目不足または入力不正（draft_incomplete / draft_invalid）"),
    404: errorContent("本人の Draft・固定済み言葉が存在しない"),
    409: {
      content: { "application/json": { schema: wordReadingMismatchResponseSchema } },
      description: "同一表記の既存語とよみが異なる（word_reading_mismatch）",
    },
    ...authErrorResponses,
  },
});

type DraftRouteEnvironment = {
  Bindings: { AVATAR_BASE_URL: string; DB: D1Database };
  Variables: AuthenticationVariables;
};

export const definitionDraftRoutes = new OpenAPIHono<DraftRouteEnvironment>()
  .openapi(putDraftRoute, async (context) => {
    const draft = await new DefinitionDraftService(context.env).put(
      context.get("firebaseUid"),
      context.req.valid("param").id,
      context.req.valid("json"),
    );
    return context.json(draft, 200);
  })
  .openapi(getDraftRoute, async (context) => {
    const draft = await new DefinitionDraftService(context.env).get(
      context.get("firebaseUid"),
      context.req.valid("param").id,
    );
    return context.json(draft, 200);
  })
  .openapi(listDraftsRoute, async (context) => {
    const query = context.req.valid("query");
    const drafts = await new DefinitionDraftService(context.env).list(
      context.get("firebaseUid"),
      query.limit,
      query.cursor,
    );
    return context.json(drafts, 200);
  })
  .openapi(deleteDraftRoute, async (context) => {
    await new DefinitionDraftService(context.env).delete(
      context.get("firebaseUid"),
      context.req.valid("param").id,
    );
    return context.body(null, 204);
  })
  .openapi(finalizeDraftRoute, async (context) => {
    try {
      const definition = await new DefinitionDraftService(context.env).finalize(
        context.get("firebaseUid"),
        context.req.valid("param").id,
        context.req.valid("json").confirmReadingMismatch,
      );
      return context.json(definition, 200);
    } catch (error) {
      if (error instanceof WordReadingMismatchError) {
        return context.json(
          {
            error: { code: "word_reading_mismatch" as const, message: error.message },
            existingWord: error.existingWord,
          },
          409,
        );
      }
      throw error;
    }
  });
