import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../auth/application/auth_state.dart';
import '../../user_profile/repository/user_profile_repository.dart';
import '../../word/repository/word_repository.dart';
import '../domain/definition.dart';
import '../repository/fetch_definition_repository.dart';
import '../repository/write_definition_repository.dart';

part 'definition_state.g.dart';

@Riverpod(keepAlive: true)
Future<Definition> definition(DefinitionRef ref, String definitionId) async {
  final userId = ref.read(userIdProvider)!;

  final definitionDoc = await ref
      .read(fetchDefinitionRepositoryProvider)
      .fetchDefinition(definitionId);

  final wordDoc = await ref
      .read(wordRepositoryProvider)
      .fetchWordById(definitionDoc.wordId);

  final authorDoc = await ref
      .read(userProfileRepositoryProvider)
      .fetchUserProfile(definitionDoc.authorId);

  final isLikedByUser = await ref
      .read(writeDefinitionRepositoryProvider)
      .isLikedByUser(userId, definitionDoc.id);

  return Definition(
    id: definitionDoc.id,
    wordId: wordDoc.id,
    word: wordDoc.word,
    wordReading: wordDoc.reading,
    authorId: authorDoc.id,
    authorName: authorDoc.name,
    authorImageUrl: authorDoc.profileImageUrl,
    definition: definitionDoc.definition,
    likesCount: definitionDoc.likesCount,
    isPublic: definitionDoc.isPublic,
    isLikedByUser: isLikedByUser,
    createdAt: definitionDoc.createdAt,
  );
}
