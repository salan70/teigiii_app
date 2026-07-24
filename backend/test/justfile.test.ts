import { describe, expect, test } from "bun:test";
import { resolve } from "node:path";

const repositoryRoot = resolve(import.meta.dir, "../..");
const decoder = new TextDecoder();

function dryRun(recipe: string): { exitCode: number; output: string } {
  const result = Bun.spawnSync(["just", "--dry-run", recipe], {
    cwd: repositoryRoot,
    stderr: "pipe",
    stdout: "pipe",
  });

  return {
    exitCode: result.exitCode,
    output: `${decoder.decode(result.stdout)}${decoder.decode(result.stderr)}`,
  };
}

describe("prod backend recipes", () => {
  test("deploy runs the prod migration before deploying the Worker", () => {
    const result = dryRun("backend-deploy-prod");
    const migration = "cd backend && bunx wrangler d1 migrations apply DB --env prod --remote";
    const deploy = "cd backend && bunx wrangler deploy --env prod";

    expect(result.exitCode).toBe(0);
    expect(result.output).toContain(migration);
    expect(result.output).toContain(deploy);
    expect(result.output.indexOf(migration)).toBeLessThan(result.output.indexOf(deploy));
  });
});
