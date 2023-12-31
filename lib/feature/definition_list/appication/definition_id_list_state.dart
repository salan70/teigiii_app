import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../util/constant/initial_main_group.dart';
import '../../../util/mixin/fetch_more_mixin.dart';
import '../../auth/application/auth_state.dart';
import '../../user_config/application/user_config_state.dart';
import '../../user_follow/application/user_follow_state.dart';
import '../domain/definition_id_list_state.dart';
import '../repository/definition_id_list_repository.dart';
import '../util/definition_feed_type.dart';

part 'definition_id_list_state.g.dart';

@Riverpod(keepAlive: true)
class DefinitionIdListStateNotifier extends _$DefinitionIdListStateNotifier
    with FetchMoreMixin<DefinitionIdListState> {
  @override
  FutureOr<DefinitionIdListState> build(
    DefinitionFeedType definitionFeedType, {
    String? wordId,
    String? targetUserId,
    InitialSubGroup? initialSubGroup,
  }) async {
    // ミュートユーザー, currentUser が更新されるたびに、
    // 本Notifierも更新されるよう監視する。
    ref
      ..watch(mutedUserIdListProvider)
      ..watch(userIdProvider);

    return await _fetchBasedOnType(isFirstFetch: true);
  }

  /// 「ホーム画面: おすすめタブ」で表示するDefinitionIDのListを取得する
  ///
  /// 初回取得時（buildメソットのみの想定）は、[isFirstFetch]をtrueにすること
  Future<DefinitionIdListState> _fetchForHomeRecommend({
    required bool isFirstFetch,
  }) async {
    final currentUserId = ref.read(userIdProvider)!;
    final mutedUserIdList = await ref.read(mutedUserIdListProvider.future);
    final lastDoc =
        isFirstFetch ? null : state.value?.lastReadQueryDocumentSnapshot;

    return ref.watch(definitionIdListRepositoryProvider).fetchForHomeRecommend(
          currentUserId,
          mutedUserIdList,
          lastDoc,
        );
  }

  /// 「ホーム画面: フォロー中タブ」で表示するDefinitionIDのListを取得する
  ///
  /// 初回取得時（buildメソットのみの想定）は、[isFirstFetch]をtrueにすること
  Future<DefinitionIdListState> _fetchForHomeFollowing({
    required bool isFirstFetch,
  }) async {
    final currentUserId = ref.read(userIdProvider)!;

    // フォローしているユーザーのIDリストを取得
    final followingIdList =
        await ref.read(followingIdListProvider(currentUserId).future);

    // フォローしているユーザーと自分のIDを追加
    final targetUserIdList = <String>[...followingIdList, currentUserId];

    // ミュートしているユーザーのIDを除外
    final mutedUserIdList = await ref.read(mutedUserIdListProvider.future);
    targetUserIdList.removeWhere(mutedUserIdList.contains);

    final lastDoc =
        isFirstFetch ? null : state.value?.lastReadQueryDocumentSnapshot;

    return ref.read(definitionIdListRepositoryProvider).fetchForHomeFollowing(
          currentUserId,
          targetUserIdList,
          lastDoc,
        );
  }

  /// 「Wordトップ画面: 投稿順タブ」で表示するDefinitionIDのListを取得する
  ///
  /// 初回取得時（buildメソットのみの想定）は、[isFirstFetch]をtrueにすること
  Future<DefinitionIdListState> _fetchForWordTop(
    WordTopOrderByType orderByType, {
    required bool isFirstFetch,
  }) async {
    if (wordId == null) {
      throw ArgumentError('wordIdがnullです');
    }

    final currentUserId = ref.read(userIdProvider)!;
    final mutedUserIdList = await ref.read(mutedUserIdListProvider.future);
    final lastDoc =
        isFirstFetch ? null : state.value?.lastReadQueryDocumentSnapshot;

    return ref.watch(definitionIdListRepositoryProvider).fetchForWordTop(
          orderByType,
          currentUserId,
          mutedUserIdList,
          wordId!,
          lastDoc,
        );
  }

  /// 「プロフィール画面: 投稿順タブ」で表示するDefinitionIDのListを取得する
  ///
  /// 初回取得時（buildメソットのみの想定）は、[isFirstFetch]をtrueにすること
  Future<DefinitionIdListState> _fetchForProfileCreatedAt({
    required bool isFirstFetch,
  }) async {
    if (targetUserId == null) {
      throw ArgumentError('targetUserIdがnullです');
    }

    final currentUserId = ref.read(userIdProvider)!;
    final lastDoc =
        isFirstFetch ? null : state.value?.lastReadQueryDocumentSnapshot;

    return ref
        .watch(definitionIdListRepositoryProvider)
        .fetchForProfileCreatedAt(
          currentUserId,
          targetUserId!,
          lastDoc,
        );
  }

  /// 「プロフィール画面: いいねタブ」で表示するDefinitionIDのListを取得する
  ///
  /// 初回取得時（buildメソットのみの想定）は、[isFirstFetch]をtrueにすること
  Future<DefinitionIdListState> _fetchForProfileLiked({
    required bool isFirstFetch,
  }) async {
    if (targetUserId == null) {
      throw ArgumentError('targetUserIdがnullです');
    }

    final currentUserId = ref.read(userIdProvider)!;
    final mutedUserIdList = await ref.read(mutedUserIdListProvider.future);
    final lastDoc =
        isFirstFetch ? null : state.value?.lastReadQueryDocumentSnapshot;

    return ref.watch(definitionIdListRepositoryProvider).fetchForLikedByUser(
          currentUserId,
          targetUserId!,
          mutedUserIdList,
          lastDoc,
        );
  }

  /// 「ユーザー毎の辞書 -> InitialSubGroup毎の定義一覧 画面」
  /// で表示するDefinitionIDのListを取得する
  ///
  /// 初回取得時（buildメソットのみの想定）は、[isFirstFetch]をtrueにすること
  Future<DefinitionIdListState> _fetchForIndividualDictionary({
    required bool isFirstFetch,
  }) async {
    if (initialSubGroup == null) {
      throw ArgumentError('initialSubGroupがnullです');
    }
    if (targetUserId == null) {
      throw ArgumentError('targetUserIdがnullです');
    }

    final currentUserId = ref.read(userIdProvider)!;
    final lastDoc =
        isFirstFetch ? null : state.value?.lastReadQueryDocumentSnapshot;

    return ref
        .watch(definitionIdListRepositoryProvider)
        .fetchForIndividualDictionary(
          currentUserId,
          targetUserId!,
          initialSubGroup!,
          lastDoc,
        );
  }

  Future<void> fetchMore() async {
    await fetchMoreHelper(
      ref: ref,
      fetchFunction: () => _fetchBasedOnType(isFirstFetch: false),
      mergeFunction: (currentData, newData) => DefinitionIdListState(
        list: currentData.list + newData.list,
        lastReadQueryDocumentSnapshot: newData.lastReadQueryDocumentSnapshot,
        hasMore: newData.hasMore,
      ),
    );
  }

  Future<DefinitionIdListState> _fetchBasedOnType({
    required bool isFirstFetch,
  }) async {
    switch (definitionFeedType) {
      case DefinitionFeedType.homeRecommend:
        return _fetchForHomeRecommend(isFirstFetch: isFirstFetch);

      case DefinitionFeedType.homeFollowing:
        return _fetchForHomeFollowing(isFirstFetch: isFirstFetch);

      case DefinitionFeedType.wordTopOrderByCreatedAt:
        return _fetchForWordTop(
          WordTopOrderByType.createdAt,
          isFirstFetch: isFirstFetch,
        );

      case DefinitionFeedType.wordTopOrderByLikesCount:
        return _fetchForWordTop(
          WordTopOrderByType.likesCount,
          isFirstFetch: isFirstFetch,
        );

      case DefinitionFeedType.profileOrderByCreatedAt:
        return _fetchForProfileCreatedAt(isFirstFetch: isFirstFetch);

      case DefinitionFeedType.profileLiked:
        return _fetchForProfileLiked(isFirstFetch: isFirstFetch);

      case DefinitionFeedType.individualIndex:
        return _fetchForIndividualDictionary(isFirstFetch: isFirstFetch);
    }
  }
}
