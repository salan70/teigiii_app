import { describe, expect, test } from "bun:test";

import { ApiError } from "../../src/errors";
import { decodeOpaqueCursor, encodeOpaqueCursor } from "../../src/lib/cursor";

describe("opaque cursor", () => {
  test("payload を不透明文字列にして復元できる", () => {
    const payload = { id: "0189-abc", kind: "words", reading: "あんこ", version: 1 };

    const encoded = encodeOpaqueCursor(payload);

    expect(decodeOpaqueCursor(encoded)).toEqual(payload);
  });

  test("URL セーフな文字だけを使う", () => {
    const encoded = encodeOpaqueCursor({ kind: "words", reading: "ぱんだ?/+", version: 1 });

    expect(encoded).toMatch(/^[A-Za-z0-9_-]+$/);
  });

  test("base64url として不正な値は 400 invalid_cursor", () => {
    expect(() => decodeOpaqueCursor("!!not-base64!!")).toThrow(ApiError);
    try {
      decodeOpaqueCursor("!!not-base64!!");
    } catch (error) {
      expect(error).toMatchObject({ code: "invalid_cursor", status: 400 });
    }
  });

  test("JSON オブジェクト以外を含む値は 400 invalid_cursor", () => {
    const notAnObject = btoa(JSON.stringify("plain string"))
      .replaceAll("+", "-")
      .replaceAll("/", "_")
      .replace(/=+$/, "");

    expect(() => decodeOpaqueCursor(notAnObject)).toThrow(ApiError);
  });
});
