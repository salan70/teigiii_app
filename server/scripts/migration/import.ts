#!/usr/bin/env bun
// スナップショット → 変換 → SQL 生成 → D1 投入、R2 アバターコピーを行う。
// 冪等性は wipe-and-reload（生成 SQL の先頭で全行 DELETE してから INSERT）。
//
// 使い方:
//   bun run scripts/migration/import.ts \
//     --snapshot ./migration-snapshots/prod-2026-07-20 \
//     --d1-database teigiii-prod \
//     --r2-bucket teigiii-avatars-prod
//
// wrangler は child_process 経由で呼ぶ（server/ ディレクトリの wrangler.toml を使う）。

import { execFile } from "node:child_process";
import { mkdir } from "node:fs/promises";
import { dirname, resolve } from "node:path";
import { parseArgs, promisify } from "node:util";

import { readNdjson } from "./ndjson";
import { formatMigrationReportSummary, writeMigrationReport } from "./report";
import {
  buildMigrationReport,
  transformDefinitions,
  transformFollows,
  transformLikes,
  transformUserMutes,
  transformUsers,
  transformWords,
} from "./transform";
import { buildMigrationSql } from "./sql";
import type {
  AvatarManifest,
  DefinitionRecord,
  LikeRecord,
  UserConfigRecord,
  UserFollowRecord,
  UserProfileRecord,
  WordRecord,
} from "./types";

const execFileAsync = promisify(execFile);

type Args = {
  snapshot: string;
  d1Database: string;
  r2Bucket: string;
  sqlOut: string | undefined;
  reportOut: string | undefined;
  dryRun: boolean;
};

function parseCliArgs(argv: string[]): Args {
  const { values } = parseArgs({
    args: argv,
    options: {
      snapshot: { type: "string" },
      "d1-database": { type: "string" },
      "r2-bucket": { type: "string" },
      "sql-out": { type: "string" },
      "report-out": { type: "string" },
      "dry-run": { type: "boolean", default: false },
    },
  });

  const snapshot = values.snapshot ?? process.env["MIGRATION_SNAPSHOT_DIR"];
  const d1Database = values["d1-database"] ?? process.env["MIGRATION_D1_DATABASE"];
  const r2Bucket = values["r2-bucket"] ?? process.env["MIGRATION_R2_BUCKET"];

  if (snapshot === undefined)
    throw new Error("--snapshot でスナップショットディレクトリを指定してください");
  if (d1Database === undefined)
    throw new Error("--d1-database で投入先 D1 データベース名を指定してください");
  if (r2Bucket === undefined)
    throw new Error("--r2-bucket で投入先 R2 バケット名を指定してください");

  return {
    snapshot,
    d1Database,
    r2Bucket,
    sqlOut: values["sql-out"],
    reportOut: values["report-out"],
    dryRun: values["dry-run"] ?? false,
  };
}

async function loadSnapshot(snapshotDir: string) {
  const [words, definitions, likes, userProfiles, userConfigsList, userFollows] = await Promise.all(
    [
      readNdjson<WordRecord>(`${snapshotDir}/Words.ndjson`),
      readNdjson<DefinitionRecord>(`${snapshotDir}/Definitions.ndjson`),
      readNdjson<LikeRecord>(`${snapshotDir}/Likes.ndjson`),
      readNdjson<UserProfileRecord>(`${snapshotDir}/UserProfiles.ndjson`),
      readNdjson<UserConfigRecord>(`${snapshotDir}/UserConfigs.ndjson`),
      readNdjson<UserFollowRecord>(`${snapshotDir}/UserFollows.ndjson`),
    ],
  );
  const manifestText = await Bun.file(`${snapshotDir}/avatar-manifest.json`).text();
  const avatarManifest = JSON.parse(manifestText) as AvatarManifest;

  return { words, definitions, likes, userProfiles, userConfigsList, userFollows, avatarManifest };
}

async function runWrangler(args: string[], dryRun: boolean, cwd: string): Promise<void> {
  console.log(`$ wrangler ${args.join(" ")}`);
  if (dryRun) return;
  await execFileAsync("./node_modules/.bin/wrangler", args, { cwd, maxBuffer: 1024 * 1024 * 64 });
}

async function main(): Promise<void> {
  const args = parseCliArgs(process.argv.slice(2));
  const now = Date.now();
  const serverDir = resolve(import.meta.dirname, "../..");

  const snapshot = await loadSnapshot(args.snapshot);
  const configsById = new Map(snapshot.userConfigsList.map((c) => [c.id, c]));

  const wordRows = transformWords(snapshot.words);
  const validWordIds = new Set(wordRows.map((w) => w.id));

  const {
    rows: userRows,
    defaultedMissingUserConfigs,
    avatarClassifications,
  } = transformUsers(snapshot.userProfiles, configsById);
  const validUserIds = new Set(userRows.map((u) => u.id));

  const { rows: definitionRows, dropped: droppedDefinitions } = transformDefinitions(
    snapshot.definitions,
    validWordIds,
    validUserIds,
  );
  const validDefinitionIds = new Set(definitionRows.map((d) => d.id));

  const { rows: likeRows, dropped: droppedLikes } = transformLikes(
    snapshot.likes,
    validDefinitionIds,
    validUserIds,
  );
  const { rows: followRows, dropped: droppedFollows } = transformFollows(
    snapshot.userFollows,
    validUserIds,
  );
  const { rows: userMuteRows, dropped: droppedUserMutes } = transformUserMutes(
    snapshot.userConfigsList,
    validUserIds,
    now,
  );

  const report = buildMigrationReport({
    defaultedMissingUserConfigs,
    droppedDefinitions,
    droppedLikes,
    droppedFollows,
    droppedUserMutes,
    avatarClassifications,
    now: () => new Date(now),
  });

  const sql = buildMigrationSql({
    users: userRows,
    words: wordRows,
    definitions: definitionRows,
    likes: likeRows,
    follows: followRows,
    userMutes: userMuteRows,
  });

  const sqlOutPath = args.sqlOut ?? `${args.snapshot}/migration.sql`;
  await mkdir(dirname(sqlOutPath), { recursive: true });
  await Bun.write(sqlOutPath, sql);
  console.log(`SQL 生成: ${sqlOutPath}`);

  const reportOutPath = args.reportOut ?? `${args.snapshot}/migration-report.json`;
  await writeMigrationReport(reportOutPath, report);
  console.log(formatMigrationReportSummary(report));
  console.log(`レポート出力: ${reportOutPath}`);

  await runWrangler(
    ["d1", "execute", args.d1Database, "--remote", "--file", resolve(sqlOutPath), "-y"],
    args.dryRun,
    serverDir,
  );

  for (const entry of snapshot.avatarManifest.entries) {
    if (!validUserIds.has(entry.uid)) continue; // drop されたユーザー（実運用では発生しない想定）
    const filePath = resolve(args.snapshot, entry.snapshotRelativePath);
    const key = `avatars/${encodeURIComponent(entry.uid)}`;
    await runWrangler(
      ["r2", "object", "put", `${args.r2Bucket}/${key}`, "--file", filePath, "--remote", "-y"],
      args.dryRun,
      serverDir,
    );
  }

  console.log("import 完了");
}

if (import.meta.main) {
  main().catch((error: unknown) => {
    console.error(error);
    process.exitCode = 1;
  });
}

export { loadSnapshot, parseCliArgs };
