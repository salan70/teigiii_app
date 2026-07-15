import { OpenAPIHono, createRoute, z } from "@hono/zod-openapi";
import { paginatedSchema, paginationQuerySchema } from "../schemas/common";
import { userListItemSchema } from "../schemas/user";
import { wordListItemSchema } from "../schemas/word";
import { authErrorResponses, authenticatedSecurity, jsonContent, notImplemented } from "./helpers";

const searchQuerySchema = paginationQuerySchema.extend({
  q: z.string().min(1),
});

const searchWordsRoute = createRoute({
  method: "get",
  path: "/search/words",
  tags: ["search"],
  summary: "言葉を検索（表記・よみの部分一致）",
  security: authenticatedSecurity,
  request: { query: searchQuerySchema },
  responses: {
    200: jsonContent(paginatedSchema(wordListItemSchema), "検索結果"),
    ...authErrorResponses,
  },
});

const searchUsersRoute = createRoute({
  method: "get",
  path: "/search/users",
  tags: ["search"],
  summary: "ユーザーを検索（表示名・ユーザー ID の部分一致）",
  security: authenticatedSecurity,
  request: { query: searchQuerySchema },
  responses: {
    200: jsonContent(paginatedSchema(userListItemSchema), "検索結果"),
    ...authErrorResponses,
  },
});

export const searchRoutes = new OpenAPIHono()
  .openapi(searchWordsRoute, notImplemented)
  .openapi(searchUsersRoute, notImplemented);
