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
