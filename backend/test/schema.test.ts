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

function applyMigration(db: Database, file: string): void {
  const sql = readFileSync(join(migrationsDir, file), "utf8");
  for (const statement of sql.split("--> statement-breakpoint")) {
    db.run(statement);
  }
}

function createDb(): Database {
  const db = new Database(":memory:");
  db.run("PRAGMA foreign_keys = ON");
  const files = readdirSync(migrationsDir)
    .filter((f) => f.endsWith(".sql"))
    .toSorted();
  for (const file of files) {
    applyMigration(db, file);
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
      "definition_drafts",
      "definitions",
      "follows",
      "likes",
      "saved_words",
      "user_mutes",
      "users",
      "words",
    ]);
  });

  test("definition_drafts は部分入力と同一言葉の複数下書きを保持できる", () => {
    insertUser(db, "u1");
    insertWord(db, "w1", "自由");

    db.run(
      `insert into definition_drafts
       (id, user_id, word_id, word, reading, body, visibility, created_at, updated_at)
       values ('draft-1', 'u1', 'w1', '', '', '本文だけ', 'public', ?, ?),
              ('draft-2', 'u1', 'w1', '自由', '', '', 'private', ?, ?)`,
      [now, now, now, now],
    );

    expect(db.query("select id, word_id, body from definition_drafts order by id").all()).toEqual([
      { body: "本文だけ", id: "draft-1", word_id: "w1" },
      { body: "", id: "draft-2", word_id: "w1" },
    ]);
  });

  test("definition_drafts は公開範囲と finalize 対応の制約を持つ", () => {
    insertUser(db, "u1");

    expect(() =>
      db.run(
        `insert into definition_drafts
         (id, user_id, word, reading, body, visibility, created_at, updated_at)
         values ('draft-1', 'u1', '言葉', 'ことば', '本文', 'draft', ?, ?)`,
        [now, now],
      ),
    ).toThrow();
  });

  test("既存の definitions draft を専用テーブルへ欠損なく移行する", () => {
    const legacyDb = new Database(":memory:");
    legacyDb.run("PRAGMA foreign_keys = ON");
    applyMigration(legacyDb, "0000_absurd_power_pack.sql");
    applyMigration(legacyDb, "0001_brief_sumo.sql");
    insertUser(legacyDb, "u1");
    insertUser(legacyDb, "u2");
    insertWord(legacyDb, "w1", "自由");
    insertDefinition(legacyDb, "draft-1", {
      authorId: "u1",
      finalizedAt: null,
      status: "draft",
      wordId: "w1",
    });
    insertDefinition(legacyDb, "public-1", { authorId: "u1", wordId: "w1" });
    legacyDb.run(
      "insert into likes (user_id, definition_id, created_at) values ('u2', 'draft-1', ?), ('u2', 'public-1', ?)",
      [now, now],
    );

    applyMigration(legacyDb, "0002_tense_carmella_unuscione.sql");

    expect(
      legacyDb.query("select id, word_id, user_id, body, visibility from definition_drafts").all(),
    ).toEqual([
      {
        body: "本文",
        id: "draft-1",
        user_id: "u1",
        visibility: "public",
        word_id: "w1",
      },
    ]);
    expect(legacyDb.query("select id, status from definitions").all()).toEqual([
      { id: "public-1", status: "public" },
    ]);
    expect(legacyDb.query("select definition_id from likes").all()).toEqual([
      { definition_id: "public-1" },
    ]);
    expect(legacyDb.query("pragma foreign_key_check").all()).toEqual([]);
  });

  test("words.word の UNIQUE 制約が効く", () => {
    insertWord(db, "w1", "自由");
    expect(() => insertWord(db, "w2", "自由")).toThrow();
  });

  test("definitions.status は確定状態だけを許可する", () => {
    insertUser(db, "u1");
    insertWord(db, "w1", "自由");
    expect(() =>
      insertDefinition(db, "d1", { wordId: "w1", authorId: "u1", status: "archived" }),
    ).toThrow();
    expect(() =>
      insertDefinition(db, "d2", {
        wordId: "w1",
        authorId: "u1",
        status: "draft",
        finalizedAt: null,
      }),
    ).toThrow();
  });

  test("確定済み定義は finalized_at が必須", () => {
    insertUser(db, "u1");
    insertWord(db, "w1", "自由");
    // public なのに finalized_at が NULL → 拒否
    expect(() =>
      insertDefinition(db, "d1", { wordId: "w1", authorId: "u1", finalizedAt: null }),
    ).toThrow();
    insertDefinition(db, "d2", { wordId: "w1", authorId: "u1" });
    expect(db.query("select count(*) as c from definitions").get()).toEqual({ c: 1 });
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
