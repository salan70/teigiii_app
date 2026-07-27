import type { Env } from "../app";

const retentionMs = 30 * 24 * 60 * 60 * 1000;

type TelemetryRetentionLogEntry = {
  deleted: number;
  event: "telemetry_retention_completed";
};

type RunTelemetryRetentionOptions = {
  log?: (entry: TelemetryRetentionLogEntry) => void;
};

/**
 * フレーム計測の集計を30日で削除する。
 * 期限は `now - 30日` とし、`recorded_at` が期限以上の行は残す。
 *
 * @doc doc/specs/workers-api-server.md#フレーム計測テレメトリ
 */
export async function runTelemetryRetention(
  env: Pick<Env, "TELEMETRY_DB">,
  now: number,
  { log = (entry) => console.log(JSON.stringify(entry)) }: RunTelemetryRetentionOptions = {},
) {
  const cutoff = now - retentionMs;
  const result = await env.TELEMETRY_DB.prepare("delete from frame_stats where recorded_at < ?")
    .bind(cutoff)
    .run();

  log({ deleted: result.meta.changes ?? 0, event: "telemetry_retention_completed" });
}
