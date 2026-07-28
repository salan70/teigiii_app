/**
 * prod TELEMETRY_DB への read-only 実行ヘルパー。
 * mutation の実効防御は perf-query の SELECT/WITH ガード。
 * CLOUDFLARE_API_TOKEN は D1 Read を運用前提とするが、Read でも
 * wrangler d1 execute --remote の INSERT が SQL 実行まで到達しうる（実測）。
 */

export function requireCloudflareApiToken(
  env: Record<string, string | undefined> = process.env,
): string {
  const token = env.CLOUDFLARE_API_TOKEN?.trim();
  if (!token) {
    throw new Error(
      "CLOUDFLARE_API_TOKEN is required. Use a Cloudflare API token with D1 Read only.",
    );
  }
  return token;
}

export function assertReadOnlySql(sql: string): void {
  if (!/^\s*(SELECT|WITH)\b/i.test(sql)) {
    throw new Error("Only SELECT/WITH queries are allowed via perf-query.");
  }
}

export function parsePerfQueryArgs(args: string[]): string {
  if (args.length === 0) {
    throw new Error("Usage: bun run scripts/perf-query.ts '<SQL>'");
  }
  if (args.length !== 1) {
    throw new Error("perf-query expects a single SQL argument.");
  }
  const sql = args[0]?.trim() ?? "";
  if (!sql) {
    throw new Error("Usage: bun run scripts/perf-query.ts '<SQL>'");
  }
  assertReadOnlySql(sql);
  return sql;
}

export function extractD1Rows(parsed: unknown): Record<string, unknown>[] {
  if (!Array.isArray(parsed) || parsed.length === 0) {
    throw new Error("Unexpected wrangler d1 execute --json shape: expected non-empty array");
  }
  const first = parsed[0] as { results?: unknown };
  if (first.results === undefined) {
    return [];
  }
  if (!Array.isArray(first.results)) {
    throw new Error("Unexpected wrangler d1 execute --json shape: results is not an array");
  }
  return first.results as Record<string, unknown>[];
}

/** wrangler は設定 WARNING を stderr、API エラー JSON を stdout に出すことがある */
export function formatWranglerFailure(exitCode: number, stdout: string, stderr: string): string {
  const parts = [`wrangler d1 execute failed (exit ${exitCode}):`];
  const err = stderr.trim();
  const out = stdout.trim();
  if (err) {
    parts.push(err);
  }
  if (out) {
    parts.push(out);
  }
  if (!err && !out) {
    parts.push("(no output)");
  }
  return parts.join("\n");
}

function parseWranglerJson(stdout: string): unknown {
  try {
    return JSON.parse(stdout) as unknown;
  } catch (error) {
    const preview = stdout.slice(0, 200);
    const reason = error instanceof Error ? error.message : String(error);
    throw new Error(`Failed to parse wrangler JSON (${reason}): ${preview}`, {
      cause: error,
    });
  }
}

export async function executeTelemetrySql(
  sql: string,
  options: {
    env?: Record<string, string | undefined>;
    run?: (args: string[], env: Record<string, string>) => Promise<string>;
  } = {},
): Promise<Record<string, unknown>[]> {
  const processEnv = options.env ?? process.env;
  const token = requireCloudflareApiToken(processEnv);
  const run =
    options.run ??
    (async (args, env) => {
      const proc = Bun.spawn(args, {
        cwd: process.cwd(),
        env,
        stdout: "pipe",
        stderr: "pipe",
      });
      const [stdout, stderr, exitCode] = await Promise.all([
        new Response(proc.stdout).text(),
        new Response(proc.stderr).text(),
        proc.exited,
      ]);
      if (exitCode !== 0) {
        throw new Error(formatWranglerFailure(exitCode, stdout, stderr));
      }
      return stdout;
    });

  const stdout = await run(
    [
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
      sql,
    ],
    {
      ...Object.fromEntries(
        Object.entries(processEnv).filter(
          (entry): entry is [string, string] => entry[1] !== undefined,
        ),
      ),
      CLOUDFLARE_API_TOKEN: token,
    },
  );

  return extractD1Rows(parseWranglerJson(stdout));
}
