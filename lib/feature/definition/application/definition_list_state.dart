import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../user/repository/user_repository.dart';
import '../repository/definition_repository.dart';
import '../util/definition_feed_type.dart';

part 'definition_list_state.g.dart';

@Riverpod(keepAlive: true)
class DefinitionListNotifier extends _$DefinitionListNotifier {
  @override
  FutureOr<List<String>> build(
    DefinitionFeedType definitionFeedType,
  ) async {
    switch (definitionFeedType) {
      case DefinitionFeedType.homeRecommend:
        return await _homeRecommendDefinitionIdList();
      case DefinitionFeedType.homeFollowing:
        return await _fetchHomeFollowingDefinitionIdList();
    }
  }

  Future<List<String>> _homeRecommendDefinitionIdList() async {
    final mutedUserIdList = await _fetchMutedUserIdList();

    return ref
        .watch(definitionRepositoryProvider)
        .fetchHomeRecommendDefinitionIdListFirst(mutedUserIdList);
  }

  Future<List<String>> _fetchHomeFollowingDefinitionIdList() async {
    // TODO(me): auth系の実装したらFirebaseからuserIdを取得する
    const userId = 'xE9Je2LljHXIPORKyDnk';

    final targetUserIdList = <String>[];

    // フォローしているユーザーのIDリストを取得
    final followingIdList =
        await ref.watch(userRepositoryProvider).fetchFollowingIdList(userId);

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

  // auth系の実装したら、userDocを保持するProviderを作ると思われる
  // その場合、この関数は不要になる
  Future<List<String>> _fetchMutedUserIdList() async {
    // TODO(me): auth系の実装したらFirebaseからuserIdを取得する
    const userId = 'xE9Je2LljHXIPORKyDnk';
    final userDoc = await ref.read(userRepositoryProvider).fetchUser(userId);

    return userDoc.mutedUserIdList;
  }
}
