import {
  applyD1Migrations,
  createExecutionContext,
  createScheduledController,
  env,
  waitOnExecutionContext,
} from "cloudflare:test";
import { beforeEach, describe, expect, test } from "vitest";

import worker from "../src/index";
import { runPhysicalDeletion } from "../src/maintenance/physical-deletion";

const dayMs = 24 * 60 * 60 * 1000;
const scheduledTime = new Date("2026-07-16T00:00:00.000Z");
const cutoff = scheduledTime.getTime() - 30 * dayMs;

async function insertUser(id: string, deletedAt: number | null, avatarKey: string | null = null) {
  await env.DB.prepare(
    `insert into users
       (id, public_id, name, bio, avatar_key, last_os_version, last_app_version,
        deleted_at, created_at, updated_at)
     values (?, ?, ?, '', ?, 'iOS 19', '2.0.0', ?, ?, ?)`,
  )
    .bind(id, `public-${id}`, id, avatarKey, deletedAt, cutoff - dayMs, cutoff - dayMs)
    .run();
}

async function insertDefinition(id: string, authorId: string, deletedAt: number | null) {
  await env.DB.prepare(
    `insert into definitions
       (id, word_id, author_id, body, status, finalized_at, deleted_at, created_at, updated_at)
     values (?, 'word-1', ?, 'body', 'public', ?, ?, ?, ?)`,
  )
    .bind(id, authorId, cutoff - dayMs, deletedAt, cutoff - dayMs, cutoff - dayMs)
    .run();
}

async function runScheduledHandler() {
  const context = createExecutionContext();
  const scheduled = worker.scheduled as ExportedHandlerScheduledHandler<Cloudflare.Env>;
  await scheduled(createScheduledController({ scheduledTime }), env, context);
  await waitOnExecutionContext(context);
}

beforeEach(async () => {
  await applyD1Migrations(env.DB, env.TEST_MIGRATIONS);
  await env.DB.batch([
    env.DB.prepare("delete from users"),
    env.DB.prepare("delete from words"),
    env.DB.prepare("delete from app_config"),
  ]);
  const objects = await env.AVATARS.list();
  if (objects.objects.length > 0) {
    await env.AVATARS.delete(objects.objects.map((object) => object.key));
  }
});

describe("physical deletion scheduled handler", () => {
  test("Scheduled Handler を公開する", () => {
    expect(worker.scheduled).toBeTypeOf("function");
  });

  test("30日以前に論理削除された定義・ユーザー・R2アバターだけを物理削除する", async () => {
    await insertUser("expired", cutoff, "avatars/expired");
    await insertUser("recent", cutoff + 1, "avatars/recent");
    await insertUser("active", null);
    await env.DB.prepare(
      `insert into words
         (id, word, reading, reading_sub_group, created_by, created_at, updated_at)
       values ('word-1', '自由', 'じゆう', 'さ', 'expired', ?, ?)`,
    )
      .bind(cutoff - dayMs, cutoff - dayMs)
      .run();
    await insertDefinition("expired-user-definition", "expired", cutoff);
    await insertDefinition("expired-definition", "active", cutoff);
    await insertDefinition("recent-definition", "active", cutoff + 1);
    await env.AVATARS.put("avatars/expired", "expired avatar");
    await env.AVATARS.put("avatars/recent", "recent avatar");

    await runScheduledHandler();

    const users = await env.DB.prepare("select id from users order by id").all<{ id: string }>();
    expect(users.results.map(({ id }) => id)).toEqual(["active", "recent"]);
    const definitions = await env.DB.prepare("select id from definitions order by id").all<{
      id: string;
    }>();
    expect(definitions.results.map(({ id }) => id)).toEqual(["recent-definition"]);
    await expect(env.AVATARS.get("avatars/expired")).resolves.toBeNull();
    await expect(env.AVATARS.get("avatars/recent")).resolves.not.toBeNull();
    await expect(
      env.DB.prepare("select created_by from words where id = 'word-1'").first(),
    ).resolves.toEqual({ created_by: null });
  });

  test("R2削除に失敗したユーザーを保持し、他の対象を継続して集計を記録する", async () => {
    await insertUser("failing", cutoff, "avatars/failing");
    await insertUser("succeeding", cutoff, "avatars/succeeding");
    await env.AVATARS.put("avatars/failing", "failing avatar");
    await env.AVATARS.put("avatars/succeeding", "succeeding avatar");
    const logs: unknown[] = [];
    const avatars = {
      delete: async (keys: string | string[]) => {
        if (keys === "avatars/failing") throw new Error("simulated R2 failure");
        return env.AVATARS.delete(keys);
      },
    } as unknown as R2Bucket;

    await runPhysicalDeletion({ AVATARS: avatars, DB: env.DB }, scheduledTime.getTime(), {
      log: (entry: unknown) => logs.push(entry),
    });

    const users = await env.DB.prepare("select id from users order by id").all<{ id: string }>();
    expect(users.results.map(({ id }) => id)).toEqual(["failing"]);
    await expect(env.AVATARS.get("avatars/failing")).resolves.not.toBeNull();
    await expect(env.AVATARS.get("avatars/succeeding")).resolves.toBeNull();
    expect(logs).toEqual([
      {
        entity: "user",
        errorType: "Error",
        event: "physical_deletion_item_failed",
        stage: "avatar_delete",
      },
      {
        definitions: { failure: 0, success: 0, target: 0 },
        event: "physical_deletion_completed",
        users: { failure: 1, success: 1, target: 2 },
      },
    ]);
  });

  test("定義の一括削除に失敗してもユーザー削除を継続して失敗件数を記録する", async () => {
    await insertUser("active", null);
    await insertUser("expired", cutoff);
    await env.DB.prepare(
      `insert into words
         (id, word, reading, reading_sub_group, created_at, updated_at)
       values ('word-1', '自由', 'じゆう', 'さ', ?, ?)`,
    )
      .bind(cutoff - dayMs, cutoff - dayMs)
      .run();
    await insertDefinition("expired-definition", "active", cutoff);
    const logs: unknown[] = [];
    const database = {
      prepare(query: string) {
        if (!query.startsWith("delete from definitions")) return env.DB.prepare(query);
        return {
          bind: () => ({
            run: async () => {
              throw new Error("simulated D1 failure");
            },
          }),
        } as unknown as D1PreparedStatement;
      },
    } as unknown as D1Database;

    await runPhysicalDeletion({ AVATARS: env.AVATARS, DB: database }, scheduledTime.getTime(), {
      log: (entry) => logs.push(entry),
    });

    await expect(
      env.DB.prepare("select id from users order by id").all<{ id: string }>(),
    ).resolves.toMatchObject({ results: [{ id: "active" }] });
    await expect(
      env.DB.prepare("select id from definitions").all<{ id: string }>(),
    ).resolves.toMatchObject({ results: [{ id: "expired-definition" }] });
    expect(logs).toEqual([
      {
        entity: "definitions",
        errorType: "Error",
        event: "physical_deletion_batch_failed",
        stage: "database_delete",
        target: 1,
      },
      {
        definitions: { failure: 1, success: 0, target: 1 },
        event: "physical_deletion_completed",
        users: { failure: 0, success: 1, target: 1 },
      },
    ]);
  });

  test("削除完了後に再実行しても成功し、対象件数を0として記録する", async () => {
    await insertUser("expired", cutoff, "avatars/expired");
    await env.AVATARS.put("avatars/expired", "expired avatar");
    const logs: unknown[] = [];

    await runPhysicalDeletion({ AVATARS: env.AVATARS, DB: env.DB }, scheduledTime.getTime(), {
      log: () => {},
    });
    await runPhysicalDeletion({ AVATARS: env.AVATARS, DB: env.DB }, scheduledTime.getTime(), {
      log: (entry) => logs.push(entry),
    });

    expect(logs).toEqual([
      {
        definitions: { failure: 0, success: 0, target: 0 },
        event: "physical_deletion_completed",
        users: { failure: 0, success: 0, target: 0 },
      },
    ]);
  });
});
