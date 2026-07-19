import { OpenAPIHono, createRoute, z } from "@hono/zod-openapi";
import type { AuthenticationVariables } from "../auth/middleware";
import { BrowseService } from "../browse/browse-service";
import { paginatedSchema, paginationQuerySchema } from "../schemas/common";
import { definitionResponseSchema } from "../schemas/definition";
import { discoverFeedItemSchema } from "../schemas/timeline";
import { authErrorResponses, authenticatedSecurity, jsonContent } from "./helpers";

const discoverQuerySchema = paginationQuerySchema.extend({
  type: z.enum(["definition", "wordRegistered"]).optional(),
});

const discoverRoute = createRoute({
  method: "get",
  path: "/timeline/discover",
  tags: ["timeline"],
  summary: "見つける（公開定義 + 言葉登録の混在フィード・完全な新着順）",
  description: "ミュート中ユーザーの活動は除外する。",
  security: authenticatedSecurity,
  request: { query: discoverQuerySchema },
  responses: {
    200: jsonContent(paginatedSchema(discoverFeedItemSchema), "フィード"),
    ...authErrorResponses,
  },
});

const followingRoute = createRoute({
  method: "get",
  path: "/timeline/following",
  tags: ["timeline"],
  summary: "フォロー中（公開定義のみ・完全な新着順）",
  description: "ミュート中ユーザーの活動は除外する。",
  security: authenticatedSecurity,
  request: { query: paginationQuerySchema },
  responses: {
    200: jsonContent(paginatedSchema(definitionResponseSchema), "フィード"),
    ...authErrorResponses,
  },
});

type TimelineRouteEnvironment = {
  Bindings: { AVATAR_BASE_URL: string; DB: D1Database };
  Variables: AuthenticationVariables;
};

export const timelineRoutes = new OpenAPIHono<TimelineRouteEnvironment>()
  .openapi(discoverRoute, async (context) => {
    const query = context.req.valid("query");
    const result = await new BrowseService(context.env).listDiscover(
      context.get("firebaseUid"),
      query.limit,
      query.cursor,
      query.type,
    );
    return context.json(result, 200);
  })
  .openapi(followingRoute, async (context) => {
    const query = context.req.valid("query");
    const result = await new BrowseService(context.env).listFollowing(
      context.get("firebaseUid"),
      query.limit,
      query.cursor,
    );
    return context.json(result, 200);
  });
