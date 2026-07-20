import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../user_profile/application/user_profile_state.dart';
import '../domain/definition.dart';
import '../repository/fetch_definition_repository.dart';

part 'definition_state.g.dart';

@riverpod
Future<Definition> definition(DefinitionRef ref, String definitionId) async {
  final definition = await ref
      .read(fetchDefinitionRepositoryProvider)
      .fetchDefinition(definitionId);

  /// プロフィール更新に合わせて更新されるよう監視
  final userProfile = await ref.watch(
    userProfileProvider(definition.authorId).future,
  );

  return definition.copyWith(
    authorName: userProfile.name,
    authorImageUrl: userProfile.avatarUrl,
  );
}
