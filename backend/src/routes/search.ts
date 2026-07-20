import { OpenAPIHono, createRoute, z } from "@hono/zod-openapi";
import type { AuthenticationVariables } from "../auth/middleware";
import { BrowseService } from "../browse/browse-service";
import { paginatedSchema, paginationQuerySchema } from "../schemas/common";
import { userListItemSchema } from "../schemas/user";
import { wordListItemSchema } from "../schemas/word";
import { authErrorResponses, authenticatedSecurity, jsonContent } from "./helpers";

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

type SearchRouteEnvironment = {
  Bindings: { AVATAR_BASE_URL: string; DB: D1Database };
  Variables: AuthenticationVariables;
};

export const searchRoutes = new OpenAPIHono<SearchRouteEnvironment>()
  .openapi(searchWordsRoute, async (context) => {
    const query = context.req.valid("query");
    const result = await new BrowseService(context.env).searchWords(
      context.get("firebaseUid"),
      query.q,
      query.limit,
      query.cursor,
    );
    return context.json(result, 200);
  })
  .openapi(searchUsersRoute, async (context) => {
    const query = context.req.valid("query");
    const result = await new BrowseService(context.env).searchUsers(
      context.get("firebaseUid"),
      query.q,
      query.limit,
      query.cursor,
    );
    return context.json(result, 200);
  });
