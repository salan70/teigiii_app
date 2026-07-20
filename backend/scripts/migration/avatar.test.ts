import { describe, expect, test } from "bun:test";

import { classifyAvatarUrl, parseFirebaseStorageObjectPath } from "./avatar";

const uid = "user-abc123";

function defaultUrl(bucket: string, filename: string): string {
  return `https://firebasestorage.googleapis.com/v0/b/${bucket}/o/common%2Fdefault_icon_image%2F${filename}?alt=media&token=dummy-token`;
}

function customUrl(bucket: string, targetUid: string): string {
  return `https://firebasestorage.googleapis.com/v0/b/${bucket}/o/users%2F${targetUid}%2Fprofile_image.png?alt=media&token=dummy-token`;
}

describe("parseFirebaseStorageObjectPath", () => {
  test("Firebase Storage の URL からオブジェクトパスを decode して取り出す", () => {
    expect(
      parseFirebaseStorageObjectPath(
        defaultUrl("everyone-teigi-prod.appspot.com", "ghost_writer.png"),
      ),
    ).toBe("common/default_icon_image/ghost_writer.png");
  });

  test("Firebase Storage の URL でなければ null を返す", () => {
    expect(
      parseFirebaseStorageObjectPath("https://img.altema.jp/pokemonsv/pokemon/icon/613.png"),
    ).toBeNull();
  });
});

describe("classifyAvatarUrl", () => {
  test("prod のデフォルトアイコン 3 種を default として分類する", () => {
    const bucket = "everyone-teigi-prod.appspot.com";
    expect(classifyAvatarUrl(defaultUrl(bucket, "ghost_writer.png"), uid)).toEqual({
      type: "default",
      slug: "ghost_writer",
      objectPath: "common/default_icon_image/ghost_writer.png",
    });
    expect(classifyAvatarUrl(defaultUrl(bucket, "animal_chara_radio_penguin.png"), uid).type).toBe(
      "default",
    );
    expect(classifyAvatarUrl(defaultUrl(bucket, "animal_chara_mogura_hakase.png"), uid).type).toBe(
      "default",
    );
  });

  test("dev のデフォルトアイコンも同じオブジェクトパスパターンで default として分類する", () => {
    const bucket = "everyone-teigi-dev.appspot.com";
    expect(classifyAvatarUrl(defaultUrl(bucket, "animal_chara_mogura_hakase.png"), uid).type).toBe(
      "default",
    );
  });

  test("users/{uid}/profile_image.png を custom として分類する", () => {
    const result = classifyAvatarUrl(customUrl("everyone-teigi-prod.appspot.com", uid), uid);
    expect(result).toEqual({
      type: "custom",
      objectPath: `users/${uid}/profile_image.png`,
    });
  });

  test("別ユーザーの custom 画像パスは uid が一致しないため fail-fast する", () => {
    expect(() =>
      classifyAvatarUrl(customUrl("everyone-teigi-prod.appspot.com", "other-uid"), uid),
    ).toThrow(/does not match a known pattern/);
  });

  test("Firebase Storage 形式でない URL は fail-fast する", () => {
    expect(() =>
      classifyAvatarUrl("https://img.altema.jp/pokemonsv/pokemon/icon/613.png", uid),
    ).toThrow(/unrecognized_url_format/);
  });

  test("Firebase Storage だが既知パターン外のパスは fail-fast する", () => {
    const url = defaultUrl("everyone-teigi-prod.appspot.com", "unknown_icon.png");
    expect(() => classifyAvatarUrl(url, uid)).toThrow(/unknown_object_path/);
  });
});
