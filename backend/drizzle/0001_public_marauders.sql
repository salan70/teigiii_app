CREATE TABLE `word_registrations` (
	`id` text PRIMARY KEY NOT NULL,
	`word_id` text NOT NULL,
	`user_id` text,
	`created_at` integer NOT NULL,
	FOREIGN KEY (`word_id`) REFERENCES `words`(`id`) ON UPDATE no action ON DELETE cascade,
	FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON UPDATE no action ON DELETE set null
);
--> statement-breakpoint
CREATE UNIQUE INDEX `word_registrations_word_user_unique` ON `word_registrations` (`word_id`,`user_id`) WHERE "word_registrations"."user_id" is not null;--> statement-breakpoint
CREATE INDEX `word_registrations_word_idx` ON `word_registrations` (`word_id`);--> statement-breakpoint
DROP INDEX `words_created_at_idx`;--> statement-breakpoint
ALTER TABLE `words` ADD `first_registered_at` integer;--> statement-breakpoint
ALTER TABLE `words` ADD `first_registered_by` text REFERENCES users(id) ON DELETE SET NULL;--> statement-breakpoint
CREATE INDEX `words_first_registered_at_idx` ON `words` ("first_registered_at" desc,`id`);