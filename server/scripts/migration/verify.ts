#!/usr/bin/env bun
// スナップショットから期待される D1 状態を独立に再計算し、実際の D1 / R2 と全件突合する。
//
// plan 決定事項 5: 「変換スクリプトから独立した検証器として書く。変換のロジック・
// モジュールを import すると変換バグが照合でも再現し検出できないため」。
// そのため transform.ts / avatar.ts / sql.ts / import.ts には一切依存しない
// （このファイルの中だけで再変換ロジックを完結させる）。
// readingSubGroup / normalizeText は移行専用ロジックではなくサーバー本体の
// 共有ロジック（独自の unit test を持つ）のため、ここでは import して使う。
//
// 使い方:
//   bun run scripts/migration/verify.ts \
//     --snapshot ./migration-snapshots/prod-2026-07-20 \
//     --d1-database teigiii-prod \
//     --r2-bucket teigiii-avatars-prod

import { execFile } from "node:child_process";
import { mkdtemp, readFile, stat } from "node:fs/promises";
import { tmpdir } from "node:os";
import { join, resolve } from "node:path";
import { parseArgs, promisify } from "node:util";

import { normalizeText } from "../../src/lib/normalize";
import { readingSubGroup } from "../../src/words/reading-sub-group";
import type {
  AvatarManifest,
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

const execFileAsync = promisify(execFile);

// ---- スナップショット読み込み（独自の最小実装。ndjson.ts には依存しない） ----

async function readNdjsonIndependently<T>(path: string): Promise<T[]> {
  const file = Bun.file(path);
  if (!(await file.exists())) return [];
  const text = await file.text();
  return text
    .split("\n")
    .map((line) => line.trim())
    .filter((line) => line.length > 0)
    .map((line) => JSON.parse(line) as T);
}

export type Snapshot = {
  words: WordRecord[];
  definitions: DefinitionRecord[];
  likes: LikeRecord[];
  userProfiles: UserProfileRecord[];
  userConfigs: UserConfigRecord[];
  userFollows: UserFollowRecord[];
  avatarManifest: AvatarManifest;
};

export async function loadSnapshotIndependently(snapshotDir: string): Promise<Snapshot> {
  const [words, definitions, likes, userProfiles, userConfigs, userFollows] = await Promise.all([
    readNdjsonIndependently<WordRecord>(`${snapshotDir}/Words.ndjson`),
    readNdjsonIndependently<DefinitionRecord>(`${snapshotDir}/Definitions.ndjson`),
    readNdjsonIndependently<LikeRecord>(`${snapshotDir}/Likes.ndjson`),
    readNdjsonIndependently<UserProfileRecord>(`${snapshotDir}/UserProfiles.ndjson`),
    readNdjsonIndependently<UserConfigRecord>(`${snapshotDir}/UserConfigs.ndjson`),
    readNdjsonIndependently<UserFollowRecord>(`${snapshotDir}/UserFollows.ndjson`),
  ]);
  const avatarManifest = JSON.parse(
    await readFile(`${snapshotDir}/avatar-manifest.json`, "utf8"),
  ) as AvatarManifest;
  return { words, definitions, likes, userProfiles, userConfigs, userFollows, avatarManifest };
}

// ---- 独自の期待値再計算（transform.ts / avatar.ts とは別実装） ----

const defaultAvatarObjectPathPattern =
  /^common\/default_icon_image\/(ghost_writer|animal_chara_radio_penguin|animal_chara_mogura_hakase)\.png$/;
const firebaseStorageUrlPattern =
  /^https:\/\/firebasestorage\.googleapis\.com\/v0\/b\/[^/]+\/o\/([^?]+)/;

export function reclassifyAvatarUrl(
  profileImageUrl: string,
  uid: string,
): { type: "default" } | { type: "custom" } {
  const match = firebaseStorageUrlPattern.exec(profileImageUrl);
  if (match?.[1] === undefined) {
    throw new Error(`verify: unrecognized profileImageUrl for uid=${uid}: ${profileImageUrl}`);
  }
  const objectPath = decodeURIComponent(match[1]);
  if (defaultAvatarObjectPathPattern.test(objectPath)) return { type: "default" };
  if (objectPath === `users/${uid}/profile_image.png`) return { type: "custom" };
  throw new Error(`verify: unknown avatar object path for uid=${uid}: ${objectPath}`);
}

export type ExpectedState = {
  users: UserRow[];
  words: WordRow[];
  definitions: DefinitionRow[];
  likes: LikeRow[];
  follows: FollowRow[];
  userMutes: UserMuteRow[];
  droppedCounts: {
    definitions: number;
    likes: number;
    follows: number;
    userMutes: number;
  };
  defaultedUserConfigCount: number;
};

/** スナップショットから D1 の期待状態を再計算する（transform.ts を経由しない独自実装）。 */
export function recomputeExpectedState(
  snapshot: Snapshot,
  migrationTimestamp: number,
): ExpectedState {
  const words: WordRow[] = snapshot.words.map((word) => ({
    id: word.id,
    word: normalizeText(word.word),
    reading: word.reading,
    reading_sub_group: readingSubGroup(word.reading),
    created_by: null,
    created_at: word.createdAt,
    updated_at: word.updatedAt,
  }));
  const wordIds = new Set(words.map((w) => w.id));
  if (wordIds.size !== words.length) {
    throw new Error("verify: normalized word collisions found while recomputing expected state");
  }

  const configById = new Map(snapshot.userConfigs.map((c) => [c.id, c]));
  let defaultedUserConfigCount = 0;
  const users: UserRow[] = snapshot.userProfiles.map((profile) => {
    reclassifyAvatarUrl(profile.profileImageUrl, profile.id); // fail-fast on unknown pattern
    const config = configById.get(profile.id);
    if (config === undefined) defaultedUserConfigCount += 1;
    return {
      id: profile.id,
      public_id: profile.publicId,
      name: profile.name,
      bio: profile.bio,
      avatar_key: `avatars/${encodeURIComponent(profile.id)}`,
      last_os_version: config?.osVersion ?? "unknown",
      last_app_version: config?.appVersion ?? "unknown",
      created_at: profile.createdAt,
      updated_at: profile.updatedAt,
      deleted_at: null,
    };
  });
  const userIds = new Set(users.map((u) => u.id));

  const definitions: DefinitionRow[] = [];
  let droppedDefinitions = 0;
  for (const definition of snapshot.definitions) {
    if (!wordIds.has(definition.wordId) || !userIds.has(definition.authorId)) {
      droppedDefinitions += 1;
      continue;
    }
    definitions.push({
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
  const definitionIds = new Set(definitions.map((d) => d.id));

  const likes: LikeRow[] = [];
  let droppedLikes = 0;
  for (const like of snapshot.likes) {
    if (!definitionIds.has(like.definitionId) || !userIds.has(like.userId)) {
      droppedLikes += 1;
      continue;
    }
    likes.push({
      user_id: like.userId,
      definition_id: like.definitionId,
      created_at: like.createdAt,
    });
  }

  const follows: FollowRow[] = [];
  let droppedFollows = 0;
  for (const follow of snapshot.userFollows) {
    // 旧 Firestore はフィールド名と向きが逆（followingId=する側, followerId=される側）。
    // 現行 D1 の向き（follower_id=する側, following_id=される側）へ入れ替える。
    // transform.ts とは独立に再実装する（決定事項 5）が、期待値は正しい向きで組む。
    const followerId = follow.followingId;
    const followingId = follow.followerId;
    const valid = userIds.has(followerId) && userIds.has(followingId) && followerId !== followingId;
    if (!valid) {
      droppedFollows += 1;
      continue;
    }
    follows.push({
      follower_id: followerId,
      following_id: followingId,
      created_at: follow.createdAt,
    });
  }

  const userMutes: UserMuteRow[] = [];
  let droppedUserMutes = 0;
  const seenMutes = new Set<string>();
  for (const config of snapshot.userConfigs) {
    for (const mutedUserId of config.mutedUserIdList) {
      const valid = userIds.has(config.id) && userIds.has(mutedUserId) && config.id !== mutedUserId;
      if (!valid) {
        droppedUserMutes += 1;
        continue;
      }
      const key = `${config.id}:${mutedUserId}`;
      if (seenMutes.has(key)) continue;
      seenMutes.add(key);
      userMutes.push({
        muter_id: config.id,
        muted_user_id: mutedUserId,
        created_at: migrationTimestamp,
      });
    }
  }

  return {
    users,
    words,
    definitions,
    likes,
    follows,
    userMutes,
    droppedCounts: {
      definitions: droppedDefinitions,
      likes: droppedLikes,
      follows: droppedFollows,
      userMutes: droppedUserMutes,
    },
    defaultedUserConfigCount,
  };
}

// ---- D1 実データ取得・突合 ----

export type D1QueryResult = { results: Record<string, unknown>[] };

/** `wrangler d1 execute --json` の出力（クエリ結果の配列）をパースする。 */
export function parseD1JsonOutput(raw: string): Record<string, unknown>[] {
  const parsed = JSON.parse(raw) as unknown;
  const resultsArray = Array.isArray(parsed) ? parsed : [parsed];
  const first = resultsArray[0] as D1QueryResult | undefined;
  return first?.results ?? [];
}

async function queryD1(
  database: string,
  sql: string,
  serverDir: string,
): Promise<Record<string, unknown>[]> {
  const { stdout } = await execFileAsync(
    "./node_modules/.bin/wrangler",
    ["d1", "execute", database, "--remote", "--json", "--command", sql],
    { cwd: serverDir, maxBuffer: 1024 * 1024 * 256 },
  );
  return parseD1JsonOutput(stdout);
}

export type RowDiff<T> = {
  table: string;
  missingInActual: T[];
  unexpectedInActual: T[];
  mismatched: { key: string; expected: T; actual: T }[];
};

function diffRows<T extends Record<string, unknown>>(
  table: string,
  expected: T[],
  actual: T[],
  keyOf: (row: T) => string,
): RowDiff<T> {
  const expectedByKey = new Map(expected.map((row) => [keyOf(row), row]));
  const actualByKey = new Map(actual.map((row) => [keyOf(row), row]));

  const missingInActual: T[] = [];
  const mismatched: { key: string; expected: T; actual: T }[] = [];
  for (const [key, expectedRow] of expectedByKey) {
    const actualRow = actualByKey.get(key);
    if (actualRow === undefined) {
      missingInActual.push(expectedRow);
      continue;
    }
    if (JSON.stringify(sortedEntries(expectedRow)) !== JSON.stringify(sortedEntries(actualRow))) {
      mismatched.push({ key, expected: expectedRow, actual: actualRow });
    }
  }
  const unexpectedInActual = [...actualByKey.entries()]
    .filter(([key]) => !expectedByKey.has(key))
    .map(([, row]) => row);

  return { table, missingInActual, unexpectedInActual, mismatched };
}

function sortedEntries(row: Record<string, unknown>): [string, unknown][] {
  return Object.entries(row).toSorted(([a], [b]) => a.localeCompare(b));
}

function normalizeD1Row<T extends Record<string, unknown>>(row: Record<string, unknown>): T {
  // D1 の --json 出力は boolean 相当の列も 0/1 の number で返る。既に number のため変換不要。
  return row as T;
}

// ---- CLI ----

type Args = {
  snapshot: string;
  d1Database: string;
  r2Bucket: string;
  report: string | undefined;
};

function parseCliArgs(argv: string[]): Args {
  const { values } = parseArgs({
    args: argv,
    options: {
      snapshot: { type: "string" },
      "d1-database": { type: "string" },
      "r2-bucket": { type: "string" },
      report: { type: "string" },
    },
  });
  const snapshot = values.snapshot ?? process.env["MIGRATION_SNAPSHOT_DIR"];
  const d1Database = values["d1-database"] ?? process.env["MIGRATION_D1_DATABASE"];
  const r2Bucket = values["r2-bucket"] ?? process.env["MIGRATION_R2_BUCKET"];
  if (snapshot === undefined)
    throw new Error("--snapshot でスナップショットディレクトリを指定してください");
  if (d1Database === undefined)
    throw new Error("--d1-database で検証対象 D1 データベース名を指定してください");
  if (r2Bucket === undefined)
    throw new Error("--r2-bucket で検証対象 R2 バケット名を指定してください");
  return { snapshot, d1Database, r2Bucket, report: values.report };
}

async function verifyR2Avatars(
  expected: ExpectedState,
  snapshot: Snapshot,
  snapshotDir: string,
  bucket: string,
  serverDir: string,
): Promise<{ uid: string; problem: string }[]> {
  const manifestByUid = new Map(snapshot.avatarManifest.entries.map((e) => [e.uid, e]));
  const problems: { uid: string; problem: string }[] = [];
  const tmpDir = await mkdtemp(join(tmpdir(), "migration-verify-"));

  for (const user of expected.users) {
    if (user.avatar_key === null) continue;
    const manifestEntry = manifestByUid.get(user.id);
    if (manifestEntry === undefined) {
      problems.push({ uid: user.id, problem: "avatar-manifest.json にエントリがない" });
      continue;
    }
    const expectedFilePath = resolve(snapshotDir, manifestEntry.snapshotRelativePath);
    let expectedSize: number;
    try {
      expectedSize = (await stat(expectedFilePath)).size;
    } catch {
      problems.push({
        uid: user.id,
        problem: `期待するアバターファイルが見つからない: ${expectedFilePath}`,
      });
      continue;
    }

    const downloadPath = join(tmpDir, `${encodeURIComponent(user.id)}.bin`);
    try {
      await execFileAsync(
        "./node_modules/.bin/wrangler",
        [
          "r2",
          "object",
          "get",
          `${bucket}/${user.avatar_key}`,
          "--file",
          downloadPath,
          "--remote",
          "-y",
        ],
        { cwd: serverDir, maxBuffer: 1024 * 1024 * 64 },
      );
    } catch {
      problems.push({ uid: user.id, problem: `R2 オブジェクトが取得できない: ${user.avatar_key}` });
      continue;
    }
    const actualSize = (await stat(downloadPath)).size;
    if (actualSize !== expectedSize) {
      problems.push({
        uid: user.id,
        problem: `バイトサイズ不一致: expected=${expectedSize} actual=${actualSize}`,
      });
    }
  }

  return problems;
}

async function main(): Promise<void> {
  const args = parseCliArgs(process.argv.slice(2));
  const serverDir = resolve(import.meta.dirname, "../..");
  const snapshotDir = resolve(args.snapshot);

  const snapshot = await loadSnapshotIndependently(snapshotDir);
  const reportPath = args.report ?? `${snapshotDir}/migration-report.json`;
  const report = JSON.parse(await readFile(reportPath, "utf8")) as MigrationReport;
  const migrationTimestamp = new Date(report.generatedAt).getTime();

  const expected = recomputeExpectedState(snapshot, migrationTimestamp);

  const [actualUsers, actualWords, actualDefinitions, actualLikes, actualFollows, actualUserMutes] =
    await Promise.all([
      queryD1(args.d1Database, "select * from users", serverDir),
      queryD1(args.d1Database, "select * from words", serverDir),
      queryD1(args.d1Database, "select * from definitions", serverDir),
      queryD1(args.d1Database, "select * from likes", serverDir),
      queryD1(args.d1Database, "select * from follows", serverDir),
      queryD1(args.d1Database, "select * from user_mutes", serverDir),
    ]);

  const diffs = [
    diffRows("users", expected.users, actualUsers.map(normalizeD1Row<UserRow>), (r) => r.id),
    diffRows("words", expected.words, actualWords.map(normalizeD1Row<WordRow>), (r) => r.id),
    diffRows(
      "definitions",
      expected.definitions,
      actualDefinitions.map(normalizeD1Row<DefinitionRow>),
      (r) => r.id,
    ),
    diffRows(
      "likes",
      expected.likes,
      actualLikes.map(normalizeD1Row<LikeRow>),
      (r) => `${r.user_id}:${r.definition_id}`,
    ),
    diffRows(
      "follows",
      expected.follows,
      actualFollows.map(normalizeD1Row<FollowRow>),
      (r) => `${r.follower_id}:${r.following_id}`,
    ),
    diffRows(
      "user_mutes",
      expected.userMutes,
      actualUserMutes.map(normalizeD1Row<UserMuteRow>),
      (r) => `${r.muter_id}:${r.muted_user_id}`,
    ),
  ];

  let hasProblem = false;
  console.log("=== 全件突合 ===");
  for (const diff of diffs) {
    const ok =
      diff.missingInActual.length === 0 &&
      diff.unexpectedInActual.length === 0 &&
      diff.mismatched.length === 0;
    console.log(
      `${diff.table}: ${ok ? "OK" : "NG"}（missing=${diff.missingInActual.length}, unexpected=${diff.unexpectedInActual.length}, mismatched=${diff.mismatched.length}）`,
    );
    if (!ok) {
      hasProblem = true;
      console.log(JSON.stringify(diff, null, 2));
    }
  }

  console.log("=== 移行レポートとの整合 ===");
  const reportDroppedByTable = Object.fromEntries(
    report.droppedForeignKeyOrphans.map((e) => [e.table, e.count]),
  );
  const reportChecks: [string, number, number][] = [
    ["definitions", expected.droppedCounts.definitions, reportDroppedByTable["definitions"] ?? -1],
    ["likes", expected.droppedCounts.likes, reportDroppedByTable["likes"] ?? -1],
    ["follows", expected.droppedCounts.follows, reportDroppedByTable["follows"] ?? -1],
    ["user_mutes", expected.droppedCounts.userMutes, reportDroppedByTable["user_mutes"] ?? -1],
  ];
  for (const [table, recomputed, reported] of reportChecks) {
    const ok = recomputed === reported;
    console.log(`  ${table}: 再計算=${recomputed} レポート=${reported} ${ok ? "OK" : "NG"}`);
    if (!ok) hasProblem = true;
  }
  const defaultedOk =
    expected.defaultedUserConfigCount === report.defaultedMissingUserConfigs.length;
  console.log(
    `  defaultedMissingUserConfigs: 再計算=${expected.defaultedUserConfigCount} レポート=${report.defaultedMissingUserConfigs.length} ${defaultedOk ? "OK" : "NG"}`,
  );
  if (!defaultedOk) hasProblem = true;

  console.log("=== R2 アバター突合 ===");
  const avatarProblems = await verifyR2Avatars(
    expected,
    snapshot,
    snapshotDir,
    args.r2Bucket,
    serverDir,
  );
  if (avatarProblems.length === 0) {
    console.log(`  OK（${expected.users.filter((u) => u.avatar_key !== null).length} 件）`);
  } else {
    hasProblem = true;
    console.log(`  NG（${avatarProblems.length} 件）`);
    console.log(JSON.stringify(avatarProblems, null, 2));
  }

  if (hasProblem) {
    console.error("検証 NG");
    process.exitCode = 1;
  } else {
    console.log("検証 OK: 全件突合、意図的差分の整合、R2 アバターすべて一致");
  }
}

if (import.meta.main) {
  main().catch((error: unknown) => {
    console.error(error);
    process.exitCode = 1;
  });
}

export { diffRows, parseCliArgs };
