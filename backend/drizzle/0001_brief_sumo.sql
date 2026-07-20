CREATE TABLE `definition_drafts` (
	`id` text PRIMARY KEY NOT NULL,
	`user_id` text NOT NULL,
	`word_id` text,
	`word` text DEFAULT '' NOT NULL,
	`reading` text DEFAULT '' NOT NULL,
	`body` text DEFAULT '' NOT NULL,
	`visibility` text DEFAULT 'public' NOT NULL,
	`finalized_definition_id` text,
	`finalized_at` integer,
	`created_at` integer NOT NULL,
	`updated_at` integer NOT NULL,
	FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON UPDATE no action ON DELETE cascade,
	FOREIGN KEY (`word_id`) REFERENCES `words`(`id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`finalized_definition_id`) REFERENCES `definitions`(`id`) ON UPDATE no action ON DELETE no action,
	CONSTRAINT "definition_drafts_visibility_check" CHECK("definition_drafts"."visibility" in ('public', 'private')),
	CONSTRAINT "definition_drafts_finalized_check" CHECK(("definition_drafts"."finalized_definition_id" is null) = ("definition_drafts"."finalized_at" is null))
);
--> statement-breakpoint
CREATE UNIQUE INDEX `definition_drafts_finalized_definition_unique` ON `definition_drafts` (`finalized_definition_id`);--> statement-breakpoint
CREATE INDEX `definition_drafts_user_updated_idx` ON `definition_drafts` (`user_id`,"updated_at" desc,`id`) WHERE "definition_drafts"."finalized_definition_id" is null;--> statement-breakpoint
CREATE INDEX `definition_drafts_word_idx` ON `definition_drafts` (`user_id`,`word_id`,"updated_at" desc) WHERE "definition_drafts"."finalized_definition_id" is null;