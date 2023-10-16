import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../user/repository/user_repository.dart';
import '../../word/repository/word_repository.dart';
import '../domain/definition.dart';
import '../repository/definition_repository.dart';
import '../util/definition_feed_type.dart';

part 'definition_state.g.dart';

@Riverpod(keepAlive: true)
Future<Definition> definition(DefinitionRef ref, String definitionId) async {
  // TODO(me): auth系の実装したらFirebaseからuserIdを取得する
  const userId = 'xE9Je2LljHXIPORKyDnk';

  final definitionDoc = await ref
      .read(definitionRepositoryProvider)
      .fetchDefinition(definitionId);

  final wordDoc =
      await ref.read(wordRepositoryProvider).fetchWord(definitionDoc.wordId);

  final authorDoc =
      await ref.read(userRepositoryProvider).fetchUser(definitionDoc.authorId);

  final isLikedByUser = await ref
      .read(definitionRepositoryProvider)
      .isLikedByUser(userId, definitionDoc.id);

  return Definition(
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
  );
}

@Riverpod(keepAlive: true)
Future<List<String>> definitionIdList(
  DefinitionIdListRef ref,
  DefinitionFeedType definitionFeedType,
) async {
  switch (definitionFeedType) {
    case DefinitionFeedType.homeRecommend:
      return await ref.watch(_homeRecommendDefinitionIdListProvider.future);
    case DefinitionFeedType.homeFollowing:
      return await ref.watch(_homeFollowingDefinitionIdListProvider.future);
  }
}

@Riverpod(keepAlive: true)
Future<List<String>> _homeRecommendDefinitionIdList(
  _HomeRecommendDefinitionIdListRef ref,
) async {
  final mutedUserIdList = await ref.watch(_mutedUserIdListProvider.future);

  return ref
      .watch(definitionRepositoryProvider)
      .fetchHomeRecommendDefinitionIdList(mutedUserIdList);
}

@Riverpod(keepAlive: true)
Future<List<String>> _homeFollowingDefinitionIdList(
  _HomeFollowingDefinitionIdListRef ref,
) async {
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
  final mutedUserIdList = await ref.read(_mutedUserIdListProvider.future);
  targetUserIdList.removeWhere(mutedUserIdList.contains);

  return ref
      .read(definitionRepositoryProvider)
      .fetchHomeFollowingDefinitionList(targetUserIdList);
}

// auth系の実装したら、userDocを保持するProviderを作ると思われる
// その場合、このProviderは不要になる
@Riverpod(keepAlive: true)
Future<List<String>> _mutedUserIdList(_MutedUserIdListRef ref) async {
  // TODO(me): auth系の実装したらFirebaseからuserIdを取得する
  const userId = 'xE9Je2LljHXIPORKyDnk';
  final userDoc = await ref.read(userRepositoryProvider).fetchUser(userId);

  return userDoc.mutedUserIdList;
}
