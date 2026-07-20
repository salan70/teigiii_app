// Firestore → D1 / R2 移行スクリプト共通の型定義。
// スナップショット NDJSON のレコード形状（Firestore ドキュメントに対応）と、
// D1 に投入する行の形状（drizzle スキーマの snake_case 列に対応）を分けて持つ。
//
// フィールド名は旧 Flutter 実装（lib/util/constant/firestore_collections.dart、
// 各 *_document.dart）に対応する。破棄対象フィールド（非正規化データ等）は含めない。

/** スナップショットディレクトリ配下の NDJSON ファイル名（拡張子なし）。 */
export const firestoreCollectionNames = [
  "Words",
  "Definitions",
  "WordDefinitionRelations",
  "Likes",
  "UserProfiles",
  "UserConfigs",
  "UserFollows",
  "UserFollowCounts",
] as const;

export type FirestoreCollectionName = (typeof firestoreCollectionNames)[number];

/** Firestore Timestamp はエクスポート時に unix ミリ秒へ変換済み。 */
export type WordRecord = {
  id: string;
  word: string;
  reading: string;
  createdAt: number;
  updatedAt: number;
};

export type DefinitionRecord = {
  id: string;
  wordId: string;
  authorId: string;
  definition: string;
  isPublic: boolean;
  isEdited: boolean;
  createdAt: number;
  updatedAt: number;
};

export type LikeRecord = {
  id: string;
  definitionId: string;
  userId: string;
  createdAt: number;
};

export type UserProfileRecord = {
  id: string;
  publicId: string;
  name: string;
  bio: string;
  profileImageUrl: string;
  createdAt: number;
  updatedAt: number;
};

export type UserConfigRecord = {
  id: string;
  appVersion: string;
  osVersion: string;
  mutedUserIdList: string[];
  createdAt: number;
  updatedAt: number;
};

/**
 * 旧 Firestore UserFollows。フィールド名と実際の向きが逆な点に注意:
 * `followerId` はフォローされる側、`followingId` はフォローする側を指す
 * （旧 `UserFollowRepository.follow` の保存形状）。D1 の follows へは
 * `transformFollows` で向きを入れ替えて変換する。
 */
export type UserFollowRecord = {
  id: string;
  followerId: string;
  followingId: string;
  createdAt: number;
};

/** WordDefinitionRelations / UserFollowCounts は破棄対象だが export 対象ではあるため型だけ持つ。 */
export type RawRecord = Record<string, unknown> & { id: string };

/** エクスポート時にユーザーごとに解決したアバターの取得元情報。 */
export type AvatarManifestEntry = {
  uid: string;
  /** スナップショット内の相対パス（avatar-objects/ 配下）。同じ画像を指す複数ユーザーで共有され得る。 */
  snapshotRelativePath: string;
  classification: { type: "default"; slug: string } | { type: "custom" };
};

export type AvatarManifest = {
  entries: AvatarManifestEntry[];
};

// ---- D1 に投入する行（snake_case、drizzle スキーマに対応） ----

export type UserRow = {
  id: string;
  public_id: string;
  name: string;
  bio: string;
  avatar_key: string | null;
  last_os_version: string;
  last_app_version: string;
  created_at: number;
  updated_at: number;
  deleted_at: null;
};

export type UserMuteRow = {
  muter_id: string;
  muted_user_id: string;
  created_at: number;
};

export type WordRow = {
  id: string;
  word: string;
  reading: string;
  reading_sub_group: string;
  created_by: null;
  created_at: number;
  updated_at: number;
};

export type DefinitionRow = {
  id: string;
  word_id: string;
  author_id: string;
  body: string;
  status: "public" | "private";
  finalized_at: number;
  is_edited: 0 | 1;
  deleted_at: null;
  created_at: number;
  updated_at: number;
};

export type LikeRow = {
  user_id: string;
  definition_id: string;
  created_at: number;
};

export type FollowRow = {
  follower_id: string;
  following_id: string;
  created_at: number;
};

/** 移行レポート: fail-fast にならない不整合（drop / 補完）の記録。verify がこの内容と突合する。 */
export type MigrationReport = {
  generatedAt: string;
  droppedForeignKeyOrphans: {
    table: "definitions" | "likes" | "follows" | "user_mutes";
    reason: string;
    count: number;
    ids: string[];
  }[];
  defaultedMissingUserConfigs: {
    userId: string;
  }[];
  avatarClassificationCounts: {
    default: number;
    custom: number;
  };
  mergedWordDuplicates: {
    normalizedWord: string;
    canonicalId: string;
    mergedIds: string[];
  }[];
};
