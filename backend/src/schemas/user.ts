import { z } from "@hono/zod-openapi";
import { isoDateTime } from "./common";

// 現行実装（user_profile.dart）に準拠
export const maxNameLength = 15;
export const maxBioLength = 150;

/** 定義の投稿者表示などに埋め込む最小のユーザー情報 */
export const userSummarySchema = z
  .object({
    id: z.string(),
    publicId: z.string(),
    name: z.string(),
    // avatar_key を認証必須の Workers API URL に解決した値。未設定は null。
    avatarUrl: z.string().nullable(),
  })
  .openapi("UserSummary");

/** 一覧（フォロワー・ミュート・検索結果等）用のユーザー情報 */
export const userListItemSchema = userSummarySchema
  .extend({
    isFollowedByMe: z.boolean(),
    isMutedByMe: z.boolean(),
  })
  .openapi("UserListItem");

/** 公開プロフィール（プロフィールと公開辞書は一体だが、辞書本体は別エンドポイント） */
export const userResponseSchema = userSummarySchema
  .extend({
    bio: z.string(),
    publicDefinitionCount: z.number().int(),
    followingCount: z.number().int(),
    followerCount: z.number().int(),
    isFollowedByMe: z.boolean(),
    isMutedByMe: z.boolean(),
    createdAt: isoDateTime,
  })
  .openapi("UserResponse");

export const meResponseSchema = userSummarySchema
  .extend({
    bio: z.string(),
    createdAt: isoDateTime,
  })
  .openapi("MeResponse");

export const createUserRequestSchema = z
  .object({
    name: z.string().min(1).max(maxNameLength),
    bio: z.string().max(maxBioLength).default(""),
    osVersion: z.string(),
    appVersion: z.string(),
  })
  .openapi("CreateUserRequest");

export const updateMeRequestSchema = z
  .object({
    name: z.string().min(1).max(maxNameLength).optional(),
    bio: z.string().max(maxBioLength).optional(),
    osVersion: z.string().optional(),
    appVersion: z.string().optional(),
  })
  .openapi("UpdateMeRequest");
