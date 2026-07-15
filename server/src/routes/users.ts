import { OpenAPIHono, createRoute, z } from "@hono/zod-openapi";
import { paginatedSchema, paginationQuerySchema } from "../schemas/common";
import { definitionResponseSchema } from "../schemas/definition";
import { userDictionaryItemSchema } from "../schemas/dictionary";
import {
  createUserRequestSchema,
  meResponseSchema,
  updateMeRequestSchema,
  userListItemSchema,
  userResponseSchema,
} from "../schemas/user";
import {
  authErrorResponses,
  authenticatedSecurity,
  errorContent,
  jsonContent,
  notImplemented,
} from "./helpers";

const userIdParams = z.object({ id: z.string() });

const createUserRoute = createRoute({
  method: "post",
  path: "/users",
  tags: ["users"],
  summary: "初回登録",
  description: "匿名認証直後に呼び出す。publicId はサーバーで採番する。",
  security: authenticatedSecurity,
  request: {
    body: jsonContent(createUserRequestSchema, "登録内容"),
  },
  responses: {
    201: jsonContent(meResponseSchema, "登録されたユーザー"),
    409: errorContent("登録済み（user_already_exists）"),
    ...authErrorResponses,
  },
});

const getMeRoute = createRoute({
  method: "get",
  path: "/users/me",
  tags: ["users"],
  summary: "自分の情報を取得",
  security: authenticatedSecurity,
  responses: {
    200: jsonContent(meResponseSchema, "自分の情報"),
    404: errorContent("未登録（user_not_found）"),
    ...authErrorResponses,
  },
});

const updateMeRoute = createRoute({
  method: "patch",
  path: "/users/me",
  tags: ["users"],
  summary: "プロフィール編集・バージョン情報更新",
  security: authenticatedSecurity,
  request: {
    body: jsonContent(updateMeRequestSchema, "更新内容"),
  },
  responses: {
    200: jsonContent(meResponseSchema, "更新後の自分の情報"),
    ...authErrorResponses,
  },
});

const uploadAvatarRoute = createRoute({
  method: "put",
  path: "/users/me/avatar",
  tags: ["users"],
  summary: "アバター画像をアップロード",
  description: "バイナリを直接送信し、Workers 経由で R2 に保存する。",
  security: authenticatedSecurity,
  request: {
    body: {
      content: {
        "application/octet-stream": {
          schema: z.string().openapi({ format: "binary" }),
        },
      },
      description: "画像バイナリ",
    },
  },
  responses: {
    200: jsonContent(z.object({ avatarUrl: z.string() }), "保存後の配信 URL"),
    413: errorContent("画像サイズ超過（image_too_large）"),
    ...authErrorResponses,
  },
});

const deleteAvatarRoute = createRoute({
  method: "delete",
  path: "/users/me/avatar",
  tags: ["users"],
  summary: "アバター画像を削除",
  security: authenticatedSecurity,
  responses: {
    204: { description: "削除完了" },
    ...authErrorResponses,
  },
});

const deleteMeRoute = createRoute({
  method: "delete",
  path: "/users/me",
  tags: ["users"],
  summary: "アカウント削除（論理削除・30 日保持）",
  security: authenticatedSecurity,
  responses: {
    204: { description: "削除受付完了" },
    ...authErrorResponses,
  },
});

const getUserRoute = createRoute({
  method: "get",
  path: "/users/{id}",
  tags: ["users"],
  summary: "公開プロフィールを取得",
  security: authenticatedSecurity,
  request: { params: userIdParams },
  responses: {
    200: jsonContent(userResponseSchema, "公開プロフィール"),
    404: errorContent("ユーザーが存在しない（user_not_found）"),
    ...authErrorResponses,
  },
});

const getUserDictionaryRoute = createRoute({
  method: "get",
  path: "/users/{id}/dictionary",
  tags: ["users"],
  summary: "公開辞書を取得（言葉単位）",
  security: authenticatedSecurity,
  request: { params: userIdParams, query: paginationQuerySchema },
  responses: {
    200: jsonContent(paginatedSchema(userDictionaryItemSchema), "公開辞書"),
    404: errorContent("ユーザーが存在しない（user_not_found）"),
    ...authErrorResponses,
  },
});

const getUserDefinitionsRoute = createRoute({
  method: "get",
  path: "/users/{id}/definitions",
  tags: ["users"],
  summary: "ユーザーの定義一覧",
  description:
    "対象が本人の場合は非公開定義を含む（下書きは /me/definitions）。他者の場合は公開定義のみ。wordId・subGroup で絞り込み可能。sort=reading は言葉のよみ昇順（旧 UI の頭文字別辞書のパリティ）。",
  security: authenticatedSecurity,
  request: {
    params: userIdParams,
    query: paginationQuerySchema.extend({
      wordId: z.string().optional(),
      subGroup: z.string().optional(),
      sort: z.enum(["newest", "reading"]).default("newest"),
    }),
  },
  responses: {
    200: jsonContent(paginatedSchema(definitionResponseSchema), "定義一覧"),
    404: errorContent("ユーザーが存在しない（user_not_found）"),
    ...authErrorResponses,
  },
});

const getUserLikedDefinitionsRoute = createRoute({
  method: "get",
  path: "/users/{id}/liked-definitions",
  tags: ["users"],
  summary: "ユーザーがいいねした定義の一覧（いいね日時の降順）",
  description:
    "旧 UI のプロフィール「いいね」タブのパリティ用。他者の公開定義に加え、閲覧者自身の定義は非公開でも含める（旧実装と同じ可視性）。",
  security: authenticatedSecurity,
  request: { params: userIdParams, query: paginationQuerySchema },
  responses: {
    200: jsonContent(paginatedSchema(definitionResponseSchema), "定義一覧"),
    404: errorContent("ユーザーが存在しない（user_not_found）"),
    ...authErrorResponses,
  },
});

const getFollowersRoute = createRoute({
  method: "get",
  path: "/users/{id}/followers",
  tags: ["users"],
  summary: "フォロワー一覧",
  security: authenticatedSecurity,
  request: { params: userIdParams, query: paginationQuerySchema },
  responses: {
    200: jsonContent(paginatedSchema(userListItemSchema), "フォロワー一覧"),
    404: errorContent("ユーザーが存在しない（user_not_found）"),
    ...authErrorResponses,
  },
});

const getFollowingRoute = createRoute({
  method: "get",
  path: "/users/{id}/following",
  tags: ["users"],
  summary: "フォロー中一覧",
  security: authenticatedSecurity,
  request: { params: userIdParams, query: paginationQuerySchema },
  responses: {
    200: jsonContent(paginatedSchema(userListItemSchema), "フォロー中一覧"),
    404: errorContent("ユーザーが存在しない（user_not_found）"),
    ...authErrorResponses,
  },
});

const followRoute = createRoute({
  method: "put",
  path: "/users/{id}/follow",
  tags: ["users"],
  summary: "フォロー",
  security: authenticatedSecurity,
  request: { params: userIdParams },
  responses: {
    204: { description: "フォロー完了（冪等）" },
    400: errorContent("自分自身へのフォロー（cannot_follow_self）"),
    404: errorContent("ユーザーが存在しない（user_not_found）"),
    ...authErrorResponses,
  },
});

const unfollowRoute = createRoute({
  method: "delete",
  path: "/users/{id}/follow",
  tags: ["users"],
  summary: "フォロー解除",
  security: authenticatedSecurity,
  request: { params: userIdParams },
  responses: {
    204: { description: "解除完了（冪等）" },
    ...authErrorResponses,
  },
});

const muteRoute = createRoute({
  method: "put",
  path: "/users/{id}/mute",
  tags: ["users"],
  summary: "ミュート",
  security: authenticatedSecurity,
  request: { params: userIdParams },
  responses: {
    204: { description: "ミュート完了（冪等）" },
    400: errorContent("自分自身へのミュート（cannot_mute_self）"),
    404: errorContent("ユーザーが存在しない（user_not_found）"),
    ...authErrorResponses,
  },
});

const unmuteRoute = createRoute({
  method: "delete",
  path: "/users/{id}/mute",
  tags: ["users"],
  summary: "ミュート解除",
  security: authenticatedSecurity,
  request: { params: userIdParams },
  responses: {
    204: { description: "解除完了（冪等）" },
    ...authErrorResponses,
  },
});

export const userRoutes = new OpenAPIHono()
  .openapi(createUserRoute, notImplemented)
  .openapi(getMeRoute, notImplemented)
  .openapi(updateMeRoute, notImplemented)
  .openapi(uploadAvatarRoute, notImplemented)
  .openapi(deleteAvatarRoute, notImplemented)
  .openapi(deleteMeRoute, notImplemented)
  .openapi(getUserRoute, notImplemented)
  .openapi(getUserDictionaryRoute, notImplemented)
  .openapi(getUserDefinitionsRoute, notImplemented)
  .openapi(getUserLikedDefinitionsRoute, notImplemented)
  .openapi(getFollowersRoute, notImplemented)
  .openapi(getFollowingRoute, notImplemented)
  .openapi(followRoute, notImplemented)
  .openapi(unfollowRoute, notImplemented)
  .openapi(muteRoute, notImplemented)
  .openapi(unmuteRoute, notImplemented);
