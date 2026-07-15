import { describe, expect, test } from "bun:test";

import { uuidv7 } from "../../src/lib/uuidv7";

describe("uuidv7", () => {
  test("RFC 9562 の UUIDv7 形式（version 7・variant 10）で生成する", () => {
    const value = uuidv7();

    expect(value).toMatch(/^[0-9a-f]{8}-[0-9a-f]{4}-7[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/);
  });

  test("先頭 48 ビットに unix ミリ秒タイムスタンプを埋め込む", () => {
    const timestamp = 0x0189_6544_3210;

    const value = uuidv7(timestamp);

    expect(value.slice(0, 8) + value.slice(9, 13)).toBe("018965443210");
  });

  test("同一タイムスタンプでも呼び出しごとに異なる値を生成する", () => {
    const timestamp = Date.now();
    const values = new Set(Array.from({ length: 1000 }, () => uuidv7(timestamp)));

    expect(values.size).toBe(1000);
  });

  test("タイムスタンプが進むと文字列順も進む", () => {
    const earlier = uuidv7(1000);
    const later = uuidv7(2000);

    expect(earlier < later).toBe(true);
  });
});
