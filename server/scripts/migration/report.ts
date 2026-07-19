// 移行レポート（drop / 補完の件数と ID 一覧）のファイル出力。

import { mkdir } from "node:fs/promises";
import { dirname } from "node:path";

import type { MigrationReport } from "./types";

export async function writeMigrationReport(path: string, report: MigrationReport): Promise<void> {
  await mkdir(dirname(path), { recursive: true });
  await Bun.write(path, `${JSON.stringify(report, null, 2)}\n`);
}

export async function readMigrationReport(path: string): Promise<MigrationReport> {
  const text = await Bun.file(path).text();
  return JSON.parse(text) as MigrationReport;
}

export function formatMigrationReportSummary(report: MigrationReport): string {
  const lines: string[] = [`移行レポート（生成: ${report.generatedAt}）`];
  for (const entry of report.droppedForeignKeyOrphans) {
    lines.push(`  - ${entry.table}: ${entry.count} 件 drop（${entry.reason}）`);
  }
  lines.push(`  - UserConfigs 欠損補完: ${report.defaultedMissingUserConfigs.length} 件`);
  lines.push(
    `  - アバター分類: default ${report.avatarClassificationCounts.default} 件 / custom ${report.avatarClassificationCounts.custom} 件`,
  );
  return lines.join("\n");
}
