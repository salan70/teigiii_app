import { describe, expect, test } from "bun:test";
import { evaluateBasicAuth } from "../web/_lib/basic-auth.js";
import { shouldSkipBasicAuth } from "../web/_lib/basic-auth-paths.js";

describe("evaluateBasicAuth", () => {
  test("credentials 未設定なら missing_config", () => {
    expect(evaluateBasicAuth("Basic dXNlcjpwYXNz", undefined, "pass")).toBe(
      "missing_config",
    );
    expect(evaluateBasicAuth("Basic dXNlcjpwYXNz", "user", undefined)).toBe(
      "missing_config",
    );
    expect(evaluateBasicAuth("Basic dXNlcjpwYXNz", "", "pass")).toBe(
      "missing_config",
    );
  });

  test("Authorization 無し / 非 Basic は unauthorized", () => {
    expect(evaluateBasicAuth(null, "user", "pass")).toBe("unauthorized");
    expect(evaluateBasicAuth(undefined, "user", "pass")).toBe("unauthorized");
    expect(evaluateBasicAuth("Bearer abc", "user", "pass")).toBe("unauthorized");
  });

  test("正しい user:pass は ok", () => {
    const header = `Basic ${btoa("qa:s3cret")}`;
    expect(evaluateBasicAuth(header, "qa", "s3cret")).toBe("ok");
  });

  test("password にコロンを含んでも ok", () => {
    const header = `Basic ${btoa("qa:p@ss:word")}`;
    expect(evaluateBasicAuth(header, "qa", "p@ss:word")).toBe("ok");
  });

  test("user / password 不一致は unauthorized", () => {
    const header = `Basic ${btoa("qa:wrong")}`;
    expect(evaluateBasicAuth(header, "qa", "s3cret")).toBe("unauthorized");
  });

  test("壊れた Base64 は unauthorized", () => {
    expect(evaluateBasicAuth("Basic !!!", "qa", "s3cret")).toBe("unauthorized");
  });
});

describe("shouldSkipBasicAuth", () => {
  test("manifest / icons はスキップ", () => {
    expect(shouldSkipBasicAuth("/manifest.json")).toBe(true);
    expect(shouldSkipBasicAuth("/favicon.png")).toBe(true);
    expect(shouldSkipBasicAuth("/icons/Icon-192.png")).toBe(true);
    expect(shouldSkipBasicAuth("/flutter_service_worker.js")).toBe(true);
  });

  test("アプリ本体はスキップしない", () => {
    expect(shouldSkipBasicAuth("/")).toBe(false);
    expect(shouldSkipBasicAuth("/main.dart.js")).toBe(false);
    expect(shouldSkipBasicAuth("/index.html")).toBe(false);
  });
});
