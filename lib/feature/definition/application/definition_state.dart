import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../auth/application/auth_state.dart';
import '../../user_profile/application/user_profile_state.dart';
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

  /// プロフィール更新に合わせて更新されるよう監視
  final userProfile =
      await ref.watch(userProfileProvider(definitionDoc.authorId).future);

  final isLikedByUser = await ref
      .read(writeDefinitionRepositoryProvider)
      .isLikedByUser(userId, definitionDoc.id);

  return Definition(
    id: definitionDoc.id,
    wordId: definitionDoc.wordId,
    word: definitionDoc.word,
    wordReading: definitionDoc.wordReading,
    authorId: userProfile.id,
    authorName: userProfile.name,
    authorImageUrl: userProfile.profileImageUrl,
    definition: definitionDoc.definition,
    likesCount: definitionDoc.likesCount,
    isPublic: definitionDoc.isPublic,
    isLikedByUser: isLikedByUser,
    createdAt: definitionDoc.createdAt,
  );
}
