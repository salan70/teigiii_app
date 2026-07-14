import { sql } from "drizzle-orm";
import {
  check,
  index,
  integer,
  primaryKey,
  sqliteTable,
  text,
  uniqueIndex,
} from "drizzle-orm/sqlite-core";

// 日時列はすべて unix ミリ秒の INTEGER。API 境界で ISO 8601 に変換する。

/**
 * 旧 UserProfiles / UserConfigs / UserFollowCounts を統合した単一テーブル。
 * id は Firebase Auth の UID。フォロー数は follows の COUNT で算出する。
 */
export const users = sqliteTable(
  "users",
  {
    id: text("id").primaryKey(),
    publicId: text("public_id").notNull(),
    name: text("name").notNull(),
    bio: text("bio").notNull(),
    // R2 のオブジェクトキー。API レスポンス側で完全 URL に解決する。未設定は NULL。
    avatarKey: text("avatar_key"),
    lastOsVersion: text("last_os_version").notNull(),
    lastAppVersion: text("last_app_version").notNull(),
    createdAt: integer("created_at").notNull(),
    updatedAt: integer("updated_at").notNull(),
    // アカウント論理削除（30 日保持）。物理削除バッチはフェーズ 3 以降。
    deletedAt: integer("deleted_at"),
  },
  (table) => [uniqueIndex("users_public_id_unique").on(table.publicId)],
);

/**
 * 言葉はユーザー削除不可のグローバル資産のため deleted_at を持たない。
 * word の一意性は完全一致（前後トリム + NFC 正規化をサーバーで適用してから保存）。
 */
export const words = sqliteTable(
  "words",
  {
    id: text("id").primaryKey(),
    word: text("word").notNull(),
    reading: text("reading").notNull(),
    // あかさたな行ラベル。「ゃ→や」「が→か」等の行判定は SQL で書けないため書き込み時にサーバーで算出する。
    readingSubGroup: text("reading_sub_group").notNull(),
    // 登録者。内部記録のみで API レスポンスに含めない。
    createdBy: text("created_by").references(() => users.id, {
      onDelete: "set null",
    }),
    createdAt: integer("created_at").notNull(),
    updatedAt: integer("updated_at").notNull(),
  },
  (table) => [
    uniqueIndex("words_word_unique").on(table.word),
    index("words_reading_order_idx").on(table.readingSubGroup, table.reading, table.id),
    // 「見つける」フィードの言葉登録アクティビティ用
    index("words_created_at_idx").on(sql`${table.createdAt} desc`, table.id),
  ],
);

export const definitions = sqliteTable(
  "definitions",
  {
    id: text("id").primaryKey(),
    // 確定後は変更不可・下書き中は変更可（アプリ層で検証）
    wordId: text("word_id")
      .notNull()
      .references(() => words.id),
    authorId: text("author_id")
      .notNull()
      .references(() => users.id, { onDelete: "cascade" }),
    body: text("body").notNull(),
    status: text("status").notNull(),
    // 初めて public/private で確定した時刻。編集期限 = finalized_at + 1h はサーバーで毎回計算する。
    finalizedAt: integer("finalized_at"),
    // 確定後に本文を編集した場合のみ true。下書き中の編集・公開/非公開切り替えでは立てない。
    isEdited: integer("is_edited", { mode: "boolean" }).notNull().default(false),
    // 論理削除（30 日保持）
    deletedAt: integer("deleted_at"),
    createdAt: integer("created_at").notNull(),
    updatedAt: integer("updated_at").notNull(),
  },
  (table) => [
    check("definitions_status_check", sql`${table.status} in ('draft', 'public', 'private')`),
    // 確定状態と finalized_at の不変条件: draft は NULL、public/private は NOT NULL
    check(
      "definitions_finalized_at_check",
      sql`(${table.status} = 'draft') = (${table.finalizedAt} is null)`,
    ),
    // タイムライン（見つける / フォロー中）
    index("definitions_timeline_idx")
      .on(table.status, sql`${table.finalizedAt} desc`, table.id)
      .where(sql`${table.deletedAt} is null`),
    // 言葉ページの定義一覧
    index("definitions_word_idx")
      .on(table.wordId, table.status, sql`${table.finalizedAt} desc`)
      .where(sql`${table.deletedAt} is null`),
    // 自分の定義・下書き一覧
    index("definitions_author_idx")
      .on(table.authorId, table.status, sql`${table.updatedAt} desc`)
      .where(sql`${table.deletedAt} is null`),
  ],
);

/**
 * リアクションは Tier 1 の「いいね」1 種のみ。
 * Tier 2 の 3 種化は reaction_type 列追加 + PK 張り直しのマイグレーションで対応する。
 */
export const likes = sqliteTable(
  "likes",
  {
    userId: text("user_id")
      .notNull()
      .references(() => users.id, { onDelete: "cascade" }),
    definitionId: text("definition_id")
      .notNull()
      .references(() => definitions.id, { onDelete: "cascade" }),
    createdAt: integer("created_at").notNull(),
  },
  (table) => [
    primaryKey({ columns: [table.userId, table.definitionId] }),
    // いいね集計・いいねユーザー一覧
    index("likes_definition_idx").on(table.definitionId, table.createdAt),
    // いいねした定義一覧（いいね日時の降順の keyset ページング）
    index("likes_user_idx").on(table.userId, sql`${table.createdAt} desc`, table.definitionId),
  ],
);

export const follows = sqliteTable(
  "follows",
  {
    followerId: text("follower_id")
      .notNull()
      .references(() => users.id, { onDelete: "cascade" }),
    followingId: text("following_id")
      .notNull()
      .references(() => users.id, { onDelete: "cascade" }),
    createdAt: integer("created_at").notNull(),
  },
  (table) => [
    primaryKey({ columns: [table.followerId, table.followingId] }),
    check("follows_no_self_check", sql`${table.followerId} <> ${table.followingId}`),
    // フォロワー逆引き
    index("follows_following_idx").on(table.followingId, table.createdAt),
  ],
);

export const userMutes = sqliteTable(
  "user_mutes",
  {
    muterId: text("muter_id")
      .notNull()
      .references(() => users.id, { onDelete: "cascade" }),
    mutedUserId: text("muted_user_id")
      .notNull()
      .references(() => users.id, { onDelete: "cascade" }),
    createdAt: integer("created_at").notNull(),
  },
  (table) => [
    primaryKey({ columns: [table.muterId, table.mutedUserId] }),
    check("user_mutes_no_self_check", sql`${table.muterId} <> ${table.mutedUserId}`),
  ],
);

export const savedWords = sqliteTable(
  "saved_words",
  {
    userId: text("user_id")
      .notNull()
      .references(() => users.id, { onDelete: "cascade" }),
    wordId: text("word_id")
      .notNull()
      .references(() => words.id, { onDelete: "cascade" }),
    createdAt: integer("created_at").notNull(),
  },
  (table) => [primaryKey({ columns: [table.userId, table.wordId] })],
);

/**
 * 強制アップデート・メンテナンスモード用の単一行テーブル。
 * 運用時の書き換えは wrangler d1 execute で行う。
 */
export const appConfig = sqliteTable(
  "app_config",
  {
    id: integer("id").primaryKey(),
    minAppVersionIos: text("min_app_version_ios").notNull(),
    minAppVersionAndroid: text("min_app_version_android").notNull(),
    inMaintenance: integer("in_maintenance", { mode: "boolean" }).notNull().default(false),
    // メンテ中のみ設定
    maintenanceScheduledEndTime: integer("maintenance_scheduled_end_time"),
    updatedAt: integer("updated_at").notNull(),
  },
  (table) => [check("app_config_single_row_check", sql`${table.id} = 1`)],
);
