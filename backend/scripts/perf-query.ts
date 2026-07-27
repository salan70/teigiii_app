#!/usr/bin/env bun
/**
 * just perf-query の実体。手動調査用の raw SQL 実行。
 * AI の主導線は just perf-report を使うこと。
 */

import { executeTelemetrySql } from "./perf/execute";

async function main(): Promise<void> {
  const sql = Bun.argv.slice(2).join(" ").trim();
  if (!sql) {
    throw new Error("Usage: bun run scripts/perf-query.ts '<SQL>'");
  }
  const rows = await executeTelemetrySql(sql);
  process.stdout.write(`${JSON.stringify(rows, null, 2)}\n`);
}

main().catch((error: unknown) => {
  const message = error instanceof Error ? error.message : String(error);
  console.error(message);
  process.exit(1);
});
