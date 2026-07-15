import type { z } from "@hono/zod-openapi";
import type { Context } from "hono";
import { HTTPException } from "hono/http-exception";
import { errorResponseSchema } from "../schemas/common";

/**
 * App Check は全エンドポイント必須。Firebase ID トークンは GET /v1/app-config のみ免除。
 * スキーム本体は app.ts で registerComponent する。
 */
export const appCheckOnlySecurity = [{ appCheck: [] }];
export const authenticatedSecurity = [{ appCheck: [], firebaseIdToken: [] }];

export function jsonContent<T extends z.ZodType>(schema: T, description: string) {
  return { content: { "application/json": { schema } }, description };
}

export const errorContent = (description: string) => jsonContent(errorResponseSchema, description);

/** 認証必須エンドポイント共通のエラーレスポンス */
export const authErrorResponses = {
  401: errorContent("App Check または Firebase ID トークンが欠落・無効"),
};

/**
 * フェーズ 2 のスタブハンドラ。実装はフェーズ 3（#184）。
 * OpenAPI 定義を汚さないよう、レスポンススキーマには含めず実行時に 501 を投げる。
 */
export function notImplemented(_c: Context): never {
  throw new HTTPException(501, { message: "not implemented" });
}
