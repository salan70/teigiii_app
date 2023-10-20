import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/common_provider/snack_bar_controller.dart';
import '../../auth/application/auth_state.dart';
import '../../auth/repository/user_config_repository.dart';
import '../../user/repository/user_profile_repository.dart';
import '../domain/definition_id_list_state.dart';
import '../repository/definition_repository.dart';
import '../util/definition_feed_type.dart';

part 'definition_id_list_state.g.dart';

@Riverpod(keepAlive: true)
class DefinitionIdListStateNotifier extends _$DefinitionIdListStateNotifier {
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
    final mutedUserIdList = await _fetchMutedUserIdList();

    return ref
        .watch(definitionRepositoryProvider)
        .fetchHomeRecommendDefinitionIdListFirst(mutedUserIdList);
  }

  /// 「ホーム画面: フォロー中タブ」で表示するDefinitionIDのListを取得する（初回）
  ///
  /// この関数は、[build]メソッドからのみ呼ばれる想定
  Future<DefinitionIdListState>
      _fetchHomeFollowingDefinitionIdListFirst() async {
    final userId = (await ref.read(userIdProvider.future))!;

    final targetUserIdList = <String>[];

    // フォローしているユーザーのIDリストを取得
    final followingIdList = await ref
        .watch(userProfileRepositoryProvider)
        .fetchFollowingIdList(userId);

    // フォローしているユーザーと自分のIDを追加
    targetUserIdList
      ..addAll(followingIdList)
      ..add(userId);

    // ミュートしているユーザーのIDを除外
    final mutedUserIdList = await _fetchMutedUserIdList();
    targetUserIdList.removeWhere(mutedUserIdList.contains);

    return ref
        .read(definitionRepositoryProvider)
        .fetchHomeFollowingDefinitionIdListFirst(targetUserIdList);
  }

  /// DefinitionIdのListを追加で取得し、stateを更新する
  Future<void> fetchMore() async {
    // これ以上取得できるDefinitionIdがない場合、何もしない
    if (!state.value!.hasMore) {
      return;
    }

    // ローディング中の場合、何もしない
    if (state.isLoading || state.isRefreshing) {
      return;
    }

    // 取得済みのデータを保持しながら状態をローディング中にする
    // これにより、asyncValue.isRefreshingがtrueになる
    // 参考: https://www.zeroichi.biz/blog/1525/
    state = const AsyncLoading<DefinitionIdListState>().copyWithPrevious(state);

    try {
      late final DefinitionIdListState tmpState;
      switch (definitionFeedType) {
        case DefinitionFeedType.homeRecommend:
          tmpState = await _homeRecommendDefinitionIdListMore();
          break;

        case DefinitionFeedType.homeFollowing:
          tmpState = await _fetchHomeFollowingDefinitionIdListMore();
          break;
      }

      final nextState = DefinitionIdListState(
        definitionIdList:
            state.value!.definitionIdList + tmpState.definitionIdList,
        lastReadQueryDocumentSnapshot: tmpState.lastReadQueryDocumentSnapshot,
        hasMore: tmpState.hasMore,
      );
      state = AsyncData(nextState);
    } on Exception catch (e, s) {
      debugPrint('error: $e');
      ref
          .read(snackBarControllerProvider.notifier)
          .showSnackBar('読み込めませんでした。もう一度お試しください。');

      state = AsyncError(e, s);
    }
  }

  /// 「ホーム画面: おすすめタブ」で表示するDefinitionIDのListを取得する（2回目以降）
  Future<DefinitionIdListState> _homeRecommendDefinitionIdListMore() async {
    final mutedUserIdList = await _fetchMutedUserIdList();

    return ref
        .watch(definitionRepositoryProvider)
        .fetchHomeRecommendDefinitionIdListMore(
          mutedUserIdList,
          state.value!.lastReadQueryDocumentSnapshot,
        );
  }

  /// 「ホーム画面: フォロー中タブ」で表示するDefinitionIDのListを取得する（2回目以降）
  // TODO(me): _fetchHomeFollowingDefinitionIdListFirstと共通のロジックが多く、リファクタの余地あり
  Future<DefinitionIdListState>
      _fetchHomeFollowingDefinitionIdListMore() async {
    final userId = (await ref.read(userIdProvider.future))!;

    final targetUserIdList = <String>[];

    // フォローしているユーザーのIDリストを取得
    final followingIdList = await ref
        .watch(userProfileRepositoryProvider)
        .fetchFollowingIdList(userId);

    // フォローしているユーザーと自分のIDを追加
    targetUserIdList
      ..addAll(followingIdList)
      ..add(userId);

    // ミュートしているユーザーのIDを除外
    final mutedUserIdList = await _fetchMutedUserIdList();
    targetUserIdList.removeWhere(mutedUserIdList.contains);

    return ref
        .read(definitionRepositoryProvider)
        .fetchHomeFollowingDefinitionIdListMore(
          targetUserIdList,
          state.value!.lastReadQueryDocumentSnapshot,
        );
  }

  // auth系の実装したら、userProfileDocを保持するProviderを作ると思われる
  // その場合、この関数は不要になる
  Future<List<String>> _fetchMutedUserIdList() async {
    final userId = (await ref.read(userIdProvider.future))!;
    final userProfileDoc =
        await ref.read(userConfigRepositoryProvider).fetchUserConfig(userId);

    return userProfileDoc.mutedUserIdList;
  }
}
