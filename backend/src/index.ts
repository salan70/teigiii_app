import { app, type Env } from "./app";
import { runPhysicalDeletion } from "./maintenance/physical-deletion";

export default {
  fetch: app.fetch,
  scheduled(controller, env, context): void {
    context.waitUntil(runPhysicalDeletion(env, controller.scheduledTime));
  },
} satisfies ExportedHandler<Env>;
