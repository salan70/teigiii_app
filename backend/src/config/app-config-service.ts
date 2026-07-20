import { ApiError } from "../errors";

type AppConfigRow = {
  in_maintenance: number;
  maintenance_scheduled_end_time: number | null;
  min_app_version_android: string;
  min_app_version_ios: string;
  updated_at: number;
};

/**
 * @doc doc/specs/workers-api-server.md#app-config
 */
export class AppConfigService {
  constructor(private readonly database: D1Database) {}

  async get() {
    const row = await this.database
      .prepare(
        `select min_app_version_ios, min_app_version_android, in_maintenance,
                maintenance_scheduled_end_time, updated_at
         from app_config
         where id = 1`,
      )
      .first<AppConfigRow>();
    if (row === null) {
      throw new ApiError(500, "app_config_unavailable", "App config unavailable");
    }

    return {
      inMaintenance: row.in_maintenance !== 0,
      maintenanceScheduledEndTime:
        row.maintenance_scheduled_end_time === null
          ? null
          : new Date(row.maintenance_scheduled_end_time).toISOString(),
      minAppVersionAndroid: row.min_app_version_android,
      minAppVersionIos: row.min_app_version_ios,
      updatedAt: new Date(row.updated_at).toISOString(),
    };
  }
}
