/**
 * 生成されたマイグレーション SQL が SQLite に適用でき、
 * 主要な制約（UNIQUE / CHECK / FK の削除連鎖）が効くことを検証する。
 * D1 の実体は SQLite のため bun:sqlite で代替する。
 */
import { Database } from "bun:sqlite";
import { beforeEach, describe, expect, test } from "bun:test";
import { readdirSync, readFileSync } from "node:fs";
import { join } from "node:path";

const migrationsDir = new URL("../drizzle", import.meta.url).pathname;

function migrationFiles(): string[] {
  return readdirSync(migrationsDir)
    .filter((f) => f.endsWith(".sql"))
    .toSorted();
}

function applyMigrationFiles(db: Database, files: string[]): void {
  for (const file of files) {
    const sql = readFileSync(join(migrationsDir, file), "utf8");
    for (const statement of sql.split("--> statement-breakpoint")) {
      db.run(statement);
    }
  }
}

function createDb(): Database {
  const db = new Database(":memory:");
  db.run("PRAGMA foreign_keys = ON");
  applyMigrationFiles(db, migrationFiles());
  return db;
}

const now = 1_752_000_000_000;

function insertUser(db: Database, id: string): void {
  db.run(
    `insert into users (id, public_id, name, bio, last_os_version, last_app_version, created_at, updated_at)
     values (?, ?, ?, '', 'iOS 19', '2.0.0', ?, ?)`,
    [id, `pub_${id}`, `user_${id}`, now, now],
  );
}

function insertWord(db: Database, id: string, word: string): void {
  db.run(
    `insert into words (id, word, reading, reading_sub_group, created_at, updated_at)
     values (?, ?, 'よみ', 'あ', ?, ?)`,
    [id, word, now, now],
  );
}

function insertDefinition(
  db: Database,
  id: string,
  opts: { wordId: string; authorId: string; status?: string; finalizedAt?: number | null },
): void {
  const status = opts.status ?? "public";
  const finalizedAt = opts.finalizedAt !== undefined ? opts.finalizedAt : now;
  db.run(
    `insert into definitions (id, word_id, author_id, body, status, finalized_at, created_at, updated_at)
     values (?, ?, ?, '本文', ?, ?, ?, ?)`,
    [id, opts.wordId, opts.authorId, status, finalizedAt, now, now],
  );
}

describe("migration SQL", () => {
  let db: Database;

  beforeEach(() => {
    db = createDb();
  });

  test("全テーブルが作成される", () => {
    const tables = db
      .query<{ name: string }, []>(
        "select name from sqlite_master where type = 'table' and name not like 'sqlite_%' order by name",
      )
      .all()
      .map((row) => row.name);
    expect(tables).toEqual([
      "app_config",
      "definitions",
      "follows",
      "likes",
      "saved_words",
      "user_mutes",
      "users",
      "word_registrations",
      "words",
    ]);
  });

  test("既存言葉は明示登録なし（first_registered_* が NULL）で移行される", () => {
    insertWord(db, "w1", "自由");
    expect(
      db.query("select first_registered_at, first_registered_by from words where id = 'w1'").get(),
    ).toEqual({
      first_registered_at: null,
      first_registered_by: null,
    });
  });

  test("同じユーザーの word_registrations は UNIQUE で拒否される", () => {
    insertUser(db, "u1");
    insertWord(db, "w1", "自由");
    db.run(
      "insert into word_registrations (id, word_id, user_id, created_at) values ('r1', 'w1', 'u1', ?)",
      [now],
    );
    expect(() =>
      db.run(
        "insert into word_registrations (id, word_id, user_id, created_at) values ('r2', 'w1', 'u1', ?)",
        [now],
      ),
    ).toThrow();
  });

  test("ユーザー物理削除で word_registrations.user_id と first_registered_by が NULL になる", () => {
    insertUser(db, "u1");
    insertWord(db, "w1", "自由");
    db.run(
      "update words set created_by = 'u1', first_registered_at = ?, first_registered_by = 'u1' where id = 'w1'",
      [now],
    );
    db.run(
      "insert into word_registrations (id, word_id, user_id, created_at) values ('r1', 'w1', 'u1', ?)",
      [now],
    );

    db.run("delete from users where id = 'u1'");

    expect(db.query("select user_id from word_registrations where id = 'r1'").get()).toEqual({
      user_id: null,
    });
    expect(
      db.query("select created_by, first_registered_by from words where id = 'w1'").get(),
    ).toEqual({
      created_by: null,
      first_registered_by: null,
    });
  });

  test("words.word の UNIQUE 制約が効く", () => {
    insertWord(db, "w1", "自由");
    expect(() => insertWord(db, "w2", "自由")).toThrow();
  });

  test("definitions.status は public / private のみ許可する", () => {
    insertUser(db, "u1");
    insertWord(db, "w1", "自由");
    expect(() =>
      insertDefinition(db, "d1", { wordId: "w1", authorId: "u1", status: "archived" }),
    ).toThrow();
    expect(() =>
      insertDefinition(db, "d2", { wordId: "w1", authorId: "u1", status: "draft" }),
    ).toThrow();
    insertDefinition(db, "d3", { wordId: "w1", authorId: "u1", status: "public" });
    insertDefinition(db, "d4", { wordId: "w1", authorId: "u1", status: "private" });
    expect(db.query("select count(*) as c from definitions").get()).toEqual({ c: 2 });
  });

  test("finalized_at は NOT NULL", () => {
    insertUser(db, "u1");
    insertWord(db, "w1", "自由");
    expect(() =>
      insertDefinition(db, "d1", { wordId: "w1", authorId: "u1", finalizedAt: null }),
    ).toThrow();
    insertDefinition(db, "d2", { wordId: "w1", authorId: "u1" });
    expect(db.query("select count(*) as c from definitions").get()).toEqual({ c: 1 });
  });

  test("definition_drafts テーブルは作成されない", () => {
    const tables = db
      .query<{ name: string }, []>(
        "select name from sqlite_master where type = 'table' and name = 'definition_drafts'",
      )
      .all();
    expect(tables).toEqual([]);
  });

  test("0003 は draft を落とし public/private と likes をトランザクション内でも保全する", () => {
    const migrating = new Database(":memory:");
    migrating.run("PRAGMA foreign_keys = ON");
    const files = migrationFiles();
    const before0003 = files.filter((f) => !f.startsWith("0003_"));
    const only0003 = files.filter((f) => f.startsWith("0003_"));
    applyMigrationFiles(migrating, before0003);

    insertUser(migrating, "u1");
    insertUser(migrating, "u2");
    insertWord(migrating, "w1", "自由");
    // 0002 までのスキーマでは draft + finalized_at NULL が合法
    migrating.run(
      `insert into definitions (id, word_id, author_id, body, status, finalized_at, created_at, updated_at)
       values ('d-draft', 'w1', 'u1', '下書き', 'draft', null, ?, ?)`,
      [now, now],
    );
    insertDefinition(migrating, "d-public", { wordId: "w1", authorId: "u1", status: "public" });
    insertDefinition(migrating, "d-private", { wordId: "w1", authorId: "u1", status: "private" });
    migrating.run(
      "insert into likes (user_id, definition_id, created_at) values ('u2', 'd-draft', ?)",
      [now],
    );
    migrating.run(
      "insert into likes (user_id, definition_id, created_at) values ('u2', 'd-public', ?)",
      [now],
    );
    migrating.run(
      "insert into likes (user_id, definition_id, created_at) values ('u2', 'd-private', ?)",
      [now],
    );

    // D1 / wrangler と同様に 1 ファイル分を暗黙トランザクションで適用する
    migrating.run("BEGIN");
    try {
      applyMigrationFiles(migrating, only0003);
      migrating.run("COMMIT");
    } catch (error) {
      migrating.run("ROLLBACK");
      throw error;
    }

    expect(migrating.query("select count(*) as c from definitions").get()).toEqual({ c: 2 });
    expect(
      migrating
        .query("select id from definitions order by id")
        .all()
        .map((row) => (row as { id: string }).id),
    ).toEqual(["d-private", "d-public"]);
    expect(migrating.query("select count(*) as c from likes").get()).toEqual({ c: 2 });
    expect(
      migrating
        .query("select definition_id from likes order by definition_id")
        .all()
        .map((row) => (row as { definition_id: string }).definition_id),
    ).toEqual(["d-private", "d-public"]);
    expect(
      migrating
        .query<{ name: string }, []>(
          "select name from sqlite_master where type = 'table' and name = 'definition_drafts'",
        )
        .all(),
    ).toEqual([]);
  });

  test("自分自身へのフォローが CHECK で拒否される", () => {
    insertUser(db, "u1");
    expect(() =>
      db.run("insert into follows (follower_id, following_id, created_at) values ('u1', 'u1', ?)", [
        now,
      ]),
    ).toThrow();
  });

  test("ユーザー物理削除で定義・いいねが連鎖削除され、言葉の登録者は NULL になる", () => {
    insertUser(db, "u1");
    insertUser(db, "u2");
    insertWord(db, "w1", "自由");
    db.run("update words set created_by = 'u1' where id = 'w1'");
    insertDefinition(db, "d1", { wordId: "w1", authorId: "u1" });
    db.run("insert into likes (user_id, definition_id, created_at) values ('u2', 'd1', ?)", [now]);

    db.run("delete from users where id = 'u1'");

    expect(db.query("select count(*) as c from definitions").get()).toEqual({ c: 0 });
    expect(db.query("select count(*) as c from likes").get()).toEqual({ c: 0 });
    expect(db.query("select created_by from words where id = 'w1'").get()).toEqual({
      created_by: null,
    });
    expect(db.query("select count(*) as c from words").get()).toEqual({ c: 1 });
  });

  test("app_config は id = 1 の単一行のみ許可される", () => {
    db.run(
      "insert into app_config (id, min_app_version_ios, min_app_version_android, updated_at) values (1, '2.0.0', '2.0.0', ?)",
      [now],
    );
    expect(() =>
      db.run(
        "insert into app_config (id, min_app_version_ios, min_app_version_android, updated_at) values (2, '2.0.0', '2.0.0', ?)",
        [now],
      ),
    ).toThrow();
  });
});
