import { describe, expect, test } from "bun:test";

import { buildMigrationSql, sqlString, sqlValue } from "./sql";
import type { UserRow, WordRow } from "./types";

describe("sqlString", () => {
  test("シングルクォートを二重化してエスケープする", () => {
    expect(sqlString("it's")).toBe("'it''s'");
  });

  test("通常の文字列はそのままクォートする", () => {
    expect(sqlString("hello")).toBe("'hello'");
  });
});

describe("sqlValue", () => {
  test("null は NULL リテラルになる", () => {
    expect(sqlValue(null)).toBe("NULL");
  });

  test("数値はそのまま文字列化する", () => {
    expect(sqlValue(1700000000000)).toBe("1700000000000");
  });

  test("非有限数はエラーになる", () => {
    expect(() => sqlValue(Number.NaN)).toThrow();
  });
});

describe("buildMigrationSql", () => {
  const user: UserRow = {
    id: "u1",
    public_id: "000000001",
    name: "テスト太郎",
    bio: "自己紹介 O'Brien",
    avatar_key: "avatars/u1",
    last_os_version: "iOS 18",
    last_app_version: "1.2.3",
    created_at: 1000,
    updated_at: 2000,
    deleted_at: null,
  };
  const word: WordRow = {
    id: "w1",
    word: "言葉",
    reading: "ことば",
    reading_sub_group: "か",
    created_by: null,
    created_at: 1000,
    updated_at: 1000,
  };

  test("DELETE が子テーブルから親テーブルの順で並ぶ", () => {
    const sql = buildMigrationSql({
      users: [],
      words: [],
      definitions: [],
      likes: [],
      follows: [],
      userMutes: [],
    });
    const order = ["likes", "follows", "user_mutes", "definitions", "words", "users"];
    const positions = order.map((table) => sql.indexOf(`delete from ${table};`));
    expect(positions.every((p) => p >= 0)).toBe(true);
    for (let i = 1; i < positions.length; i += 1) {
      expect(positions[i]).toBeGreaterThan(positions[i - 1]!);
    }
  });

  test("INSERT が親テーブルから子テーブルの順で並ぶ", () => {
    const sql = buildMigrationSql({
      users: [user],
      words: [word],
      definitions: [],
      likes: [],
      follows: [],
      userMutes: [],
    });
    const usersInsertPos = sql.indexOf("insert into users");
    const wordsInsertPos = sql.indexOf("insert into words");
    expect(usersInsertPos).toBeGreaterThan(-1);
    expect(wordsInsertPos).toBeGreaterThan(usersInsertPos);
  });

  test("文字列値のシングルクォートをエスケープして埋め込む", () => {
    const sql = buildMigrationSql({
      users: [user],
      words: [],
      definitions: [],
      likes: [],
      follows: [],
      userMutes: [],
    });
    expect(sql).toContain("O''Brien");
  });

  test("NULL 値をリテラルとして埋め込む", () => {
    const sql = buildMigrationSql({
      users: [],
      words: [word],
      definitions: [],
      likes: [],
      follows: [],
      userMutes: [],
    });
    // created_by は NULL
    expect(sql).toMatch(
      /insert into words[\s\S]*\('w1', '言葉', 'ことば', 'か', NULL, 1000, 1000\);/,
    );
  });

  test("空配列のテーブルは INSERT 文を生成しない", () => {
    const sql = buildMigrationSql({
      users: [],
      words: [],
      definitions: [],
      likes: [],
      follows: [],
      userMutes: [],
    });
    expect(sql).not.toContain("insert into");
  });
});
