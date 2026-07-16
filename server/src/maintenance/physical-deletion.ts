import type { Env } from "../app";

const retentionMs = 30 * 24 * 60 * 60 * 1000;

type ExpiredUser = {
  avatar_key: string | null;
  id: string;
};

type Counts = {
  failure: number;
  success: number;
  target: number;
};

type PhysicalDeletionLogEntry =
  | {
      entity: "definitions";
      errorType: string;
      event: "physical_deletion_batch_failed";
      stage: "database_delete";
      target: number;
    }
  | {
      entity: "user";
      errorType: string;
      event: "physical_deletion_item_failed";
      stage: "avatar_delete" | "database_delete";
    }
  | {
      definitions: Counts;
      event: "physical_deletion_completed";
      users: Counts;
    };

type RunPhysicalDeletionOptions = {
  log?: (entry: PhysicalDeletionLogEntry) => void;
};

function errorType(error: unknown): string {
  return error instanceof Error ? error.name : "UnknownError";
}

/**
 * @doc doc/specs/workers-api-server.md#物理削除
 */
export async function runPhysicalDeletion(
  env: Pick<Env, "AVATARS" | "DB">,
  now: number,
  { log = (entry) => console.log(JSON.stringify(entry)) }: RunPhysicalDeletionOptions = {},
) {
  const cutoff = now - retentionMs;
  const definitionTarget =
    (
      await env.DB.prepare(
        "select count(*) as count from definitions where deleted_at is not null and deleted_at <= ?",
      )
        .bind(cutoff)
        .first<{ count: number }>()
    )?.count ?? 0;

  let definitionSuccess = 0;
  let definitionFailure = 0;
  try {
    await env.DB.prepare("delete from definitions where deleted_at is not null and deleted_at <= ?")
      .bind(cutoff)
      .run();
    definitionSuccess = definitionTarget;
  } catch (error) {
    definitionFailure = definitionTarget;
    log({
      entity: "definitions",
      errorType: errorType(error),
      event: "physical_deletion_batch_failed",
      stage: "database_delete",
      target: definitionTarget,
    });
  }

  const expiredUsers = await env.DB.prepare(
    `select id, avatar_key
     from users
     where deleted_at is not null and deleted_at <= ?`,
  )
    .bind(cutoff)
    .all<ExpiredUser>();

  let userSuccess = 0;
  let userFailure = 0;
  for (const user of expiredUsers.results) {
    let stage: "avatar_delete" | "database_delete" = "avatar_delete";
    try {
      if (user.avatar_key !== null) await env.AVATARS.delete(user.avatar_key);
      stage = "database_delete";
      await env.DB.prepare("delete from users where id = ? and deleted_at <= ?")
        .bind(user.id, cutoff)
        .run();
      userSuccess++;
    } catch (error) {
      userFailure++;
      log({
        entity: "user",
        errorType: errorType(error),
        event: "physical_deletion_item_failed",
        stage,
      });
    }
  }

  log({
    definitions: {
      failure: definitionFailure,
      success: definitionSuccess,
      target: definitionTarget,
    },
    event: "physical_deletion_completed",
    users: {
      failure: userFailure,
      success: userSuccess,
      target: expiredUsers.results.length,
    },
  });
}
