#!/usr/bin/env bun
// Firestore 全コレクション + アバター画像を NDJSON スナップショットへ export する。
// ローカルから bun で実行する（Worker 上では実行しない。plan 決定事項 2）。
//
// 使い方:
//   bun run scripts/migration/export.ts \
//     --service-account ./secrets/prod-service-account.json \
//     --project-id everyone-teigi-prod \
//     --storage-bucket everyone-teigi-prod.appspot.com \
//     --out ./migration-snapshots/prod-2026-07-20
//
// サービスアカウントキーのパス・プロジェクト ID・Storage バケット名は CLI 引数または環境変数
// (FIREBASE_SERVICE_ACCOUNT_PATH / FIREBASE_PROJECT_ID / FIREBASE_STORAGE_BUCKET) で受け取る。
// バケット名は projectId から一意に導出できない（.appspot.com / .firebasestorage.app 等）ため
// 必須入力とし、未指定なら fail-fast する。
// キー・スナップショットはコミットしない（backend/.gitignore を参照）。

import { parseArgs } from "node:util";

import { cert, initializeApp } from "firebase-admin/app";
import { Timestamp, getFirestore, type Firestore } from "firebase-admin/firestore";
import { getStorage } from "firebase-admin/storage";

import { classifyAvatarUrl } from "./avatar";
import { writeNdjson } from "./ndjson";
import { firestoreCollectionNames, type AvatarManifest, type AvatarManifestEntry } from "./types";

type Args = {
  serviceAccount: string;
  projectId: string;
  out: string;
  storageBucket: string;
};

function parseCliArgs(argv: string[]): Args {
  const { values } = parseArgs({
    args: argv,
    options: {
      "service-account": { type: "string" },
      "project-id": { type: "string" },
      out: { type: "string" },
      "storage-bucket": { type: "string" },
    },
  });

  const serviceAccount = values["service-account"] ?? process.env["FIREBASE_SERVICE_ACCOUNT_PATH"];
  const projectId = values["project-id"] ?? process.env["FIREBASE_PROJECT_ID"];
  const out = values.out ?? process.env["MIGRATION_SNAPSHOT_DIR"];
  const storageBucket = values["storage-bucket"] ?? process.env["FIREBASE_STORAGE_BUCKET"];

  if (serviceAccount === undefined) {
    throw new Error(
      "--service-account またはFIREBASE_SERVICE_ACCOUNT_PATH でサービスアカウントキーのパスを指定してください",
    );
  }
  if (projectId === undefined) {
    throw new Error("--project-id またはFIREBASE_PROJECT_ID でプロジェクト ID を指定してください");
  }
  if (out === undefined) {
    throw new Error("--out またはMIGRATION_SNAPSHOT_DIR で出力先ディレクトリを指定してください");
  }
  if (storageBucket === undefined) {
    throw new Error(
      "--storage-bucket またはFIREBASE_STORAGE_BUCKET で Storage バケット名（例: everyone-teigi-prod.appspot.com）を指定してください",
    );
  }

  return {
    serviceAccount,
    projectId,
    out,
    storageBucket,
  };
}

/** Firestore ドキュメントの Timestamp フィールドを unix ミリ秒 INTEGER に再帰変換する。 */
function convertTimestamps(value: unknown): unknown {
  if (value instanceof Timestamp) return value.toMillis();
  if (Array.isArray(value)) return value.map(convertTimestamps);
  if (value !== null && typeof value === "object") {
    return Object.fromEntries(
      Object.entries(value as Record<string, unknown>).map(([key, v]) => [
        key,
        convertTimestamps(v),
      ]),
    );
  }
  return value;
}

async function exportCollection(db: Firestore, name: string, outDir: string): Promise<number> {
  const snapshot = await db.collection(name).get();
  const records = snapshot.docs.map((doc) => ({
    id: doc.id,
    ...(convertTimestamps(doc.data()) as Record<string, unknown>),
  }));
  await writeNdjson(`${outDir}/${name}.ndjson`, records);
  return records.length;
}

function sanitizeObjectPathForFilename(objectPath: string): string {
  return objectPath.replaceAll("/", "__");
}

async function exportAvatars(
  db: Firestore,
  bucketName: string,
  outDir: string,
): Promise<AvatarManifest> {
  const storage = getStorage();
  const bucket = storage.bucket(bucketName);

  const profilesSnapshot = await db.collection("UserProfiles").get();
  const entries: AvatarManifestEntry[] = [];
  const downloadedObjectPaths = new Set<string>();

  for (const doc of profilesSnapshot.docs) {
    const uid = doc.id;
    const profileImageUrl = doc.data()["profileImageUrl"] as string | undefined;
    if (profileImageUrl === undefined) {
      throw new Error(`UserProfiles/${uid} has no profileImageUrl`);
    }

    // 未知パターンは fail-fast（plan 決定事項 3）。
    const classification = classifyAvatarUrl(profileImageUrl, uid);
    const relativePath = `avatar-objects/${sanitizeObjectPathForFilename(classification.objectPath)}`;

    if (!downloadedObjectPaths.has(classification.objectPath)) {
      const [bytes] = await bucket.file(classification.objectPath).download();
      await Bun.write(`${outDir}/${relativePath}`, bytes);
      downloadedObjectPaths.add(classification.objectPath);
    }

    entries.push({
      uid,
      snapshotRelativePath: relativePath,
      classification:
        classification.type === "default"
          ? { type: "default", slug: classification.slug }
          : { type: "custom" },
    });
  }

  const manifest: AvatarManifest = { entries };
  await Bun.write(`${outDir}/avatar-manifest.json`, `${JSON.stringify(manifest, null, 2)}\n`);
  return manifest;
}

async function main(): Promise<void> {
  const args = parseCliArgs(process.argv.slice(2));

  initializeApp({
    credential: cert(args.serviceAccount),
    projectId: args.projectId,
    storageBucket: args.storageBucket,
  });
  const db = getFirestore();

  console.log(`export 開始: project=${args.projectId} out=${args.out}`);

  for (const collectionName of firestoreCollectionNames) {
    const count = await exportCollection(db, collectionName, args.out);
    console.log(`  ${collectionName}: ${count} 件`);
  }

  const manifest = await exportAvatars(db, args.storageBucket, args.out);
  const defaultCount = manifest.entries.filter((e) => e.classification.type === "default").length;
  const customCount = manifest.entries.filter((e) => e.classification.type === "custom").length;
  console.log(`  avatars: default ${defaultCount} 件 / custom ${customCount} 件`);

  console.log(`export 完了: ${args.out}`);
}

if (import.meta.main) {
  main().catch((error: unknown) => {
    console.error(error);
    process.exitCode = 1;
  });
}

export { convertTimestamps, exportAvatars, exportCollection, parseCliArgs };
