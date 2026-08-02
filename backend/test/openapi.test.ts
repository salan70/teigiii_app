/**
 * OpenAPI ドキュメントが生成でき、plan のエンドポイント一覧と一致することを検証する。
 */
import { describe, expect, test } from "bun:test";
import { Validator } from "@seriousme/openapi-schema-validator";
import { buildOpenApiDocument } from "../src/app";
import { idTokenExemptPaths } from "../src/auth/middleware";

/** plan（doc/plans/2026-07-15-rdb-schema-api-design.md）のエンドポイント一覧 */
const expectedOperations = [
  "GET /v1/app-config",
  "POST /v1/users",
  "GET /v1/users/me",
  "PATCH /v1/users/me",
  "DELETE /v1/users/me",
  "PUT /v1/users/me/avatar",
  "DELETE /v1/users/me/avatar",
  "GET /v1/avatars/{id}",
  "GET /v1/users/{id}",
  "GET /v1/users/{id}/dictionary",
  "GET /v1/users/{id}/definitions",
  "GET /v1/users/{id}/liked-definitions",
  "GET /v1/users/{id}/followers",
  "GET /v1/users/{id}/following",
  "PUT /v1/users/{id}/follow",
  "DELETE /v1/users/{id}/follow",
  "PUT /v1/users/{id}/mute",
  "DELETE /v1/users/{id}/mute",
  "GET /v1/me/mutes",
  "GET /v1/me/dictionary/overview",
  "GET /v1/me/defined-words",
  "GET /v1/me/definitions",
  "GET /v1/me/saved-words",
  "POST /v1/words",
  "GET /v1/words",
  // #306 で追加。plan は doc/plans/2026-07-30-word-registration-existing-word-ux.md
  "GET /v1/words/lookup",
  "GET /v1/words/{id}",
  "PATCH /v1/words/{id}",
  "GET /v1/words/{id}/definitions",
  "PUT /v1/words/{id}/save",
  "DELETE /v1/words/{id}/save",
  "POST /v1/definitions",
  "GET /v1/definitions/{id}",
  "PATCH /v1/definitions/{id}",
  "DELETE /v1/definitions/{id}",
  "PUT /v1/definitions/{id}/like",
  "DELETE /v1/definitions/{id}/like",
  "GET /v1/definitions/{id}/likes",
  "GET /v1/timeline/discover",
  "GET /v1/timeline/following",
  "GET /v1/search/words",
  "GET /v1/search/users",
  "POST /v1/telemetry/frames",
].toSorted();

describe("OpenAPI document", () => {
  const document = buildOpenApiDocument();

  test("plan のエンドポイント一覧と過不足なく一致する", () => {
    const operations = Object.entries(document.paths ?? {})
      .flatMap(([path, item]) =>
        Object.keys(item ?? {})
          .filter((key) => ["get", "post", "put", "patch", "delete"].includes(key))
          .map((method) => `${method.toUpperCase()} ${path}`),
      )
      .toSorted();
    expect(operations).toEqual(expectedOperations);
  });

  test("securitySchemes に appCheck と firebaseIdToken が定義される", () => {
    const schemes = document.components?.securitySchemes ?? {};
    expect(Object.keys(schemes).toSorted()).toEqual(["appCheck", "firebaseIdToken"]);
  });

  test("OpenAPI 3.0 スキーマとして妥当（validate が通る）", async () => {
    const validator = new Validator();
    const result = await validator.validate(JSON.parse(JSON.stringify(document)));
    expect(result.errors).toBeUndefined();
    expect(result.valid).toBe(true);
  });

  test("全オペレーションで appCheck 必須、免除パス以外は firebaseIdToken も必須", () => {
    const exemptPaths = new Set<string>(idTokenExemptPaths);
    for (const [path, item] of Object.entries(document.paths ?? {})) {
      for (const [method, operation] of Object.entries(item ?? {})) {
        if (!["get", "post", "put", "patch", "delete"].includes(method)) continue;
        const op = operation as { security?: Record<string, unknown>[] };
        expect(op.security).toBeDefined();
        const requiresAppCheck = (op.security ?? []).some((entry) => "appCheck" in entry);
        const requiresIdToken = (op.security ?? []).some((entry) => "firebaseIdToken" in entry);
        expect(requiresAppCheck).toBe(true);
        if (exemptPaths.has(path)) {
          expect(requiresIdToken).toBe(false);
        } else {
          expect(requiresIdToken).toBe(true);
        }
      }
    }
  });

  test("見つけるフィードの oneOf に discriminator が明示される", () => {
    const schema = document.components?.schemas?.DiscoverFeedItem as
      | { discriminator?: { propertyName?: string } }
      | undefined;
    expect(schema?.discriminator?.propertyName).toBe("type");
  });
});
