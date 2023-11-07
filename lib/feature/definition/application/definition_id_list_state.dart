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

    return ref
        .watch(definitionRepositoryProvider)
        .fetchHomeRecommendDefinitionIdListState(
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

    return ref
        .read(definitionRepositoryProvider)
        .fetchHomeFollowingDefinitionIdList(
          currentUserId,
          targetUserIdList,
          lastDoc,
        );
  }

  /// 「Wordトップ画面: 新着順タブ」で表示するDefinitionIDのListを取得する
  ///
  /// 初回取得時（buildメソットのみの想定）は、[isFirstFetch]をtrueにすること
  Future<DefinitionIdListState> _fetchForWordTop(
    WordTopOrderByType orderByType, {
    required bool isFirstFetch,
  }) async {
    final currentUserId = ref.read(userIdProvider)!;
    final mutedUserIdList = await ref.read(mutedUserIdListProvider.future);
    final lastDoc =
        isFirstFetch ? null : state.value?.lastReadQueryDocumentSnapshot;

    return ref
        .watch(definitionRepositoryProvider)
        .fetchWordTopDefinitionIdListState(
          orderByType,
          currentUserId,
          mutedUserIdList,
          wordId!,
          lastDoc,
        );
  }

  Future<void> fetchMore() async {
    await fetchMoreHelper(
      ref: ref,
      fetchFunction: () => _fetchBasedOnType(isFirstFetch: false),
      mergeFunction: (currentData, newData) => DefinitionIdListState(
        definitionIdList:
            currentData.definitionIdList + newData.definitionIdList,
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
        if (wordId == null) {
          throw Exception('wordIdがnullです');
        }

        return _fetchForWordTop(
          WordTopOrderByType.createdAt,
          isFirstFetch: isFirstFetch,
        );

      case DefinitionFeedType.wordTopOrderByLikesCount:
        if (wordId == null) {
          throw Exception('wordIdがnullです');
        }

        return _fetchForWordTop(
          WordTopOrderByType.likesCount,
          isFirstFetch: isFirstFetch,
        );
    }
  }
}
