DROP INDEX `words_word_unique`;--> statement-breakpoint
CREATE UNIQUE INDEX `words_word_reading_unique` ON `words` (`word`,`reading`);