import type { D1Migration } from "@cloudflare/vitest-pool-workers";
import type { Env as AppEnv } from "../src/app";

declare global {
  namespace Cloudflare {
    interface Env extends AppEnv {
      TEST_MIGRATIONS: D1Migration[];
      TEST_TELEMETRY_MIGRATIONS: D1Migration[];
    }
  }
}
