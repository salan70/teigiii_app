import { OpenAPIHono, createRoute, z } from "@hono/zod-openapi";
import type { AuthenticationVariables } from "../auth/middleware";
import { BrowseService } from "../browse/browse-service";
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
import { AvatarService, UserService, type UserServiceOptions } from "../users/user-service";
import { authErrorResponses, authenticatedSecurity, errorContent, jsonContent } from "./helpers";

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
    404: errorContent("未登録（user_not_found）"),
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
        "image/jpeg": {
          schema: z.string().openapi({ format: "binary" }),
        },
        "image/png": {
          schema: z.string().openapi({ format: "binary" }),
        },
      },
      description: "画像バイナリ",
    },
  },
  responses: {
    200: jsonContent(z.object({ avatarUrl: z.string() }), "保存後の配信 URL"),
    404: errorContent("未登録（user_not_found）"),
    413: errorContent("画像サイズ超過（image_too_large）"),
    415: errorContent("画像形式不正（unsupported_image_type）"),
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
    404: errorContent("未登録（user_not_found）"),
    ...authErrorResponses,
  },
});

const getAvatarRoute = createRoute({
  method: "get",
  path: "/avatars/{id}",
  tags: ["users"],
  summary: "認証付きアバター画像を取得",
  description: "非公開 R2 bucket の画像を認証済み利用者へ配信する。",
  security: authenticatedSecurity,
  request: { params: userIdParams },
  responses: {
    200: {
      content: {
        "image/jpeg": { schema: z.string().openapi({ format: "binary" }) },
        "image/png": { schema: z.string().openapi({ format: "binary" }) },
      },
      description: "アバター画像",
    },
    404: errorContent("ユーザーまたはアバターが存在しない（avatar_not_found）"),
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
    404: errorContent("未登録（user_not_found）"),
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
    "対象が本人の場合は非公開定義を含む。他者の場合は公開定義のみ。wordId・subGroup で絞り込み可能。sort=reading は言葉のよみ昇順（旧 UI の頭文字別辞書のパリティ）。",
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
    400: errorContent("自分自身への指定（cannot_follow_self）"),
    404: errorContent("ユーザーが存在しない（user_not_found）"),
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
    400: errorContent("自分自身への指定（cannot_mute_self）"),
    404: errorContent("ユーザーが存在しない（user_not_found）"),
    ...authErrorResponses,
  },
});

type UserRouteEnvironment = {
  Bindings: {
    AVATARS: R2Bucket;
    AVATAR_BASE_URL: string;
    DB: D1Database;
  };
  Variables: AuthenticationVariables;
};

export function createUserRoutes(options: UserServiceOptions = {}) {
  const routes = new OpenAPIHono<UserRouteEnvironment>();
  const users = (env: UserRouteEnvironment["Bindings"]) => new UserService(env, options);

  return routes
    .openapi(createUserRoute, async (context) => {
      const user = await users(context.env).create(
        context.get("firebaseUid"),
        context.req.valid("json"),
      );
      return context.json(user, 201);
    })
    .openapi(getMeRoute, async (context) => {
      const user = await users(context.env).getMe(context.get("firebaseUid"));
      return context.json(user, 200);
    })
    .openapi(updateMeRoute, async (context) => {
      const user = await users(context.env).update(
        context.get("firebaseUid"),
        context.req.valid("json"),
      );
      return context.json(user, 200);
    })
    .openapi(uploadAvatarRoute, async (context) => {
      const resolvedAvatarUrl = await new AvatarService(context.env).upload(
        context.get("firebaseUid"),
        context.req.raw,
      );
      return context.json({ avatarUrl: resolvedAvatarUrl }, 200);
    })
    .openapi(deleteAvatarRoute, async (context) => {
      await new AvatarService(context.env).delete(context.get("firebaseUid"));
      return context.body(null, 204);
    })
    .openapi(getAvatarRoute, async (context) => {
      const object = await new AvatarService(context.env).get(
        context.get("firebaseUid"),
        context.req.valid("param").id,
      );
      const headers = new Headers();
      object.writeHttpMetadata(headers);
      headers.set("Cache-Control", "private, max-age=300");
      headers.set("ETag", object.httpEtag);
      headers.set("X-Content-Type-Options", "nosniff");
      return new Response(object.body, { headers });
    })
    .openapi(deleteMeRoute, async (context) => {
      await users(context.env).delete(context.get("firebaseUid"));
      return context.body(null, 204);
    })
    .openapi(getUserRoute, async (context) => {
      const user = await users(context.env).getPublic(
        context.get("firebaseUid"),
        context.req.valid("param").id,
      );
      return context.json(user, 200);
    })
    .openapi(getUserDictionaryRoute, async (context) => {
      const query = context.req.valid("query");
      const result = await new BrowseService(context.env).listUserDictionary(
        context.req.valid("param").id,
        query.limit,
        query.cursor,
      );
      return context.json(result, 200);
    })
    .openapi(getUserDefinitionsRoute, async (context) => {
      const result = await new BrowseService(context.env).listUserDefinitions(
        context.get("firebaseUid"),
        context.req.valid("param").id,
        context.req.valid("query"),
      );
      return context.json(result, 200);
    })
    .openapi(getUserLikedDefinitionsRoute, async (context) => {
      const query = context.req.valid("query");
      const result = await new BrowseService(context.env).listLikedDefinitions(
        context.get("firebaseUid"),
        context.req.valid("param").id,
        query.limit,
        query.cursor,
      );
      return context.json(result, 200);
    })
    .openapi(getFollowersRoute, async (context) => {
      const query = context.req.valid("query");
      const result = await users(context.env).listRelatedUsers(
        context.get("firebaseUid"),
        context.req.valid("param").id,
        "followers",
        query.limit,
        query.cursor,
      );
      return context.json(result, 200);
    })
    .openapi(getFollowingRoute, async (context) => {
      const query = context.req.valid("query");
      const result = await users(context.env).listRelatedUsers(
        context.get("firebaseUid"),
        context.req.valid("param").id,
        "following",
        query.limit,
        query.cursor,
      );
      return context.json(result, 200);
    })
    .openapi(followRoute, async (context) => {
      await users(context.env).follow(context.get("firebaseUid"), context.req.valid("param").id);
      return context.body(null, 204);
    })
    .openapi(unfollowRoute, async (context) => {
      await users(context.env).unfollow(context.get("firebaseUid"), context.req.valid("param").id);
      return context.body(null, 204);
    })
    .openapi(muteRoute, async (context) => {
      await users(context.env).mute(context.get("firebaseUid"), context.req.valid("param").id);
      return context.body(null, 204);
    })
    .openapi(unmuteRoute, async (context) => {
      await users(context.env).unmute(context.get("firebaseUid"), context.req.valid("param").id);
      return context.body(null, 204);
    });
}
