// D1 投入用 SQL 生成。wipe-and-reload（先頭で全行 DELETE → INSERT）。
// `wrangler d1 execute --remote --file` にそのまま渡せる .sql テキストを組み立てる。
//
// FK 順序:
//   DELETE（子 → 親）: likes, follows, user_mutes, definitions, words, users
//   INSERT（親 → 子）: users, words, definitions, likes, follows, user_mutes
// saved_words / app_config はこの移行の対象外のため触らない。

import type { DefinitionRow, FollowRow, LikeRow, UserMuteRow, UserRow, WordRow } from "./types";

const deleteOrder = ["likes", "follows", "user_mutes", "definitions", "words", "users"] as const;

const insertChunkSize = 200;

export type SqlValue = string | number | null;

/** SQLite/D1 向けの文字列リテラルエスケープ（シングルクォートを二重化）。 */
export function sqlString(value: string): string {
  return `'${value.replaceAll("'", "''")}'`;
}

export function sqlValue(value: SqlValue): string {
  if (value === null) return "NULL";
  if (typeof value === "number") {
    if (!Number.isFinite(value)) {
      throw new Error(`cannot serialize non-finite number to SQL: ${value}`);
    }
    return String(value);
  }
  return sqlString(value);
}

function buildInsertStatements(
  table: string,
  columns: readonly string[],
  rows: readonly (readonly SqlValue[])[],
): string[] {
  if (rows.length === 0) return [];
  const statements: string[] = [];
  for (let offset = 0; offset < rows.length; offset += insertChunkSize) {
    const chunk = rows.slice(offset, offset + insertChunkSize);
    const valuesClause = chunk.map((row) => `  (${row.map(sqlValue).join(", ")})`).join(",\n");
    statements.push(`insert into ${table} (${columns.join(", ")})\nvalues\n${valuesClause};`);
  }
  return statements;
}

export type MigrationSqlInput = {
  users: UserRow[];
  words: WordRow[];
  definitions: DefinitionRow[];
  likes: LikeRow[];
  follows: FollowRow[];
  userMutes: UserMuteRow[];
};

/** wipe-and-reload の全 SQL 文を組み立てる（DELETE → INSERT の順）。 */
export function buildMigrationSql(input: MigrationSqlInput): string {
  const statements: string[] = [
    "pragma foreign_keys = off;",
    ...deleteOrder.map((table) => `delete from ${table};`),
    ...buildInsertStatements(
      "users",
      [
        "id",
        "public_id",
        "name",
        "bio",
        "avatar_key",
        "last_os_version",
        "last_app_version",
        "created_at",
        "updated_at",
        "deleted_at",
      ],
      input.users.map((row) => [
        row.id,
        row.public_id,
        row.name,
        row.bio,
        row.avatar_key,
        row.last_os_version,
        row.last_app_version,
        row.created_at,
        row.updated_at,
        row.deleted_at,
      ]),
    ),
    ...buildInsertStatements(
      "words",
      ["id", "word", "reading", "reading_sub_group", "created_by", "created_at", "updated_at"],
      input.words.map((row) => [
        row.id,
        row.word,
        row.reading,
        row.reading_sub_group,
        row.created_by,
        row.created_at,
        row.updated_at,
      ]),
    ),
    ...buildInsertStatements(
      "definitions",
      [
        "id",
        "word_id",
        "author_id",
        "body",
        "status",
        "finalized_at",
        "is_edited",
        "deleted_at",
        "created_at",
        "updated_at",
      ],
      input.definitions.map((row) => [
        row.id,
        row.word_id,
        row.author_id,
        row.body,
        row.status,
        row.finalized_at,
        row.is_edited,
        row.deleted_at,
        row.created_at,
        row.updated_at,
      ]),
    ),
    ...buildInsertStatements(
      "likes",
      ["user_id", "definition_id", "created_at"],
      input.likes.map((row) => [row.user_id, row.definition_id, row.created_at]),
    ),
    ...buildInsertStatements(
      "follows",
      ["follower_id", "following_id", "created_at"],
      input.follows.map((row) => [row.follower_id, row.following_id, row.created_at]),
    ),
    ...buildInsertStatements(
      "user_mutes",
      ["muter_id", "muted_user_id", "created_at"],
      input.userMutes.map((row) => [row.muter_id, row.muted_user_id, row.created_at]),
    ),
    "pragma foreign_keys = on;",
  ];
  return `${statements.join("\n\n")}\n`;
}
