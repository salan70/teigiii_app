import { describe, expect, test } from "bun:test";

import { diffRows, parseD1JsonOutput, reclassifyAvatarUrl, recomputeExpectedState } from "./verify";
import type { Snapshot } from "./verify";

const defaultIconUrl =
  "https://firebasestorage.googleapis.com/v0/b/everyone-teigi-prod.appspot.com/o/common%2Fdefault_icon_image%2Fghost_writer.png?alt=media&token=dummy";

function customIconUrl(uid: string): string {
  return `https://firebasestorage.googleapis.com/v0/b/everyone-teigi-prod.appspot.com/o/users%2F${uid}%2Fprofile_image.png?alt=media&token=dummy`;
}

function emptySnapshot(): Snapshot {
  return {
    words: [],
    definitions: [],
    likes: [],
    userProfiles: [],
    userConfigs: [],
    userFollows: [],
    avatarManifest: { entries: [] },
  };
}

describe("reclassifyAvatarUrl", () => {
  test("デフォルトアイコンを分類する", () => {
    expect(reclassifyAvatarUrl(defaultIconUrl, "u1")).toEqual({ type: "default" });
  });

  test("カスタム画像を分類する", () => {
    expect(reclassifyAvatarUrl(customIconUrl("u1"), "u1")).toEqual({ type: "custom" });
  });

  test("未知パターンは fail-fast する", () => {
    expect(() => reclassifyAvatarUrl("https://example.com/a.png", "u1")).toThrow();
  });
});

describe("recomputeExpectedState", () => {
  test("words は trim + NFC 正規化して readingSubGroup を再計算する", () => {
    const snapshot = emptySnapshot();
    snapshot.words = [
      { id: "w1", word: "  言葉  ", reading: "ことば", createdAt: 1, updatedAt: 1 },
    ];
    const state = recomputeExpectedState(snapshot, 0);
    expect(state.words[0]).toMatchObject({ id: "w1", word: "言葉", reading_sub_group: "こ" });
  });

  test("重複 word は createdAt 最古（同値なら id 昇順）を正としてマージし定義を付け替える", () => {
    const snapshot = emptySnapshot();
    snapshot.words = [
      { id: "w1", word: "同じ", reading: "おなじ", createdAt: 20, updatedAt: 20 },
      { id: "w2", word: "同じ", reading: "おなじ", createdAt: 10, updatedAt: 10 },
    ];
    snapshot.userProfiles = [
      {
        id: "u1",
        publicId: "000000001",
        name: "太郎",
        bio: "",
        profileImageUrl: defaultIconUrl,
        createdAt: 1,
        updatedAt: 1,
      },
    ];
    snapshot.definitions = [
      {
        id: "d1",
        wordId: "w1",
        authorId: "u1",
        definition: "本文",
        isPublic: true,
        isEdited: false,
        createdAt: 1,
        updatedAt: 1,
      },
    ];
    const state = recomputeExpectedState(snapshot, 0);
    expect(state.words).toHaveLength(1);
    expect(state.words[0]).toMatchObject({ id: "w2", word: "同じ", created_at: 10 });
    expect(state.definitions[0]).toMatchObject({ id: "d1", word_id: "w2" });
    expect(state.droppedCounts.definitions).toBe(0);
    expect(state.mergedWordGroupCount).toBe(1);
  });

  test("id のタイブレークはロケール非依存のコードポイント順で行う", () => {
    const snapshot = emptySnapshot();
    snapshot.words = [
      { id: "a1", word: "同時刻", reading: "どうじこく", createdAt: 5, updatedAt: 5 },
      { id: "B1", word: "同時刻", reading: "どうじこく", createdAt: 5, updatedAt: 5 },
    ];
    const state = recomputeExpectedState(snapshot, 0);
    expect(state.words).toHaveLength(1);
    expect(state.words[0]!.id).toBe("B1");
  });

  test("UserConfigs 欠損ユーザーは 'unknown' 補完としてカウントする", () => {
    const snapshot = emptySnapshot();
    snapshot.userProfiles = [
      {
        id: "u1",
        publicId: "000000001",
        name: "太郎",
        bio: "",
        profileImageUrl: defaultIconUrl,
        createdAt: 1,
        updatedAt: 1,
      },
    ];
    const state = recomputeExpectedState(snapshot, 0);
    expect(state.users[0]).toMatchObject({
      last_app_version: "unknown",
      last_os_version: "unknown",
    });
    expect(state.defaultedUserConfigCount).toBe(1);
  });

  test("FK 孤児の definitions/likes/follows/user_mutes は件数カウントして除外する", () => {
    const snapshot = emptySnapshot();
    snapshot.userProfiles = [
      {
        id: "u1",
        publicId: "000000001",
        name: "太郎",
        bio: "",
        profileImageUrl: defaultIconUrl,
        createdAt: 1,
        updatedAt: 1,
      },
    ];
    snapshot.words = [{ id: "w1", word: "言葉", reading: "ことば", createdAt: 1, updatedAt: 1 }];
    snapshot.definitions = [
      {
        id: "d1",
        wordId: "w1",
        authorId: "u1",
        definition: "ok",
        isPublic: true,
        isEdited: false,
        createdAt: 1,
        updatedAt: 1,
      },
      {
        id: "d2",
        wordId: "ghost-word",
        authorId: "u1",
        definition: "ng",
        isPublic: true,
        isEdited: false,
        createdAt: 1,
        updatedAt: 1,
      },
    ];
    snapshot.likes = [{ id: "l1", definitionId: "ghost-def", userId: "u1", createdAt: 1 }];
    snapshot.userFollows = [
      { id: "f1", followerId: "u1", followingId: "ghost-user", createdAt: 1 },
    ];
    snapshot.userConfigs = [
      {
        id: "u1",
        appVersion: "1.0.0",
        osVersion: "iOS 18",
        mutedUserIdList: ["ghost-user"],
        createdAt: 1,
        updatedAt: 1,
      },
    ];

    const state = recomputeExpectedState(snapshot, 0);
    expect(state.definitions).toHaveLength(1);
    expect(state.droppedCounts).toEqual({ definitions: 1, likes: 1, follows: 1, userMutes: 1 });
  });

  test("follows は旧フィールドの向き（followingId=する側）を D1 の follower_id へ入れ替える", () => {
    // 旧 UserFollowRepository.follow(actor, target) の保存形状: followerId=target, followingId=actor。
    const snapshot = emptySnapshot();
    const makeProfile = (id: string) => ({
      id,
      publicId: id,
      name: id,
      bio: "",
      profileImageUrl: defaultIconUrl,
      createdAt: 1,
      updatedAt: 1,
    });
    snapshot.userProfiles = [makeProfile("actor"), makeProfile("target")];
    snapshot.userFollows = [
      { id: "f1", followerId: "target", followingId: "actor", createdAt: 5 },
    ];

    const state = recomputeExpectedState(snapshot, 0);
    // 反転バグがあると follower_id=target になり落ちる。
    expect(state.follows).toEqual([
      { follower_id: "actor", following_id: "target", created_at: 5 },
    ]);
  });
});

describe("parseD1JsonOutput", () => {
  test("wrangler d1 execute --json の出力から results を取り出す", () => {
    const raw = JSON.stringify([{ results: [{ id: "u1" }], success: true, meta: {} }]);
    expect(parseD1JsonOutput(raw)).toEqual([{ id: "u1" }]);
  });

  test("結果が空でも空配列を返す", () => {
    const raw = JSON.stringify([{ results: [], success: true, meta: {} }]);
    expect(parseD1JsonOutput(raw)).toEqual([]);
  });
});

describe("diffRows", () => {
  test("完全一致なら差分なし", () => {
    const diff = diffRows("t", [{ id: "1", v: "a" }], [{ id: "1", v: "a" }], (r) => r.id as string);
    expect(diff.missingInActual).toEqual([]);
    expect(diff.unexpectedInActual).toEqual([]);
    expect(diff.mismatched).toEqual([]);
  });

  test("actual に存在しない期待行を missingInActual に入れる", () => {
    const diff = diffRows("t", [{ id: "1", v: "a" }], [], (r) => r.id as string);
    expect(diff.missingInActual).toEqual([{ id: "1", v: "a" }]);
  });

  test("expected にない actual 行を unexpectedInActual に入れる", () => {
    const diff = diffRows("t", [], [{ id: "1", v: "a" }], (r) => r.id as string);
    expect(diff.unexpectedInActual).toEqual([{ id: "1", v: "a" }]);
  });

  test("キーは一致するがフィールドが異なる行を mismatched に入れる", () => {
    const diff = diffRows("t", [{ id: "1", v: "a" }], [{ id: "1", v: "b" }], (r) => r.id as string);
    expect(diff.mismatched).toHaveLength(1);
    expect(diff.mismatched[0]!.key).toBe("1");
  });
});
