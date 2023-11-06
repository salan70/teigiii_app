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
    DefinitionFeedType definitionFeedType,
  ) async {
    const isFirstFetch = true;

    switch (definitionFeedType) {
      case DefinitionFeedType.homeRecommend:
        return await _homeRecommendDefinitionIdList(
          isFirstFetch: isFirstFetch,
        );

      case DefinitionFeedType.homeFollowing:
        return await _fetchHomeFollowingDefinitionIdList(
          isFirstFetch: isFirstFetch,
        );
    }
  }

  /// 「ホーム画面: おすすめタブ」で表示するDefinitionIDのListを取得する
  ///
  /// 初回取得時（buildメソットのみの想定）は、[isFirstFetch]をtrueにすること
  Future<DefinitionIdListState> _homeRecommendDefinitionIdList({
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
  Future<DefinitionIdListState> _fetchHomeFollowingDefinitionIdList({
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
    switch (definitionFeedType) {
      case DefinitionFeedType.homeRecommend:
        return _homeRecommendDefinitionIdList(isFirstFetch: false);

      case DefinitionFeedType.homeFollowing:
        return _fetchHomeFollowingDefinitionIdList(isFirstFetch: false);
    }
  }
}
