/**
 * 閲覧者に対して言葉を公開経路へ出す条件。
 *
 * - ミュートしていないユーザー（または退会で匿名化された登録）による明示登録がある
 * - またはミュートしていない有効ユーザーの削除されていない公開定義が 1 件以上ある
 *
 * SQL 断片は `w` エイリアスの words 行を対象とする。`viewerUid` のバインドが 2 回必要。
 */
export function publiclyVisibleWordSql(viewerUidPlaceholder = "?"): string {
  return `(
    exists(
      select 1 from word_registrations wr
      where wr.word_id = w.id
        and (
          wr.user_id is null
          or (
            exists(
              select 1 from users registrant
              where registrant.id = wr.user_id and registrant.deleted_at is null
            )
            and not exists(
              select 1 from user_mutes m
              where m.muter_id = ${viewerUidPlaceholder}
                and m.muted_user_id = wr.user_id
            )
          )
        )
    )
    or exists(
      select 1 from definitions d
      join users author on author.id = d.author_id and author.deleted_at is null
      where d.word_id = w.id
        and d.status = 'public'
        and d.deleted_at is null
        and not exists(
          select 1 from user_mutes m
          where m.muter_id = ${viewerUidPlaceholder}
            and m.muted_user_id = d.author_id
        )
    )
  )`;
}

/**
 * 詳細・定義一覧など直接アクセス可能な条件。
 * 公開経路に出る言葉に加え、閲覧者自身の未削除定義がある言葉を許可する。
 */
export function accessibleWordSql(viewerUidPlaceholder = "?"): string {
  return `(
    ${publiclyVisibleWordSql(viewerUidPlaceholder)}
    or exists(
      select 1 from definitions mine
      where mine.word_id = w.id
        and mine.author_id = ${viewerUidPlaceholder}
        and mine.deleted_at is null
    )
  )`;
}
