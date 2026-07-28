import { describe, expect, test } from "bun:test";

import {
  assertReadOnlySql,
  executeTelemetrySql,
  extractD1Rows,
  formatWranglerFailure,
  parsePerfQueryArgs,
  requireCloudflareApiToken,
} from "./execute";

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

describe("assertReadOnlySql", () => {
  test("SELECT / WITH を許可する", () => {
    expect(() => assertReadOnlySql("SELECT 1")).not.toThrow();
    expect(() => assertReadOnlySql("  with x AS (SELECT 1) SELECT * FROM x")).not.toThrow();
  });

  test("mutation を拒否する", () => {
    expect(() => assertReadOnlySql("INSERT INTO frame_stats (id) VALUES ('x')")).toThrow(
      /SELECT|WITH/,
    );
    expect(() => assertReadOnlySql("DELETE FROM frame_stats")).toThrow(/SELECT|WITH/);
  });
});

describe("parsePerfQueryArgs", () => {
  test("単一の SQL 引数を返す", () => {
    expect(parsePerfQueryArgs(["SELECT 1"])).toBe("SELECT 1");
  });

  test("引数なし・複数引数はエラー", () => {
    expect(() => parsePerfQueryArgs([])).toThrow(/Usage/);
    expect(() => parsePerfQueryArgs(["SELECT", "1"])).toThrow(/single/);
  });
});

describe("executeTelemetrySql", () => {
  test("prod TELEMETRY_DB 向けの wrangler 引数と token 上書きを組み立てる", async () => {
    let capturedArgs: string[] | undefined;
    let capturedEnv: Record<string, string> | undefined;

    const rows = await executeTelemetrySql("SELECT 1 AS n", {
      env: {
        CLOUDFLARE_API_TOKEN: "read-only-token",
        PATH: "/usr/bin",
        OTHER: undefined,
      },
      run: async (args, env) => {
        capturedArgs = args;
        capturedEnv = env;
        return JSON.stringify([{ results: [{ n: 1 }], success: true }]);
      },
    });

    expect(rows).toEqual([{ n: 1 }]);
    expect(capturedArgs).toEqual([
      "bunx",
      "wrangler",
      "d1",
      "execute",
      "TELEMETRY_DB",
      "--env",
      "prod",
      "--remote",
      "--json",
      "--command",
      "SELECT 1 AS n",
    ]);
    expect(capturedEnv).toEqual({
      PATH: "/usr/bin",
      CLOUDFLARE_API_TOKEN: "read-only-token",
    });
  });

  test("stdout が JSON でない場合は先頭を含めてエラーにする", async () => {
    await expect(
      executeTelemetrySql("SELECT 1", {
        env: { CLOUDFLARE_API_TOKEN: "token" },
        run: async () => "wrangler banner\nnot-json",
      }),
    ).rejects.toThrow(/Failed to parse wrangler JSON[\s\S]*wrangler banner/);
  });

  test("失敗時は stderr があっても stdout の本体エラーを落とさない", () => {
    expect(
      formatWranglerFailure(
        1,
        '{\n  "error": { "text": "Authentication error [code: 10000]" }\n}',
        "▲ [WARNING] Processing wrangler.toml configuration:",
      ),
    ).toContain("Authentication error [code: 10000]");
    expect(
      formatWranglerFailure(
        1,
        '{\n  "error": { "text": "Authentication error [code: 10000]" }\n}',
        "▲ [WARNING] Processing wrangler.toml configuration:",
      ),
    ).toContain("WARNING");
  });
});
