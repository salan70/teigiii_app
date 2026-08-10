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
    expect(justfile).toMatch(
      /^backend-deploy-prod: backend-guard-prod\n {4}cd backend && bunx wrangler deploy --env prod\b/m,
    );
    const deploy = justfile.slice(justfile.indexOf("\nbackend-deploy-prod:"));
    expect(deploy.split("\n")[2]).not.toContain("migrations apply");
  });

  // prod に出ている commit を特定できないと、deploy し忘れをドリフト検査が検知できない。
  test("deploy stamps the deployed commit for drift detection", () => {
    expect(justfile).toContain('--var DEPLOYED_SHA:"$(git rev-parse HEAD)"');
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

  // commit 済みの migration が壊れた状態を作った場合の唯一の戻し手段。
  // 復元は prod への破壊的な上書きなので、明示確認なしに実行できてはならない。
  test("time travel recipes exist and restore asks for confirmation", () => {
    expect(justfile).toContain("wrangler d1 time-travel info DB --env prod");
    const restore = justfile.slice(
      justfile.indexOf("\nbackend-restore-prod "),
      justfile.indexOf("\n# prod の app_config を表示する"),
    );
    expect(restore).toContain("read -r -p");
    expect(restore).toContain("wrangler d1 time-travel restore DB --env prod");
  });

  // app_config の確認は読み取りのみに保つ。参照のつもりで prod を書き換える事故を防ぐ。
  test("prod app_config inspection stays read-only", () => {
    const inspect = justfile.slice(
      justfile.indexOf("\nbackend-app-config-prod:"),
      justfile.indexOf("\n# prod app-config の初期行"),
    );
    expect(inspect).toContain("select * from app_config");
    expect(inspect).not.toMatch(/insert|update|delete/i);
  });

  // min_app_version_* はアプリが Version.parse に直接渡す（app_config_state.dart）。
  // 壊れた値を prod に書くと全クライアントが起動時に例外で固まり、行を直すまで復帰しない。
  // 検証は remote への最初の書き込みより前に置く。
  test("min app version update validates before writing to prod", () => {
    const recipe = justfile.slice(
      justfile.indexOf("\nbackend-set-min-app-version-prod "),
      justfile.indexOf("\n# prod が origin/develop から乖離"),
    );
    const validation = recipe.indexOf("^[0-9]+\\.[0-9]+\\.[0-9]+$");
    expect(validation).toBeGreaterThan(-1);
    expect(validation).toBeLessThan(recipe.indexOf("wrangler d1 execute"));
    // 文字列補間だとクオートを含む値が SQL 自体を書き換えられる
    expect(recipe).not.toContain("{{ios}}");
    expect(recipe).not.toContain("{{android}}");
  });

  test("prod drift check does not write to prod", () => {
    expect(justfile).toMatch(/^backend-drift-check:\n {4}backend\/scripts\/drift-check\.sh$/m);
    const script = readFileSync(resolve(repositoryRoot, "backend/scripts/drift-check.sh"), "utf8");
    expect(script).not.toMatch(/wrangler (deploy\b|d1 execute|d1 migrations apply)/);
  });
});
