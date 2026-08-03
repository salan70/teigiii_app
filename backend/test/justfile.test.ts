import { describe, expect, test } from "bun:test";
import { readFileSync } from "node:fs";
import { resolve } from "node:path";

const repositoryRoot = resolve(import.meta.dir, "../..");
const justfile = readFileSync(resolve(repositoryRoot, "justfile"), "utf8");

describe("prod backend recipes", () => {
  test("migration recipes stay independently invocable", () => {
    expect(justfile).toContain(`
backend-migrate-prod:
    cd backend && bunx wrangler d1 migrations apply DB --env prod --remote
`);
    expect(justfile).toContain(`
backend-migrate-prod-telemetry:
    cd backend && bunx wrangler d1 migrations apply TELEMETRY_DB --env prod --remote
`);
  });

  // deploy は wrangler rollback で可逆だが migration は forward-only で不可逆。
  // さらに正しい順序が migration の性質で反転する（additive なら migrate → deploy、
  // destructive なら deploy → migrate）ため、束ねると後者が扱えなくなる。
  test("deploy does not implicitly run migrations", () => {
    expect(justfile).toContain(`
backend-deploy-prod: backend-guard-prod
    cd backend && bunx wrangler deploy --env prod
`);
  });

  // prod はローカルから deploy するため、作業ツリーの中身がそのまま prod に出る事故を
  // guard で防ぐ。deploy から guard が外れると、この防御が無言で消える。
  test("deploy is gated by the prod guard", () => {
    expect(justfile).toMatch(/^backend-deploy-prod: backend-guard-prod$/m);
  });

  test("prod guard checks a clean tree, origin/develop parity, and a green CI", () => {
    const guard = justfile.slice(
      justfile.indexOf("\nbackend-guard-prod:"),
      justfile.indexOf("\nbackend-deploy-prod:"),
    );
    expect(guard).toContain("git diff --quiet");
    expect(guard).toContain("git rev-parse origin/develop");
    expect(guard).toContain("ci-passed");
  });
});
