CREATE TABLE `frame_stats` (
	`id` text PRIMARY KEY NOT NULL,
	`session_id` text NOT NULL,
	`screen_name` text NOT NULL,
	`recorded_at` integer NOT NULL,
	`app_version` text NOT NULL,
	`build_number` integer NOT NULL,
	`flavor` text NOT NULL,
	`platform` text NOT NULL,
	`os_version` text NOT NULL,
	`device_model` text NOT NULL,
	`refresh_rate_hz` integer NOT NULL,
	`frame_count` integer NOT NULL,
	`slow_build_count` integer NOT NULL,
	`slow_raster_count` integer NOT NULL,
	`frozen_count` integer NOT NULL,
	`sum_build_us` integer NOT NULL,
	`sum_raster_us` integer NOT NULL,
	`max_build_us` integer NOT NULL,
	`max_raster_us` integer NOT NULL,
	`created_at` integer NOT NULL
);
--> statement-breakpoint
CREATE INDEX `frame_stats_recorded_at_index` ON `frame_stats` (`recorded_at`);--> statement-breakpoint
CREATE INDEX `frame_stats_created_at_index` ON `frame_stats` (`created_at`);--> statement-breakpoint
CREATE INDEX `frame_stats_platform_flavor_build_index` ON `frame_stats` (`platform`,`flavor`,`build_number`);