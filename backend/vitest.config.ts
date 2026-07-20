import { cloudflareTest, readD1Migrations } from "@cloudflare/vitest-pool-workers";
import { defineConfig } from "vitest/config";

export default defineConfig({
  plugins: [
    cloudflareTest(async () => ({
      miniflare: {
        bindings: {
          TEST_MIGRATIONS: await readD1Migrations("./drizzle"),
        },
      },
      wrangler: { configPath: "./wrangler.toml" },
    })),
  ],
  test: {
    include: ["worker-test/**/*.workers.ts"],
  },
});
