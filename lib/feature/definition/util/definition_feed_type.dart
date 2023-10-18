enum DefinitionFeedType {
  /// ホーム画面のおすすめタブ
  homeRecommend,

  /// ホーム画面のフォロー中タブ
  homeFollowing,

  // TODO(me): 以下はそれぞれ必要な画面実装時に追加する
  // ソート系と画面系それぞれのenumを作るのがいいかも
  // その場合、語句名の五十音順など、Definitionコレクションのソートでは対応できないものがあることに注意

  // /// 語句毎の定義一覧画面の新着順
  // perWordOrderByUpdatedAt,

  // /// 語句毎の定義一覧画面のいいね順
  // perWordOrderByLikesCount,

  // /// 自らのプロフィール画面の投稿タブ、語句名の五十音順
  // selfProfilePostedOrderByWordName,

  // /// 自らのプロフィール画面の投稿タブ、更新日時順
  // selfProfilePostedOrderByUpdatedAt,

  // /// 自らのプロフィール画面のいいねタブ
  // selfProfileLiked,

  // /// 他ユーザーのプロフィール画面の投稿タブ、語句名の五十音順
  // otherProfilePostedOrderByWordName,

  // /// 他ユーザーのプロフィール画面の投稿タブ、更新日時順
  // otherProfilePostedOrderByUpdatedAt,

  // /// 他ユーザーのプロフィール画面のいいねタブ
  // otherProfileLiked,
}
