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

function createDb(): Database {
  const db = new Database(":memory:");
  db.run("PRAGMA foreign_keys = ON");
  const files = readdirSync(migrationsDir)
    .filter((f) => f.endsWith(".sql"))
    .toSorted();
  for (const file of files) {
    const sql = readFileSync(join(migrationsDir, file), "utf8");
    for (const statement of sql.split("--> statement-breakpoint")) {
      db.run(statement);
    }
  }
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
  // 不変条件: draft は finalized_at NULL、public/private は NOT NULL
  const finalizedAt =
    opts.finalizedAt !== undefined ? opts.finalizedAt : status === "draft" ? null : now;
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

  test("definitions.status の CHECK 制約が効く", () => {
    insertUser(db, "u1");
    insertWord(db, "w1", "自由");
    expect(() =>
      insertDefinition(db, "d1", { wordId: "w1", authorId: "u1", status: "archived" }),
    ).toThrow();
  });

  test("finalized_at の不変条件が CHECK で強制される", () => {
    insertUser(db, "u1");
    insertWord(db, "w1", "自由");
    // public なのに finalized_at が NULL → 拒否
    expect(() =>
      insertDefinition(db, "d1", { wordId: "w1", authorId: "u1", finalizedAt: null }),
    ).toThrow();
    // draft なのに finalized_at がある → 拒否
    expect(() =>
      insertDefinition(db, "d2", {
        wordId: "w1",
        authorId: "u1",
        status: "draft",
        finalizedAt: now,
      }),
    ).toThrow();
    // 正しい組み合わせは通る
    insertDefinition(db, "d3", { wordId: "w1", authorId: "u1" });
    insertDefinition(db, "d4", { wordId: "w1", authorId: "u1", status: "draft" });
    expect(db.query("select count(*) as c from definitions").get()).toEqual({ c: 2 });
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
