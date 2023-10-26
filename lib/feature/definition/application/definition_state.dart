import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../auth/application/auth_state.dart';
import '../../user_profile/repository/user_profile_repository.dart';
import '../../word/repository/word_repository.dart';
import '../domain/definition.dart';
import '../repository/definition_repository.dart';

part 'definition_state.g.dart';

@Riverpod(keepAlive: true)
Future<Definition> definition(DefinitionRef ref, String definitionId) async {
  final userId = ref.read(userIdProvider)!;

  final definitionDoc = await ref
      .read(definitionRepositoryProvider)
      .fetchDefinition(definitionId);

  final wordDoc =
      await ref.read(wordRepositoryProvider).fetchWord(definitionDoc.wordId);

  final authorDoc = await ref
      .read(userProfileRepositoryProvider)
      .fetchUserProfile(definitionDoc.authorId);

  final isLikedByUser = await ref
      .read(definitionRepositoryProvider)
      .isLikedByUser(userId, definitionDoc.id);

  return Definition(
    id: definitionDoc.id,
    wordId: wordDoc.id,
    authorId: authorDoc.id,
    word: wordDoc.word,
    definition: definitionDoc.content,
    createdAt: definitionDoc.createdAt,
    updatedAt: definitionDoc.updatedAt,
    authorName: authorDoc.name,
    authorImageUrl: authorDoc.profileImageUrl,
    likesCount: definitionDoc.likesCount,
    isLikedByUser: isLikedByUser,
  );
}
