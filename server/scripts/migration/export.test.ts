import { describe, expect, test } from "bun:test";
import { Timestamp } from "firebase-admin/firestore";

import { convertTimestamps, parseCliArgs } from "./export";

describe("convertTimestamps", () => {
  test("Timestamp を unix ミリ秒の number に変換する", () => {
    const timestamp = Timestamp.fromMillis(1700000000000);
    expect(convertTimestamps(timestamp)).toBe(1700000000000);
  });

  test("ネストしたオブジェクト内の Timestamp も再帰的に変換する", () => {
    const input = {
      createdAt: Timestamp.fromMillis(1000),
      nested: { updatedAt: Timestamp.fromMillis(2000) },
    };
    expect(convertTimestamps(input)).toEqual({ createdAt: 1000, nested: { updatedAt: 2000 } });
  });

  test("配列内の Timestamp も変換する", () => {
    const input = [Timestamp.fromMillis(1000), "plain"];
    expect(convertTimestamps(input)).toEqual([1000, "plain"]);
  });

  test("Timestamp でない値はそのまま返す", () => {
    expect(convertTimestamps({ word: "言葉", count: 3, flag: true, empty: null })).toEqual({
      word: "言葉",
      count: 3,
      flag: true,
      empty: null,
    });
  });
});

describe("parseCliArgs", () => {
  const requiredArgs = [
    "--service-account",
    "./key.json",
    "--project-id",
    "everyone-teigi-prod",
    "--out",
    "./snapshot",
    "--storage-bucket",
    "everyone-teigi-prod.appspot.com",
  ];

  test("CLI 引数から必須パラメータを取り出す", () => {
    const args = parseCliArgs(requiredArgs);
    expect(args).toEqual({
      serviceAccount: "./key.json",
      projectId: "everyone-teigi-prod",
      out: "./snapshot",
      storageBucket: "everyone-teigi-prod.appspot.com",
    });
  });

  test("service-account が欠けている場合はエラーになる", () => {
    expect(() =>
      parseCliArgs([
        "--project-id",
        "everyone-teigi-prod",
        "--out",
        "./snapshot",
        "--storage-bucket",
        "everyone-teigi-prod.appspot.com",
      ]),
    ).toThrow(/service-account/);
  });

  test("storage-bucket が欠けている場合はエラーになる", () => {
    expect(() =>
      parseCliArgs(["--service-account", "./key.json", "--project-id", "p", "--out", "./snapshot"]),
    ).toThrow(/storage-bucket/);
  });
});
