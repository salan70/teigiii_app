enum DefinitionFeedType {
  /// ホーム画面: おすすめタブ
  homeRecommend,

  /// ホーム画面: フォロー中タブ
  homeFollowing,

  /// 言葉毎の定義一覧画面: 投稿順タブ
  wordTopOrderByCreatedAt,

  /// 言葉毎の定義一覧画面: いいね数順タブ
  wordTopOrderByLikesCount,

  /// プロフィール画面: 投稿順タブ
  profileOrderByCreatedAt,

  /// プロフィール画面: いいね数順タブ
  profileLiked,

  /// あなたの辞書: 特定の言葉に対する自分の定義一覧（新着順）
  userWordDefinitions,
}

// TODO(me): [DefinitionFeedType]の値に合わせて更新する必要があことをなんとかしたい
enum WordTopOrderByType { createdAt, likesCount }
