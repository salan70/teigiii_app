import { describe, expect, test } from "bun:test";

import {
  buildMigrationReport,
  detectWordCollisions,
  transformDefinitions,
  transformFollows,
  transformLikes,
  transformUserMutes,
  transformUsers,
  transformWords,
  WordCollisionError,
} from "./transform";
import type {
  DefinitionRecord,
  LikeRecord,
  UserConfigRecord,
  UserFollowRecord,
  UserProfileRecord,
  WordRecord,
} from "./types";

const defaultIconUrl =
  "https://firebasestorage.googleapis.com/v0/b/everyone-teigi-prod.appspot.com/o/common%2Fdefault_icon_image%2Fghost_writer.png?alt=media&token=dummy";

function customIconUrl(uid: string): string {
  return `https://firebasestorage.googleapis.com/v0/b/everyone-teigi-prod.appspot.com/o/users%2F${uid}%2Fprofile_image.png?alt=media&token=dummy`;
}

describe("detectWordCollisions / transformWords", () => {
  test("衝突がなければそのまま変換する", () => {
    const words: WordRecord[] = [
      { id: "w1", word: "言葉", reading: "ことば", createdAt: 1, updatedAt: 1 },
      { id: "w2", word: "定義", reading: "ていぎ", createdAt: 2, updatedAt: 2 },
    ];
    expect(detectWordCollisions(words)).toEqual([]);
    const rows = transformWords(words);
    expect(rows).toHaveLength(2);
    expect(rows[0]).toMatchObject({
      id: "w1",
      word: "言葉",
      reading_sub_group: "こ",
      created_by: null,
    });
  });

  test("trim + NFC 正規化後に同一になる語を衝突として検出する", () => {
    const combiningVoicedMark = String.fromCharCode(0x3099);
    const words: WordRecord[] = [
      { id: "w1", word: "がっこう", createdAt: 1, updatedAt: 1, reading: "がっこう" },
      {
        id: "w2",
        word: `  か${combiningVoicedMark}っこう `,
        createdAt: 2,
        updatedAt: 2,
        reading: "がっこう",
      },
    ];
    const collisions = detectWordCollisions(words);
    expect(collisions).toHaveLength(1);
    expect(collisions[0]!.normalizedWord).toBe("がっこう");
    expect(collisions[0]!.originalWords.map((w) => w.id).toSorted()).toEqual(["w1", "w2"]);
  });

  test("衝突がある場合 transformWords は WordCollisionError を投げる（fail-fast）", () => {
    const words: WordRecord[] = [
      { id: "w1", word: "同じ", createdAt: 1, updatedAt: 1, reading: "おなじ" },
      { id: "w2", word: "同じ", createdAt: 2, updatedAt: 2, reading: "おなじ" },
    ];
    expect(() => transformWords(words)).toThrow(WordCollisionError);
  });

  test("readingSubGroup をサーバーと同じ関数で再計算する", () => {
    const words: WordRecord[] = [
      { id: "w1", word: "アイス", reading: "アイス", createdAt: 1, updatedAt: 1 },
    ];
    expect(transformWords(words)[0]!.reading_sub_group).toBe("あ");
  });
});

describe("transformUsers", () => {
  test("UserConfigs がある場合はその appVersion/osVersion を使う", () => {
    const profiles: UserProfileRecord[] = [
      {
        id: "u1",
        publicId: "000000001",
        name: "太郎",
        bio: "bio",
        profileImageUrl: defaultIconUrl,
        createdAt: 1,
        updatedAt: 1,
      },
    ];
    const configs = new Map<string, UserConfigRecord>([
      [
        "u1",
        {
          id: "u1",
          appVersion: "1.2.3",
          osVersion: "iOS 18",
          mutedUserIdList: [],
          createdAt: 1,
          updatedAt: 1,
        },
      ],
    ]);
    const result = transformUsers(profiles, configs);
    expect(result.rows[0]).toMatchObject({
      id: "u1",
      last_app_version: "1.2.3",
      last_os_version: "iOS 18",
      avatar_key: "avatars/u1",
    });
    expect(result.defaultedMissingUserConfigs).toEqual([]);
  });

  test("UserConfigs が欠損している場合は 'unknown' を補完してレポートに記録する", () => {
    const profiles: UserProfileRecord[] = [
      {
        id: "u1",
        publicId: "000000001",
        name: "太郎",
        bio: "bio",
        profileImageUrl: defaultIconUrl,
        createdAt: 1,
        updatedAt: 1,
      },
    ];
    const result = transformUsers(profiles, new Map());
    expect(result.rows[0]).toMatchObject({
      last_app_version: "unknown",
      last_os_version: "unknown",
    });
    expect(result.defaultedMissingUserConfigs).toEqual(["u1"]);
  });

  test("デフォルトアイコンとカスタム画像の両方を分類し avatarKey は常に avatars/{uid}", () => {
    const profiles: UserProfileRecord[] = [
      {
        id: "u1",
        publicId: "000000001",
        name: "太郎",
        bio: "",
        profileImageUrl: defaultIconUrl,
        createdAt: 1,
        updatedAt: 1,
      },
      {
        id: "u2",
        publicId: "000000002",
        name: "花子",
        bio: "",
        profileImageUrl: customIconUrl("u2"),
        createdAt: 1,
        updatedAt: 1,
      },
    ];
    const result = transformUsers(profiles, new Map());
    expect(result.rows[0]!.avatar_key).toBe("avatars/u1");
    expect(result.rows[1]!.avatar_key).toBe("avatars/u2");
    expect(result.avatarClassifications.get("u1")!.type).toBe("default");
    expect(result.avatarClassifications.get("u2")!.type).toBe("custom");
  });

  test("profileImageUrl が既知パターン外なら fail-fast する", () => {
    const profiles: UserProfileRecord[] = [
      {
        id: "u1",
        publicId: "000000001",
        name: "太郎",
        bio: "",
        profileImageUrl: "https://img.altema.jp/pokemonsv/pokemon/icon/613.png",
        createdAt: 1,
        updatedAt: 1,
      },
    ];
    expect(() => transformUsers(profiles, new Map())).toThrow();
  });
});

describe("transformDefinitions", () => {
  const base: DefinitionRecord = {
    id: "d1",
    wordId: "w1",
    authorId: "u1",
    definition: "本文",
    isPublic: true,
    isEdited: false,
    createdAt: 10,
    updatedAt: 20,
  };

  test("word/author が有効なら status と finalized_at を変換する", () => {
    const result = transformDefinitions([base], new Set(["w1"]), new Set(["u1"]));
    expect(result.dropped).toEqual([]);
    expect(result.rows[0]).toMatchObject({
      id: "d1",
      status: "public",
      finalized_at: 10,
      is_edited: 0,
      deleted_at: null,
    });
  });

  test("isPublic=false は status=private になる", () => {
    const result = transformDefinitions(
      [{ ...base, isPublic: false }],
      new Set(["w1"]),
      new Set(["u1"]),
    );
    expect(result.rows[0]!.status).toBe("private");
  });

  test("word_id が存在しない行は drop してレポートに記録する", () => {
    const result = transformDefinitions([base], new Set(), new Set(["u1"]));
    expect(result.rows).toEqual([]);
    expect(result.dropped).toEqual([{ id: "d1", reason: "orphan: word_id w1 not found" }]);
  });

  test("author_id が存在しない行は drop してレポートに記録する", () => {
    const result = transformDefinitions([base], new Set(["w1"]), new Set());
    expect(result.rows).toEqual([]);
    expect(result.dropped[0]!.reason).toMatch(/author_id/);
  });
});

describe("transformLikes", () => {
  const like: LikeRecord = { id: "l1", definitionId: "d1", userId: "u1", createdAt: 5 };

  test("definition/user が有効ならそのまま変換する", () => {
    const result = transformLikes([like], new Set(["d1"]), new Set(["u1"]));
    expect(result.rows).toEqual([{ user_id: "u1", definition_id: "d1", created_at: 5 }]);
  });

  test("definition_id が孤児なら drop する", () => {
    const result = transformLikes([like], new Set(), new Set(["u1"]));
    expect(result.rows).toEqual([]);
    expect(result.dropped).toHaveLength(1);
  });

  test("user_id が孤児なら drop する", () => {
    const result = transformLikes([like], new Set(["d1"]), new Set());
    expect(result.rows).toEqual([]);
    expect(result.dropped).toHaveLength(1);
  });
});

describe("transformFollows", () => {
  // 旧 UserFollowRepository.follow(currentUserId, targetUserId) の保存形状を明示:
  // actor が target をフォローすると followerId=target, followingId=actor で保存される。
  const actor = "actor";
  const target = "target";
  const oldFollow: UserFollowRecord = {
    id: "f1",
    followerId: target, // 旧: される側
    followingId: actor, // 旧: する側
    createdAt: 5,
  };

  test("旧フィールドの向きを D1 の follower_id=する側 / following_id=される側 へ入れ替える", () => {
    const result = transformFollows([oldFollow], new Set([actor, target]));
    // 反転バグがあると follower_id=target になり、このアサーションが落ちる。
    expect(result.rows).toEqual([
      { follower_id: actor, following_id: target, created_at: 5 },
    ]);
  });

  test("フォローする側（旧 followingId）が孤児なら drop する", () => {
    // target のみ有効・actor は無効 → follower_id=actor が孤児で drop。
    const result = transformFollows([oldFollow], new Set([target]));
    expect(result.rows).toEqual([]);
    expect(result.dropped[0]!.reason).toBe(`orphan: follower_id ${actor} not found`);
  });

  test("フォローされる側（旧 followerId）が孤児なら drop する", () => {
    const result = transformFollows([oldFollow], new Set([actor]));
    expect(result.rows).toEqual([]);
    expect(result.dropped[0]!.reason).toBe(`orphan: following_id ${target} not found`);
  });

  test("自己フォローは drop する", () => {
    const result = transformFollows(
      [{ id: "f2", followerId: "u1", followingId: "u1", createdAt: 5 }],
      new Set(["u1"]),
    );
    expect(result.rows).toEqual([]);
    expect(result.dropped[0]!.reason).toBe("invalid: self follow");
  });
});

describe("transformUserMutes", () => {
  test("mutedUserIdList から user_mutes 行を生成し createdAt は移行時刻を使う", () => {
    const configs: UserConfigRecord[] = [
      {
        id: "u1",
        appVersion: "1.0.0",
        osVersion: "iOS 18",
        mutedUserIdList: ["u2"],
        createdAt: 1,
        updatedAt: 1,
      },
    ];
    const result = transformUserMutes(configs, new Set(["u1", "u2"]), 999);
    expect(result.rows).toEqual([{ muter_id: "u1", muted_user_id: "u2", created_at: 999 }]);
  });

  test("ミュート対象が存在しないユーザーなら drop する", () => {
    const configs: UserConfigRecord[] = [
      {
        id: "u1",
        appVersion: "1.0.0",
        osVersion: "iOS 18",
        mutedUserIdList: ["ghost"],
        createdAt: 1,
        updatedAt: 1,
      },
    ];
    const result = transformUserMutes(configs, new Set(["u1"]), 999);
    expect(result.rows).toEqual([]);
    expect(result.dropped).toHaveLength(1);
  });

  test("自己ミュートは drop する", () => {
    const configs: UserConfigRecord[] = [
      {
        id: "u1",
        appVersion: "1.0.0",
        osVersion: "iOS 18",
        mutedUserIdList: ["u1"],
        createdAt: 1,
        updatedAt: 1,
      },
    ];
    const result = transformUserMutes(configs, new Set(["u1"]), 999);
    expect(result.rows).toEqual([]);
    expect(result.dropped[0]!.reason).toBe("invalid: self mute");
  });

  test("重複したミュート指定は 1 行に de-dup する", () => {
    const configs: UserConfigRecord[] = [
      {
        id: "u1",
        appVersion: "1.0.0",
        osVersion: "iOS 18",
        mutedUserIdList: ["u2", "u2"],
        createdAt: 1,
        updatedAt: 1,
      },
    ];
    const result = transformUserMutes(configs, new Set(["u1", "u2"]), 999);
    expect(result.rows).toHaveLength(1);
  });
});

describe("buildMigrationReport", () => {
  test("drop 件数・補完件数・アバター分類件数を集計する", () => {
    const report = buildMigrationReport({
      defaultedMissingUserConfigs: ["u1"],
      droppedDefinitions: [{ id: "d1", reason: "orphan" }],
      droppedLikes: [],
      droppedFollows: [],
      droppedUserMutes: [],
      avatarClassifications: new Map([
        ["u1", { type: "default", slug: "ghost_writer", objectPath: "x" } as const],
        ["u2", { type: "custom", objectPath: "y" } as const],
      ]),
      now: () => new Date("2026-07-20T00:00:00.000Z"),
    });
    expect(report.generatedAt).toBe("2026-07-20T00:00:00.000Z");
    expect(report.droppedForeignKeyOrphans.find((e) => e.table === "definitions")).toMatchObject({
      count: 1,
      ids: ["d1"],
    });
    expect(report.defaultedMissingUserConfigs).toEqual([{ userId: "u1" }]);
    expect(report.avatarClassificationCounts).toEqual({ default: 1, custom: 1 });
  });
});
