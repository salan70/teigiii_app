/**
 * prod TELEMETRY_DB への read-only 実行ヘルパー。
 * mutation は Cloudflare API token の権限で拒否される前提。
 * perf-query 側でも SELECT/WITH 以外を弾く。
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
        throw new Error(`wrangler d1 execute failed (exit ${exitCode}):\n${stderr || stdout}`);
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
