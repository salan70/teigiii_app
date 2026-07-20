// NDJSON（1 行 1 JSON）の読み書きユーティリティ。export / import が使う。
// verify は decision 5（変換ロジック・モジュールを import しない）に従い、
// 独自の最小実装を持つ（このファイルには依存しない）。

import { mkdir } from "node:fs/promises";
import { dirname } from "node:path";

export async function readNdjson<T>(path: string): Promise<T[]> {
  const file = Bun.file(path);
  if (!(await file.exists())) return [];
  const text = await file.text();
  return text
    .split("\n")
    .map((line) => line.trim())
    .filter((line) => line.length > 0)
    .map((line) => JSON.parse(line) as T);
}

export async function writeNdjson<T>(path: string, records: T[]): Promise<void> {
  await mkdir(dirname(path), { recursive: true });
  const body = records.map((record) => JSON.stringify(record)).join("\n");
  await Bun.write(path, body.length > 0 ? `${body}\n` : "");
}
