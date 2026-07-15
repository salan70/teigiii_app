import type { Env } from "../src/app";

declare module "cloudflare:test" {
  interface ProvidedEnv extends Env {}
}
