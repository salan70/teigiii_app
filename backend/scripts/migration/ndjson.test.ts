import { afterEach, describe, expect, test } from "bun:test";
import { mkdtemp, rm } from "node:fs/promises";
import { tmpdir } from "node:os";
import { join } from "node:path";

import { readNdjson, writeNdjson } from "./ndjson";

const tmpDirs: string[] = [];

afterEach(async () => {
  await Promise.all(tmpDirs.splice(0).map((dir) => rm(dir, { recursive: true, force: true })));
});

describe("writeNdjson / readNdjson", () => {
  test("書き込んだレコードをそのまま読み戻す", async () => {
    const dir = await mkdtemp(join(tmpdir(), "ndjson-test-"));
    tmpDirs.push(dir);
    const path = join(dir, "records.ndjson");
    const records = [
      { id: "1", word: "言葉" },
      { id: "2", word: "定義" },
    ];

    await writeNdjson(path, records);
    const result = await readNdjson<{ id: string; word: string }>(path);

    expect(result).toEqual(records);
  });

  test("空配列を書き込むと空のファイルになり、読み戻すと空配列になる", async () => {
    const dir = await mkdtemp(join(tmpdir(), "ndjson-test-"));
    tmpDirs.push(dir);
    const path = join(dir, "empty.ndjson");

    await writeNdjson(path, []);
    const result = await readNdjson<unknown>(path);

    expect(result).toEqual([]);
  });

  test("存在しないファイルを読むと空配列を返す", async () => {
    const dir = await mkdtemp(join(tmpdir(), "ndjson-test-"));
    tmpDirs.push(dir);
    const result = await readNdjson<unknown>(join(dir, "missing.ndjson"));
    expect(result).toEqual([]);
  });
});
