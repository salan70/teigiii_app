enum DefinitionFeedType {
  /// ホーム画面: おすすめタブ
  homeRecommend,

  /// ホーム画面: フォロー中タブ
  homeFollowing,

  /// 言葉ページ: 自分の定義
  wordMine,

  /// 言葉ページ: 他者の定義・新着順
  wordOthersNewest,

  /// 言葉ページ: 他者の定義・リアクション順
  wordOthersReactions,

  /// プロフィール画面: 投稿順タブ
  profileOrderByCreatedAt,

  /// プロフィール画面: いいね数順タブ
  profileLiked,

  /// ユーザー毎の辞書 -> InitialSubGroup毎の定義一覧 画面
  individualIndex,
}

// TODO(me): [DefinitionFeedType]の値に合わせて更新する必要があことをなんとかしたい
enum WordTopOrderByType { createdAt, likesCount }
