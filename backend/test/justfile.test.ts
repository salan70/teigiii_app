import { describe, expect, test } from "bun:test";
import { readFileSync } from "node:fs";
import { resolve } from "node:path";

const repositoryRoot = resolve(import.meta.dir, "../..");
const justfile = readFileSync(resolve(repositoryRoot, "justfile"), "utf8");

describe("prod backend recipes", () => {
  test("deploy depends on the prod migration before deploying the Worker", () => {
    expect(justfile).toContain(`
backend-migrate-prod:
    cd backend && bunx wrangler d1 migrations apply DB --env prod --remote
`);
    expect(justfile).toContain(`
backend-migrate-prod-telemetry:
    cd backend && bunx wrangler d1 migrations apply TELEMETRY_DB --env prod --remote
`);
    expect(justfile).toContain(`
backend-deploy-prod: backend-migrate-prod backend-migrate-prod-telemetry
    cd backend && bunx wrangler deploy --env prod
`);
  });
});
