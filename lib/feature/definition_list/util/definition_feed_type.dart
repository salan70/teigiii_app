enum DefinitionFeedType {
  /// ホーム画面: おすすめタブ
  homeRecommend,

  /// ホーム画面: フォロー中タブ
  homeFollowing,

  /// 語句毎の定義一覧画面: 投稿順タブ
  wordTopOrderByCreatedAt,

  /// 語句毎の定義一覧画面: いいね数順タブ
  wordTopOrderByLikesCount,

  /// プロフィール画面: 投稿順タブ
  profileOrderByCreatedAt,

  /// プロフィール画面: いいね数順タブ
  profileLiked,

  /// ユーザー毎の辞書 -> InitialSubGroup毎の定義一覧 画面
  individualIndex,
}

// TODO(me): [DefinitionFeedType]の値に合わせて更新する必要があことをなんとかしたい
enum WordTopOrderByType {
  createdAt,
  likesCount;
}
