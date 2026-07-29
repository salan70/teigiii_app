-- #252: Draft 非採用。definitions.status から draft を外し、#248 検証残骸の definition_drafts を落とす。
PRAGMA foreign_keys=OFF;--> statement-breakpoint
DROP TABLE IF EXISTS `definition_drafts`;--> statement-breakpoint
DELETE FROM `likes` WHERE `definition_id` IN (
  SELECT `id` FROM `definitions` WHERE `status` = 'draft'
);--> statement-breakpoint
DELETE FROM `definitions` WHERE `status` = 'draft';--> statement-breakpoint
CREATE TABLE `__new_definitions` (
	`id` text PRIMARY KEY NOT NULL,
	`word_id` text NOT NULL,
	`author_id` text NOT NULL,
	`body` text NOT NULL,
	`status` text NOT NULL,
	`finalized_at` integer NOT NULL,
	`is_edited` integer DEFAULT false NOT NULL,
	`deleted_at` integer,
	`created_at` integer NOT NULL,
	`updated_at` integer NOT NULL,
	FOREIGN KEY (`word_id`) REFERENCES `words`(`id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`author_id`) REFERENCES `users`(`id`) ON UPDATE no action ON DELETE cascade,
	CONSTRAINT "definitions_status_check" CHECK("__new_definitions"."status" in ('public', 'private'))
);
--> statement-breakpoint
INSERT INTO `__new_definitions`("id", "word_id", "author_id", "body", "status", "finalized_at", "is_edited", "deleted_at", "created_at", "updated_at") SELECT "id", "word_id", "author_id", "body", "status", "finalized_at", "is_edited", "deleted_at", "created_at", "updated_at" FROM `definitions` WHERE `status` IN ('public', 'private') AND `finalized_at` IS NOT NULL;--> statement-breakpoint
DROP TABLE `definitions`;--> statement-breakpoint
ALTER TABLE `__new_definitions` RENAME TO `definitions`;--> statement-breakpoint
PRAGMA foreign_keys=ON;--> statement-breakpoint
CREATE INDEX `definitions_timeline_idx` ON `definitions` (`status`,"finalized_at" desc,`id`) WHERE "definitions"."deleted_at" is null;--> statement-breakpoint
CREATE INDEX `definitions_word_idx` ON `definitions` (`word_id`,`status`,"finalized_at" desc) WHERE "definitions"."deleted_at" is null;--> statement-breakpoint
CREATE INDEX `definitions_author_idx` ON `definitions` (`author_id`,`status`,"updated_at" desc) WHERE "definitions"."deleted_at" is null;
