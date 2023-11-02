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
    switch (definitionFeedType) {
      case DefinitionFeedType.homeRecommend:
        return await _homeRecommendDefinitionIdListFirst();
      case DefinitionFeedType.homeFollowing:
        return await _fetchHomeFollowingDefinitionIdListFirst();
    }
  }

  /// 「ホーム画面: おすすめタブ」で表示するDefinitionIDのListを取得する（初回）
  ///
  /// この関数は、[build]メソッドからのみ呼ばれる想定
  Future<DefinitionIdListState> _homeRecommendDefinitionIdListFirst() async {
    final mutedUserIdList = await ref.read(mutedUserIdListProvider.future);

    return ref
        .watch(definitionRepositoryProvider)
        .fetchHomeRecommendDefinitionIdListFirst(mutedUserIdList);
  }

  /// 「ホーム画面: フォロー中タブ」で表示するDefinitionIDのListを取得する（初回）
  ///
  /// この関数は、[build]メソッドからのみ呼ばれる想定
  Future<DefinitionIdListState>
      _fetchHomeFollowingDefinitionIdListFirst() async {
    final userId = ref.read(userIdProvider)!;

    final targetUserIdList = <String>[];

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

    return ref
        .read(definitionRepositoryProvider)
        .fetchHomeFollowingDefinitionIdListFirst(targetUserIdList);
  }

  Future<void> fetchMore() async {
    await fetchMoreHelper(
      ref: ref,
      fetchFunction: _fetchDefinitionIdListStateBasedOnType,
      mergeFunction: (currentData, newData) => DefinitionIdListState(
        definitionIdList:
            currentData.definitionIdList + newData.definitionIdList,
        lastReadQueryDocumentSnapshot: newData.lastReadQueryDocumentSnapshot,
        hasMore: newData.hasMore,
      ),
    );
  }

  Future<DefinitionIdListState> _fetchDefinitionIdListStateBasedOnType() async {
    switch (definitionFeedType) {
      case DefinitionFeedType.homeRecommend:
        return _homeRecommendDefinitionIdListMore();
      case DefinitionFeedType.homeFollowing:
        return _fetchHomeFollowingDefinitionIdListMore();
    }
  }

  /// 「ホーム画面: おすすめタブ」で表示するDefinitionIDのListを取得する（2回目以降）
  Future<DefinitionIdListState> _homeRecommendDefinitionIdListMore() async {
    final mutedUserIdList = await ref.read(mutedUserIdListProvider.future);

    return ref
        .watch(definitionRepositoryProvider)
        .fetchHomeRecommendDefinitionIdListMore(
          mutedUserIdList,
          state.value!.lastReadQueryDocumentSnapshot!,
        );
  }

  /// 「ホーム画面: フォロー中タブ」で表示するDefinitionIDのListを取得する（2回目以降）
  // TODO(me): _fetchHomeFollowingDefinitionIdListFirstと共通のロジックが多く、リファクタの余地あり
  Future<DefinitionIdListState>
      _fetchHomeFollowingDefinitionIdListMore() async {
    final userId = ref.read(userIdProvider)!;

    final targetUserIdList = <String>[];

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

    return ref
        .read(definitionRepositoryProvider)
        .fetchHomeFollowingDefinitionIdListMore(
          targetUserIdList,
          state.value!.lastReadQueryDocumentSnapshot!,
        );
  }
}
