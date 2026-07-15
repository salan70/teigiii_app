import { OpenAPIHono, createRoute } from "@hono/zod-openapi";
import { paginatedSchema, paginationQuerySchema } from "../schemas/common";
import { definitionResponseSchema } from "../schemas/definition";
import { discoverFeedItemSchema } from "../schemas/timeline";
import { authErrorResponses, authenticatedSecurity, jsonContent, notImplemented } from "./helpers";

const discoverRoute = createRoute({
  method: "get",
  path: "/timeline/discover",
  tags: ["timeline"],
  summary: "見つける（公開定義 + 言葉登録の混在フィード・完全な新着順）",
  description: "ミュート中ユーザーの活動は除外する。",
  security: authenticatedSecurity,
  request: { query: paginationQuerySchema },
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

export const timelineRoutes = new OpenAPIHono()
  .openapi(discoverRoute, notImplemented)
  .openapi(followingRoute, notImplemented);
