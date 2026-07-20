// Firestore スナップショット → D1 行への変換（純粋関数群）。
// plan（doc/plans/2026-07-20-data-migration-bigbang-switchover.md）決定事項 3・4 に準拠。
//
// - words の正規化衝突: fail-fast（WordCollisionError を投げる）
// - FK 孤児（存在しないユーザー/定義/言葉への参照）: drop してレポートに記録
// - UserConfigs 欠損: 'unknown' 補完してレポートに記録
// - profileImageUrl が既知パターン外: fail-fast（avatar.ts の classifyAvatarUrl が投げる）

import { normalizeText } from "../../src/lib/normalize";
import { readingSubGroup } from "../../src/words/reading-sub-group";
import { classifyAvatarUrl, type AvatarClassification } from "./avatar";
import type {
  DefinitionRecord,
  DefinitionRow,
  FollowRow,
  LikeRecord,
  LikeRow,
  MigrationReport,
  UserConfigRecord,
  UserFollowRecord,
  UserMuteRow,
  UserProfileRecord,
  UserRow,
  WordRecord,
  WordRow,
} from "./types";

const unknownVersionPlaceholder = "unknown";

// ---- words ----

export type WordCollisionGroup = {
  normalizedWord: string;
  originalWords: { id: string; word: string }[];
};

/** trim + NFC 正規化後に同一になる語をグループ化し、2 件以上のグループのみ返す。 */
export function detectWordCollisions(words: readonly WordRecord[]): WordCollisionGroup[] {
  const groups = new Map<string, { id: string; word: string }[]>();
  for (const word of words) {
    const normalizedWord = normalizeText(word.word);
    const group = groups.get(normalizedWord) ?? [];
    group.push({ id: word.id, word: word.word });
    groups.set(normalizedWord, group);
  }
  return [...groups.entries()]
    .filter(([, originalWords]) => originalWords.length > 1)
    .map(([normalizedWord, originalWords]) => ({ normalizedWord, originalWords }));
}

export class WordCollisionError extends Error {
  constructor(readonly collisions: WordCollisionGroup[]) {
    super(
      `word normalization collisions detected (${collisions.length} group(s)): ` +
        collisions
          .map(
            (group) =>
              `"${group.normalizedWord}" <- [${group.originalWords.map((w) => `${w.id}:${w.word}`).join(", ")}]`,
          )
          .join("; "),
    );
    this.name = "WordCollisionError";
  }
}

/** Words → words。衝突があれば WordCollisionError を投げる（fail-fast）。 */
export function transformWords(words: readonly WordRecord[]): WordRow[] {
  const collisions = detectWordCollisions(words);
  if (collisions.length > 0) throw new WordCollisionError(collisions);

  return words.map((word) => ({
    id: word.id,
    word: normalizeText(word.word),
    reading: word.reading,
    reading_sub_group: readingSubGroup(word.reading),
    created_by: null,
    created_at: word.createdAt,
    updated_at: word.updatedAt,
  }));
}

// ---- users ----

export type TransformUsersResult = {
  rows: UserRow[];
  defaultedMissingUserConfigs: string[];
  avatarClassifications: Map<string, AvatarClassification>;
};

/**
 * UserProfiles + UserConfigs → users。
 * UserConfigs 欠損時は appVersion/osVersion を 'unknown' 補完する。
 * profileImageUrl は avatar.ts で分類し、未知パターンなら fail-fast（呼び出し元に例外が伝播する）。
 * avatarKey は分類結果によらず常に `avatars/{uid}`（R2 コピー先が決定的キーのため）。
 */
export function transformUsers(
  profiles: readonly UserProfileRecord[],
  configsById: ReadonlyMap<string, UserConfigRecord>,
): TransformUsersResult {
  const defaultedMissingUserConfigs: string[] = [];
  const avatarClassifications = new Map<string, AvatarClassification>();

  const rows = profiles.map((profile) => {
    const config = configsById.get(profile.id);
    if (config === undefined) defaultedMissingUserConfigs.push(profile.id);

    const classification = classifyAvatarUrl(profile.profileImageUrl, profile.id);
    avatarClassifications.set(profile.id, classification);

    const row: UserRow = {
      id: profile.id,
      public_id: profile.publicId,
      name: profile.name,
      bio: profile.bio,
      avatar_key: `avatars/${encodeURIComponent(profile.id)}`,
      last_os_version: config?.osVersion ?? unknownVersionPlaceholder,
      last_app_version: config?.appVersion ?? unknownVersionPlaceholder,
      created_at: profile.createdAt,
      updated_at: profile.updatedAt,
      deleted_at: null,
    };
    return row;
  });

  return { rows, defaultedMissingUserConfigs, avatarClassifications };
}

// ---- definitions / likes / follows / user_mutes（FK 孤児は drop） ----

export type DroppedRecord = { id: string; reason: string };

export type TransformDefinitionsResult = {
  rows: DefinitionRow[];
  dropped: DroppedRecord[];
};

/** Definitions → definitions。word_id / author_id が存在しない行は drop する。 */
export function transformDefinitions(
  definitions: readonly DefinitionRecord[],
  validWordIds: ReadonlySet<string>,
  validUserIds: ReadonlySet<string>,
): TransformDefinitionsResult {
  const rows: DefinitionRow[] = [];
  const dropped: DroppedRecord[] = [];

  for (const definition of definitions) {
    if (!validWordIds.has(definition.wordId)) {
      dropped.push({ id: definition.id, reason: `orphan: word_id ${definition.wordId} not found` });
      continue;
    }
    if (!validUserIds.has(definition.authorId)) {
      dropped.push({
        id: definition.id,
        reason: `orphan: author_id ${definition.authorId} not found`,
      });
      continue;
    }
    rows.push({
      id: definition.id,
      word_id: definition.wordId,
      author_id: definition.authorId,
      body: definition.definition,
      status: definition.isPublic ? "public" : "private",
      finalized_at: definition.createdAt,
      is_edited: definition.isEdited ? 1 : 0,
      deleted_at: null,
      created_at: definition.createdAt,
      updated_at: definition.updatedAt,
    });
  }

  return { rows, dropped };
}

export type TransformLikesResult = { rows: LikeRow[]; dropped: DroppedRecord[] };

/** Likes → likes。definition_id / user_id が存在しない行は drop する。 */
export function transformLikes(
  likes: readonly LikeRecord[],
  validDefinitionIds: ReadonlySet<string>,
  validUserIds: ReadonlySet<string>,
): TransformLikesResult {
  const rows: LikeRow[] = [];
  const dropped: DroppedRecord[] = [];

  for (const like of likes) {
    if (!validDefinitionIds.has(like.definitionId)) {
      dropped.push({
        id: like.id,
        reason: `orphan: definition_id ${like.definitionId} not found`,
      });
      continue;
    }
    if (!validUserIds.has(like.userId)) {
      dropped.push({ id: like.id, reason: `orphan: user_id ${like.userId} not found` });
      continue;
    }
    rows.push({
      user_id: like.userId,
      definition_id: like.definitionId,
      created_at: like.createdAt,
    });
  }

  return { rows, dropped };
}

export type TransformFollowsResult = { rows: FollowRow[]; dropped: DroppedRecord[] };

/**
 * UserFollows → follows。follower/following が存在しない、または自己フォローの行は drop する。
 *
 * 旧 Firestore はフィールド名と実際の向きが逆だった:
 *   `UserFollowRepository.follow(currentUserId, targetUserId)` は
 *   `followerId = targetUserId`（される側）, `followingId = currentUserId`（する側）で保存していた。
 * 現行 D1 の `UserService.follow(uid, targetId)` は
 *   `follower_id = uid`（する側）, `following_id = targetId`（される側）。
 * そのため旧 `followingId → follower_id`, `followerId → following_id` と入れ替える。
 * 直コピーすると全フォロー関係が反転する。
 */
export function transformFollows(
  follows: readonly UserFollowRecord[],
  validUserIds: ReadonlySet<string>,
): TransformFollowsResult {
  const rows: FollowRow[] = [];
  const dropped: DroppedRecord[] = [];

  for (const follow of follows) {
    const followerId = follow.followingId; // D1 follower_id（フォローする側）
    const followingId = follow.followerId; // D1 following_id（フォローされる側）

    if (!validUserIds.has(followerId)) {
      dropped.push({
        id: follow.id,
        reason: `orphan: follower_id ${followerId} not found`,
      });
      continue;
    }
    if (!validUserIds.has(followingId)) {
      dropped.push({
        id: follow.id,
        reason: `orphan: following_id ${followingId} not found`,
      });
      continue;
    }
    if (followerId === followingId) {
      dropped.push({ id: follow.id, reason: "invalid: self follow" });
      continue;
    }
    rows.push({
      follower_id: followerId,
      following_id: followingId,
      created_at: follow.createdAt,
    });
  }

  return { rows, dropped };
}

export type TransformUserMutesResult = { rows: UserMuteRow[]; dropped: DroppedRecord[] };

/**
 * UserConfigs.mutedUserIdList → user_mutes 行。
 * createdAt は元データに存在しないため移行実行時刻を使う。
 * muter/muted が存在しない、または自己ミュートの行は drop する。
 */
export function transformUserMutes(
  configs: readonly UserConfigRecord[],
  validUserIds: ReadonlySet<string>,
  now: number,
): TransformUserMutesResult {
  const rows: UserMuteRow[] = [];
  const dropped: DroppedRecord[] = [];
  const seen = new Set<string>();

  for (const config of configs) {
    for (const mutedUserId of config.mutedUserIdList) {
      const recordId = `${config.id}:${mutedUserId}`;
      if (!validUserIds.has(config.id)) {
        dropped.push({ id: recordId, reason: `orphan: muter_id ${config.id} not found` });
        continue;
      }
      if (!validUserIds.has(mutedUserId)) {
        dropped.push({ id: recordId, reason: `orphan: muted_user_id ${mutedUserId} not found` });
        continue;
      }
      if (config.id === mutedUserId) {
        dropped.push({ id: recordId, reason: "invalid: self mute" });
        continue;
      }
      if (seen.has(recordId)) continue;
      seen.add(recordId);
      rows.push({ muter_id: config.id, muted_user_id: mutedUserId, created_at: now });
    }
  }

  return { rows, dropped };
}

// ---- レポート組み立て ----

export type BuildReportInput = {
  defaultedMissingUserConfigs: string[];
  droppedDefinitions: DroppedRecord[];
  droppedLikes: DroppedRecord[];
  droppedFollows: DroppedRecord[];
  droppedUserMutes: DroppedRecord[];
  avatarClassifications: ReadonlyMap<string, AvatarClassification>;
  now: () => Date;
};

export function buildMigrationReport(input: BuildReportInput): MigrationReport {
  let defaultCount = 0;
  let customCount = 0;
  for (const classification of input.avatarClassifications.values()) {
    if (classification.type === "default") defaultCount += 1;
    else customCount += 1;
  }

  return {
    generatedAt: input.now().toISOString(),
    droppedForeignKeyOrphans: [
      {
        table: "definitions",
        reason: "author_id/word_id が users/words に存在しない",
        count: input.droppedDefinitions.length,
        ids: input.droppedDefinitions.map((d) => d.id),
      },
      {
        table: "likes",
        reason: "user_id/definition_id が users/definitions に存在しない",
        count: input.droppedLikes.length,
        ids: input.droppedLikes.map((d) => d.id),
      },
      {
        table: "follows",
        reason: "follower_id/following_id が users に存在しない、または自己フォロー",
        count: input.droppedFollows.length,
        ids: input.droppedFollows.map((d) => d.id),
      },
      {
        table: "user_mutes",
        reason: "muter_id/muted_user_id が users に存在しない、または自己ミュート",
        count: input.droppedUserMutes.length,
        ids: input.droppedUserMutes.map((d) => d.id),
      },
    ],
    defaultedMissingUserConfigs: input.defaultedMissingUserConfigs.map((userId) => ({ userId })),
    avatarClassificationCounts: { default: defaultCount, custom: customCount },
  };
}
