import { OpenAPIHono, createRoute, z } from "@hono/zod-openapi";
import type { AuthenticationVariables } from "../auth/middleware";
import { BrowseService } from "../browse/browse-service";
import { withDraftCount, withDraftCountItems } from "../compat/draft-count-shim";
import { paginatedSchema, paginationQuerySchema } from "../schemas/common";
import { definitionResponseSchema } from "../schemas/definition";
import {
  definedWordItemSchema,
  myDictionaryOverviewSchema,
  savedWordItemSchema,
} from "../schemas/dictionary";
import { userListItemSchema } from "../schemas/user";
import { authErrorResponses, authenticatedSecurity, jsonContent } from "./helpers";

const getOverviewRoute = createRoute({
  method: "get",
  path: "/me/dictionary/overview",
  tags: ["me"],
  summary: "あなたの辞書の概要（各件数 + 最近の定義）",
  security: authenticatedSecurity,
  responses: {
    200: jsonContent(myDictionaryOverviewSchema, "概要"),
    ...authErrorResponses,
  },
});

const getDefinedWordsRoute = createRoute({
  method: "get",
  path: "/me/defined-words",
  tags: ["me"],
  summary: "定義済みの言葉一覧（言葉単位 + 状態別件数）",
  security: authenticatedSecurity,
  request: { query: paginationQuerySchema },
  responses: {
    200: jsonContent(paginatedSchema(definedWordItemSchema), "定義済み一覧"),
    ...authErrorResponses,
  },
});

const getMyDefinitionsRoute = createRoute({
  method: "get",
  path: "/me/definitions",
  tags: ["me"],
  summary: "自分の定義一覧（状態で絞り込み）",
  security: authenticatedSecurity,
  request: {
    query: paginationQuerySchema.extend({
      status: z.enum(["public", "private"]).optional(),
    }),
  },
  responses: {
    200: jsonContent(paginatedSchema(definitionResponseSchema), "定義一覧"),
    ...authErrorResponses,
  },
});

const getSavedWordsRoute = createRoute({
  method: "get",
  path: "/me/saved-words",
  tags: ["me"],
  summary: "保存した言葉の一覧",
  security: authenticatedSecurity,
  request: { query: paginationQuerySchema },
  responses: {
    200: jsonContent(paginatedSchema(savedWordItemSchema), "保存した言葉"),
    ...authErrorResponses,
  },
});

const getMutesRoute = createRoute({
  method: "get",
  path: "/me/mutes",
  tags: ["me"],
  summary: "ミュート中のユーザー一覧",
  security: authenticatedSecurity,
  request: { query: paginationQuerySchema },
  responses: {
    200: jsonContent(paginatedSchema(userListItemSchema), "ミュート中一覧"),
    ...authErrorResponses,
  },
});

type MeRouteEnvironment = {
  Bindings: { AVATAR_BASE_URL: string; DB: D1Database };
  Variables: AuthenticationVariables;
};

export const meRoutes = new OpenAPIHono<MeRouteEnvironment>()
  .openapi(getOverviewRoute, async (context) => {
    const result = await new BrowseService(context.env).getMyOverview(context.get("firebaseUid"));
    // v1.2.1 互換シム。撤去条件は compat/draft-count-shim.ts を参照
    return context.json(withDraftCount(result), 200);
  })
  .openapi(getDefinedWordsRoute, async (context) => {
    const query = context.req.valid("query");
    const result = await new BrowseService(context.env).listDefinedWords(
      context.get("firebaseUid"),
      query.limit,
      query.cursor,
    );
    // v1.2.1 互換シム。撤去条件は compat/draft-count-shim.ts を参照
    return context.json(withDraftCountItems(result), 200);
  })
  .openapi(getMyDefinitionsRoute, async (context) => {
    const query = context.req.valid("query");
    const result = await new BrowseService(context.env).listMyDefinitions(
      context.get("firebaseUid"),
      query.limit,
      query.status,
      query.cursor,
    );
    return context.json(result, 200);
  })
  .openapi(getSavedWordsRoute, async (context) => {
    const query = context.req.valid("query");
    const result = await new BrowseService(context.env).listSavedWords(
      context.get("firebaseUid"),
      query.limit,
      query.cursor,
    );
    return context.json(result, 200);
  })
  .openapi(getMutesRoute, async (context) => {
    const query = context.req.valid("query");
    const result = await new BrowseService(context.env).listMutes(
      context.get("firebaseUid"),
      query.limit,
      query.cursor,
    );
    return context.json(result, 200);
  });
