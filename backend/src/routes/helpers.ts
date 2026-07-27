import type { z } from "@hono/zod-openapi";
import { errorResponseSchema } from "../schemas/common";

/**
 * App Check は全エンドポイント必須。Firebase ID トークンの免除は
 * `src/auth/middleware.ts` の `idTokenExemptPaths` と一致させる。
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
