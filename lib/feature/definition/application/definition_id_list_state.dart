import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../util/mixin/fetch_more_mixin.dart';
import '../../auth/application/auth_state.dart';
import '../../user_config/application/user_config_state.dart';
import '../../user_profile/application/user_profile_state.dart';
import '../domain/definition_id_list_state.dart';
import '../repository/definition_repository.dart';
import '../util/definition_feed_type.dart';

part 'definition_id_list_state.g.dart';

@Riverpod(keepAlive: true)
class DefinitionIdListStateNotifier extends _$DefinitionIdListStateNotifier
    with FetchMoreMixin<DefinitionIdListState> {
  @override
  FutureOr<DefinitionIdListState> build(
    DefinitionFeedType definitionFeedType, {
    String? wordId,
  }) async {
    // ミュートユーザーが更新されるたびに、本Notifierも更新されるよう監視
    ref.watch(mutedUserIdListProvider);

    const isFirstFetch = true;

    switch (definitionFeedType) {
      case DefinitionFeedType.homeRecommend:
        return await _fetchForHomeRecommend(isFirstFetch: isFirstFetch);

      case DefinitionFeedType.homeFollowing:
        return await _fetchForHomeFollowing(isFirstFetch: isFirstFetch);

      case DefinitionFeedType.wordTopOrderByCreatedAt:
        if (wordId == null) {
          throw Exception('wordIdがnullです');
        }
        return await _fetchForWordTopOrderByCreatedAt(
          isFirstFetch: isFirstFetch,
        );

      case DefinitionFeedType.wordTopOrderByLikesCount:
        if (wordId == null) {
          throw Exception('wordIdがnullです');
        }
        return await _fetchForWordTopOrderByCreatedAt(
          isFirstFetch: isFirstFetch,
        );
    }
  }

  /// 「ホーム画面: おすすめタブ」で表示するDefinitionIDのListを取得する
  ///
  /// 初回取得時（buildメソットのみの想定）は、[isFirstFetch]をtrueにすること
  Future<DefinitionIdListState> _fetchForHomeRecommend({
    required bool isFirstFetch,
  }) async {
    final mutedUserIdList = await ref.read(mutedUserIdListProvider.future);
    final lastDoc =
        isFirstFetch ? null : state.value?.lastReadQueryDocumentSnapshot;

    return ref
        .watch(definitionRepositoryProvider)
        .fetchHomeRecommendDefinitionIdList(
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
    final targetUserIdList = <String>[];
    final userId = ref.read(userIdProvider)!;

    // フォローしているユーザーのIDリストを取得
    final followingIdList =
        await ref.read(followingIdListProvider(userId).future);

    // フォローしているユーザーと自分のIDを追加
    targetUserIdList
      ..addAll(followingIdList)
      ..add(userId);

    // ミュートしているユーザーのIDを除外
    final mutedUserIdList = await ref.read(mutedUserIdListProvider.future);
    targetUserIdList.removeWhere(mutedUserIdList.contains);

    final lastDoc =
        isFirstFetch ? null : state.value?.lastReadQueryDocumentSnapshot;

    return ref
        .read(definitionRepositoryProvider)
        .fetchHomeFollowingDefinitionIdList(
          targetUserIdList,
          lastDoc,
        );
  }

  /// 「Wordトップ画面: 新着順タブ」で表示するDefinitionIDのListを取得する
  ///
  /// 初回取得時（buildメソットのみの想定）は、[isFirstFetch]をtrueにすること
  Future<DefinitionIdListState> _fetchForWordTopOrderByCreatedAt({
    required bool isFirstFetch,
  }) async {
    final currentUserId = ref.read(userIdProvider)!;
    final mutedUserIdList = await ref.read(mutedUserIdListProvider.future);
    final lastDoc =
        isFirstFetch ? null : state.value?.lastReadQueryDocumentSnapshot;

    return ref
        .watch(definitionRepositoryProvider)
        .fetchWordTopOrderByCreatedAtDefinitionIdList(
          currentUserId,
          mutedUserIdList,
          wordId!,
          lastDoc,
        );
  }

  Future<void> fetchMore() async {
    await fetchMoreHelper(
      ref: ref,
      fetchFunction: _fetchMoreBasedOnType,
      mergeFunction: (currentData, newData) => DefinitionIdListState(
        definitionIdList:
            currentData.definitionIdList + newData.definitionIdList,
        lastReadQueryDocumentSnapshot: newData.lastReadQueryDocumentSnapshot,
        hasMore: newData.hasMore,
      ),
    );
  }

  Future<DefinitionIdListState> _fetchMoreBasedOnType() async {
    const isFirstFetch = false;
    switch (definitionFeedType) {
      case DefinitionFeedType.homeRecommend:
        return _fetchForHomeRecommend(isFirstFetch: isFirstFetch);

      case DefinitionFeedType.homeFollowing:
        return _fetchForHomeFollowing(isFirstFetch: isFirstFetch);

      case DefinitionFeedType.wordTopOrderByCreatedAt:
        return _fetchForWordTopOrderByCreatedAt(
          isFirstFetch: isFirstFetch,
        );

      case DefinitionFeedType.wordTopOrderByLikesCount:
        return _fetchForWordTopOrderByCreatedAt(
          isFirstFetch: isFirstFetch,
        );
    }
  }
}
