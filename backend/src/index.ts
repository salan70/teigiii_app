import { app, type Env } from "./app";
import { runPhysicalDeletion } from "./maintenance/physical-deletion";
import { runTelemetryRetention } from "./telemetry/retention";

function logScheduledFailure(job: string, error: unknown): void {
  console.error(
    JSON.stringify({
      errorName: error instanceof Error ? error.name : "UnknownError",
      event: "scheduled_job_failed",
      job,
    }),
  );
}

export default {
  fetch: app.fetch,
  // 各ジョブは独立に待つ。一方が例外を投げても他方を止めない。
  scheduled(controller, env, context): void {
    context.waitUntil(
      runPhysicalDeletion(env, controller.scheduledTime).catch((error: unknown) => {
        logScheduledFailure("physical_deletion", error);
      }),
    );
    context.waitUntil(
      runTelemetryRetention(env, controller.scheduledTime).catch((error: unknown) => {
        logScheduledFailure("telemetry_retention", error);
      }),
    );
  },
} satisfies ExportedHandler<Env>;
