import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../user/repository/user_repository.dart';
import '../../word/repository/word_repository.dart';
import '../domain/definition.dart';
import '../repository/definition_repository.dart';
import '../repository/entity/definition_document.dart';
import '../util/definition_feed_type.dart';

part 'definition_list_state.g.dart';

@riverpod
class DefinitionListStateNotifier extends _$DefinitionListStateNotifier {
  // TODO(me): テスト書く
  @override
  FutureOr<List<Definition>> build(
    DefinitionFeedType definitionFeedType,
  ) async {
    switch (definitionFeedType) {
      case DefinitionFeedType.homeRecommend:
        return _fetchHomeRecommendDefinitionList();
      case DefinitionFeedType.homeFollowing:
        return _fetchHomeFollowingDefinitionList();
    }
  }

  /// ミュートしていないユーザーと
  /// 自分が投稿した公開中のDefinitionを取得する
  Future<List<Definition>> _fetchHomeRecommendDefinitionList() async {
    // TODO(me): auth系の実装したらFirebaseからuserIdを取得する
    const currentUserId = 'xE9Je2LljHXIPORKyDnk';
    final mutedUserIdList = await _fetchMutedUserIdList(currentUserId);

    final definitionDocList = await ref
        .read(definitionRepositoryProvider)
        .fetchHomeRecommendDefinitionList(
          definitionFeedType,
          mutedUserIdList,
        );

    return _fetchDefinitionList(currentUserId, definitionDocList);
  }

  /// フォローしている、かつミュートしていないユーザーと
  /// 自分が投稿した公開中のDefinitionを取得する
  Future<List<Definition>> _fetchHomeFollowingDefinitionList() async {
    // TODO(me): auth系の実装したらFirebaseからuserIdを取得する
    const currentUserId = 'LOAMQCoO4Dji5bvVpt4v';
    final targetUserIdList = await _fetchHomeFollowingUserIdList(currentUserId);

    final definitionDocList = await ref
        .read(definitionRepositoryProvider)
        .fetchHomeFollowingDefinitionList(
          definitionFeedType,
          targetUserIdList,
        );
    return _fetchDefinitionList(currentUserId, definitionDocList);
  }

  Future<List<String>> _fetchHomeFollowingUserIdList(
    String currentUserId,
  ) async {
    final followingTabUserIdList = <String>[];

    // フォローしているユーザーのIDリストを取得
    final followingIdList = await ref
        .read(userRepositoryProvider)
        .fetchFollowingIdList(currentUserId);

    // フォローしているユーザーと自分のIDを追加
    followingTabUserIdList
      ..addAll(followingIdList)
      ..add(currentUserId);

    // ミュートしているユーザーIDを除外
    final mutedUserIdList = await _fetchMutedUserIdList(currentUserId);
    followingTabUserIdList.removeWhere(mutedUserIdList.contains);

    return followingTabUserIdList;
  }

  Future<List<String>> _fetchMutedUserIdList(String currentUserId) async {
    final currentUserDoc =
        await ref.read(userRepositoryProvider).fetchUser(currentUserId);

    return currentUserDoc.mutedUserIdList;
  }

  Future<List<Definition>> _fetchDefinitionList(
    String currentUserId,
    List<DefinitionDocument> definitionDocList,
  ) async {
    final definitionList = <Definition>[];
    for (final definitionDoc in definitionDocList) {
      final wordDoc = await ref
          .read(wordRepositoryProvider)
          .fetchWord(definitionDoc.wordId);

      final authorDoc = await ref
          .read(userRepositoryProvider)
          .fetchUser(definitionDoc.authorId);

      final isLikedByUser = await ref
          .read(definitionRepositoryProvider)
          .isLikedByUser(currentUserId, definitionDoc.id);

      definitionList.add(
        Definition(
          id: definitionDoc.id,
          wordId: wordDoc.id,
          authorId: authorDoc.id,
          word: wordDoc.word,
          definition: definitionDoc.content,
          updatedAt: definitionDoc.updatedAt,
          authorName: authorDoc.name,
          authorImageUrl: authorDoc.profileImageUrl,
          likesCount: definitionDoc.likesCount,
          isLikedByUser: isLikedByUser,
        ),
      );
    }

    return definitionList;
  }
}
