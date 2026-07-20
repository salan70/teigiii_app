PRAGMA foreign_keys=OFF;--> statement-breakpoint
INSERT OR IGNORE INTO `definition_drafts`
  (`id`, `user_id`, `word_id`, `word`, `reading`, `body`, `visibility`, `created_at`, `updated_at`)
SELECT d.`id`, d.`author_id`, d.`word_id`, w.`word`, w.`reading`, d.`body`, 'public', d.`created_at`, d.`updated_at`
FROM `definitions` d
JOIN `words` w ON w.`id` = d.`word_id`
WHERE d.`status` = 'draft' AND d.`deleted_at` IS NULL;--> statement-breakpoint
DELETE FROM `likes` WHERE `definition_id` IN (
  SELECT `id` FROM `definitions` WHERE `status` = 'draft'
);--> statement-breakpoint
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
	CONSTRAINT "definitions_status_check" CHECK("status" in ('public', 'private'))
);
--> statement-breakpoint
INSERT INTO `__new_definitions`("id", "word_id", "author_id", "body", "status", "finalized_at", "is_edited", "deleted_at", "created_at", "updated_at") SELECT "id", "word_id", "author_id", "body", "status", "finalized_at", "is_edited", "deleted_at", "created_at", "updated_at" FROM `definitions` WHERE `status` IN ('public', 'private');--> statement-breakpoint
DROP TABLE `definitions`;--> statement-breakpoint
ALTER TABLE `__new_definitions` RENAME TO `definitions`;--> statement-breakpoint
PRAGMA foreign_keys=ON;--> statement-breakpoint
CREATE INDEX `definitions_timeline_idx` ON `definitions` (`status`, `finalized_at` DESC, `id`) WHERE `deleted_at` IS NULL;--> statement-breakpoint
CREATE INDEX `definitions_word_idx` ON `definitions` (`word_id`, `status`, `finalized_at` DESC) WHERE `deleted_at` IS NULL;--> statement-breakpoint
CREATE INDEX `definitions_author_idx` ON `definitions` (`author_id`, `status`, `updated_at` DESC) WHERE `deleted_at` IS NULL;
