/**
 * prod TELEMETRY_DB への read-only 実行ヘルパー。
 * mutation は Cloudflare API token の権限で拒否される前提。
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

  return extractD1Rows(JSON.parse(stdout) as unknown);
}
