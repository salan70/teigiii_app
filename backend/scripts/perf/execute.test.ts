import { describe, expect, test } from "bun:test";

import { extractD1Rows, requireCloudflareApiToken } from "./execute";

describe("requireCloudflareApiToken", () => {
  test("未設定ならエラー", () => {
    expect(() => requireCloudflareApiToken({})).toThrow(/CLOUDFLARE_API_TOKEN/);
  });

  test("空文字ならエラー", () => {
    expect(() => requireCloudflareApiToken({ CLOUDFLARE_API_TOKEN: "  " })).toThrow(
      /CLOUDFLARE_API_TOKEN/,
    );
  });

  test("設定されていれば値を返す", () => {
    expect(requireCloudflareApiToken({ CLOUDFLARE_API_TOKEN: "token" })).toBe("token");
  });
});

describe("extractD1Rows", () => {
  test("wrangler --json の配列形式から results を取り出す", () => {
    const rows = extractD1Rows([
      {
        results: [{ screen_name: "HomeRoute", frame_count: 10 }],
        success: true,
      },
    ]);
    expect(rows).toEqual([{ screen_name: "HomeRoute", frame_count: 10 }]);
  });

  test("results が無い場合は空配列", () => {
    expect(extractD1Rows([{ success: true }])).toEqual([]);
  });

  test("不正な JSON 形状はエラー", () => {
    expect(() => extractD1Rows({ results: [] })).toThrow();
  });
});
