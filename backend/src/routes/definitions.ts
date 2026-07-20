import { OpenAPIHono, createRoute, z } from "@hono/zod-openapi";
import type { AuthenticationVariables } from "../auth/middleware";
import { DefinitionService } from "../definitions/definition-service";
import { paginatedSchema, paginationQuerySchema } from "../schemas/common";
import {
  createDefinitionRequestSchema,
  definitionResponseSchema,
  updateDefinitionRequestSchema,
} from "../schemas/definition";
import { userListItemSchema } from "../schemas/user";
import { authErrorResponses, authenticatedSecurity, errorContent, jsonContent } from "./helpers";

const definitionIdParams = z.object({ id: z.string() });

const createDefinitionRoute = createRoute({
  method: "post",
  path: "/definitions",
  tags: ["definitions"],
  summary: "定義を作成（draft / public / private のいずれでも）",
  security: authenticatedSecurity,
  request: {
    body: jsonContent(createDefinitionRequestSchema, "作成内容"),
  },
  responses: {
    201: jsonContent(definitionResponseSchema, "作成された定義"),
    404: errorContent(
      "言葉が存在しない（word_not_found）・未登録・削除済みユーザー（user_not_found）",
    ),
    ...authErrorResponses,
  },
});

const getDefinitionRoute = createRoute({
  method: "get",
  path: "/definitions/{id}",
  tags: ["definitions"],
  summary: "定義詳細を取得",
  security: authenticatedSecurity,
  request: { params: definitionIdParams },
  responses: {
    200: jsonContent(definitionResponseSchema, "定義"),
    404: errorContent("定義が存在しない・削除済み・他者の非公開/下書き（definition_not_found）"),
    ...authErrorResponses,
  },
});

const updateDefinitionRoute = createRoute({
  method: "patch",
  path: "/definitions/{id}",
  tags: ["definitions"],
  summary: "本文編集・状態遷移・（下書きのみ）言葉の変更",
  description:
    "許可される遷移: draft→public/private、public↔private。確定時に finalized_at を設定し、本文編集は finalized_at + 1 時間まで。確定後の wordId 変更・下書きへの巻き戻しは拒否する。",
  security: authenticatedSecurity,
  request: {
    params: definitionIdParams,
    body: jsonContent(updateDefinitionRequestSchema, "更新内容"),
  },
  responses: {
    200: jsonContent(definitionResponseSchema, "更新後の定義"),
    400: errorContent("許可されない状態遷移・確定後の言葉変更（invalid_transition）"),
    403: errorContent("編集期限切れ（edit_window_expired）・本人以外（forbidden）"),
    404: errorContent("定義が存在しない（definition_not_found）"),
    ...authErrorResponses,
  },
});

const deleteDefinitionRoute = createRoute({
  method: "delete",
  path: "/definitions/{id}",
  tags: ["definitions"],
  summary: "定義を削除（論理削除・30 日保持）",
  security: authenticatedSecurity,
  request: { params: definitionIdParams },
  responses: {
    204: { description: "削除完了" },
    403: errorContent("本人以外（forbidden）"),
    404: errorContent("定義が存在しない（definition_not_found）"),
    ...authErrorResponses,
  },
});

const likeRoute = createRoute({
  method: "put",
  path: "/definitions/{id}/like",
  tags: ["definitions"],
  summary: "いいね",
  security: authenticatedSecurity,
  request: { params: definitionIdParams },
  responses: {
    204: { description: "いいね完了（冪等）" },
    404: errorContent(
      "定義が存在しない（definition_not_found）・未登録・削除済みユーザー（user_not_found）",
    ),
    ...authErrorResponses,
  },
});

const unlikeRoute = createRoute({
  method: "delete",
  path: "/definitions/{id}/like",
  tags: ["definitions"],
  summary: "いいね解除",
  security: authenticatedSecurity,
  request: { params: definitionIdParams },
  responses: {
    204: { description: "解除完了（冪等）" },
    ...authErrorResponses,
  },
});

const listLikedUsersRoute = createRoute({
  method: "get",
  path: "/definitions/{id}/likes",
  tags: ["definitions"],
  summary: "いいねしたユーザー一覧",
  security: authenticatedSecurity,
  request: { params: definitionIdParams, query: paginationQuerySchema },
  responses: {
    200: jsonContent(paginatedSchema(userListItemSchema), "ユーザー一覧"),
    404: errorContent("定義が存在しない（definition_not_found）"),
    ...authErrorResponses,
  },
});

type DefinitionRouteEnvironment = {
  Bindings: { AVATAR_BASE_URL: string; DB: D1Database };
  Variables: AuthenticationVariables;
};

export const definitionRoutes = new OpenAPIHono<DefinitionRouteEnvironment>()
  .openapi(createDefinitionRoute, async (context) => {
    const definition = await new DefinitionService(context.env).create(
      context.get("firebaseUid"),
      context.req.valid("json"),
    );
    return context.json(definition, 201);
  })
  .openapi(getDefinitionRoute, async (context) => {
    const definition = await new DefinitionService(context.env).get(
      context.get("firebaseUid"),
      context.req.valid("param").id,
    );
    return context.json(definition, 200);
  })
  .openapi(updateDefinitionRoute, async (context) => {
    const definition = await new DefinitionService(context.env).update(
      context.get("firebaseUid"),
      context.req.valid("param").id,
      context.req.valid("json"),
    );
    return context.json(definition, 200);
  })
  .openapi(deleteDefinitionRoute, async (context) => {
    await new DefinitionService(context.env).delete(
      context.get("firebaseUid"),
      context.req.valid("param").id,
    );
    return context.body(null, 204);
  })
  .openapi(likeRoute, async (context) => {
    await new DefinitionService(context.env).like(
      context.get("firebaseUid"),
      context.req.valid("param").id,
    );
    return context.body(null, 204);
  })
  .openapi(unlikeRoute, async (context) => {
    await new DefinitionService(context.env).unlike(
      context.get("firebaseUid"),
      context.req.valid("param").id,
    );
    return context.body(null, 204);
  })
  .openapi(listLikedUsersRoute, async (context) => {
    const query = context.req.valid("query");
    const result = await new DefinitionService(context.env).listLikedUsers(
      context.get("firebaseUid"),
      context.req.valid("param").id,
      query.limit,
      query.cursor,
    );
    return context.json(result, 200);
  });
