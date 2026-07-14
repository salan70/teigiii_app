CREATE TABLE `app_config` (
	`id` integer PRIMARY KEY NOT NULL,
	`min_app_version_ios` text NOT NULL,
	`min_app_version_android` text NOT NULL,
	`in_maintenance` integer DEFAULT false NOT NULL,
	`maintenance_scheduled_end_time` integer,
	`updated_at` integer NOT NULL,
	CONSTRAINT "app_config_single_row_check" CHECK("app_config"."id" = 1)
);
--> statement-breakpoint
CREATE TABLE `definitions` (
	`id` text PRIMARY KEY NOT NULL,
	`word_id` text NOT NULL,
	`author_id` text NOT NULL,
	`body` text NOT NULL,
	`status` text NOT NULL,
	`finalized_at` integer,
	`is_edited` integer DEFAULT false NOT NULL,
	`deleted_at` integer,
	`created_at` integer NOT NULL,
	`updated_at` integer NOT NULL,
	FOREIGN KEY (`word_id`) REFERENCES `words`(`id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`author_id`) REFERENCES `users`(`id`) ON UPDATE no action ON DELETE cascade,
	CONSTRAINT "definitions_status_check" CHECK("definitions"."status" in ('draft', 'public', 'private'))
);
--> statement-breakpoint
CREATE INDEX `definitions_timeline_idx` ON `definitions` (`status`,"finalized_at" desc,`id`) WHERE "definitions"."deleted_at" is null;--> statement-breakpoint
CREATE INDEX `definitions_word_idx` ON `definitions` (`word_id`,`status`,"finalized_at" desc) WHERE "definitions"."deleted_at" is null;--> statement-breakpoint
CREATE INDEX `definitions_author_idx` ON `definitions` (`author_id`,`status`,"updated_at" desc) WHERE "definitions"."deleted_at" is null;--> statement-breakpoint
CREATE TABLE `follows` (
	`follower_id` text NOT NULL,
	`following_id` text NOT NULL,
	`created_at` integer NOT NULL,
	PRIMARY KEY(`follower_id`, `following_id`),
	FOREIGN KEY (`follower_id`) REFERENCES `users`(`id`) ON UPDATE no action ON DELETE cascade,
	FOREIGN KEY (`following_id`) REFERENCES `users`(`id`) ON UPDATE no action ON DELETE cascade,
	CONSTRAINT "follows_no_self_check" CHECK("follows"."follower_id" <> "follows"."following_id")
);
--> statement-breakpoint
CREATE INDEX `follows_following_idx` ON `follows` (`following_id`,`created_at`);--> statement-breakpoint
CREATE TABLE `likes` (
	`user_id` text NOT NULL,
	`definition_id` text NOT NULL,
	`created_at` integer NOT NULL,
	PRIMARY KEY(`user_id`, `definition_id`),
	FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON UPDATE no action ON DELETE cascade,
	FOREIGN KEY (`definition_id`) REFERENCES `definitions`(`id`) ON UPDATE no action ON DELETE cascade
);
--> statement-breakpoint
CREATE INDEX `likes_definition_idx` ON `likes` (`definition_id`,`created_at`);--> statement-breakpoint
CREATE TABLE `saved_words` (
	`user_id` text NOT NULL,
	`word_id` text NOT NULL,
	`created_at` integer NOT NULL,
	PRIMARY KEY(`user_id`, `word_id`),
	FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON UPDATE no action ON DELETE cascade,
	FOREIGN KEY (`word_id`) REFERENCES `words`(`id`) ON UPDATE no action ON DELETE cascade
);
--> statement-breakpoint
CREATE TABLE `user_mutes` (
	`muter_id` text NOT NULL,
	`muted_user_id` text NOT NULL,
	`created_at` integer NOT NULL,
	PRIMARY KEY(`muter_id`, `muted_user_id`),
	FOREIGN KEY (`muter_id`) REFERENCES `users`(`id`) ON UPDATE no action ON DELETE cascade,
	FOREIGN KEY (`muted_user_id`) REFERENCES `users`(`id`) ON UPDATE no action ON DELETE cascade,
	CONSTRAINT "user_mutes_no_self_check" CHECK("user_mutes"."muter_id" <> "user_mutes"."muted_user_id")
);
--> statement-breakpoint
CREATE TABLE `users` (
	`id` text PRIMARY KEY NOT NULL,
	`public_id` text NOT NULL,
	`name` text NOT NULL,
	`bio` text NOT NULL,
	`avatar_key` text,
	`last_os_version` text NOT NULL,
	`last_app_version` text NOT NULL,
	`created_at` integer NOT NULL,
	`updated_at` integer NOT NULL,
	`deleted_at` integer
);
--> statement-breakpoint
CREATE UNIQUE INDEX `users_public_id_unique` ON `users` (`public_id`);--> statement-breakpoint
CREATE TABLE `words` (
	`id` text PRIMARY KEY NOT NULL,
	`word` text NOT NULL,
	`reading` text NOT NULL,
	`reading_sub_group` text NOT NULL,
	`created_by` text,
	`created_at` integer NOT NULL,
	`updated_at` integer NOT NULL,
	FOREIGN KEY (`created_by`) REFERENCES `users`(`id`) ON UPDATE no action ON DELETE set null
);
--> statement-breakpoint
CREATE UNIQUE INDEX `words_word_unique` ON `words` (`word`);--> statement-breakpoint
CREATE INDEX `words_reading_order_idx` ON `words` (`reading_sub_group`,`reading`,`id`);--> statement-breakpoint
CREATE INDEX `words_created_at_idx` ON `words` ("created_at" desc,`id`);