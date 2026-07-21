import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../definition_list/appication/definition_id_list_state.dart';
import '../../personal_dictionary/application/personal_dictionary_state.dart';
import '../../timeline/application/timeline_state.dart';
import '../../word/application/word_state.dart';
import '../../word_list/application/word_list_state_by_initial.dart';
import '../../word_list/application/word_list_state_by_search_word.dart';
import '../domain/definition.dart';
import '../repository/write_definition_repository.dart';
import 'definition_state.dart';

part 'definition_service.g.dart';

@riverpod
DefinitionService definitionService(DefinitionServiceRef ref) =>
    DefinitionService(ref);

class DefinitionService {
  DefinitionService(this.ref);

  final Ref ref;

  Future<void> deleteDefinition(Definition definition) async {
    await ref
        .read(writeDefinitionRepositoryProvider)
        .deleteDefinition(definition.id);

    ref
      ..invalidate(definitionIdListStateNotifierProvider)
      ..invalidate(discoverTimelineProvider)
      ..invalidate(definedWordListProvider)
      ..invalidate(personalDictionaryOverviewProvider)
      ..invalidate(wordListStateByInitialNotifierProvider)
      ..invalidate(wordListStateBySearchWordNotifierProvider)
      ..invalidate(wordProvider(definition.wordId));
  }

  Future<void> updatePostType(Definition definition) async {
    await ref
        .read(writeDefinitionRepositoryProvider)
        .updatePostType(
          definitionId: definition.id,
          isPublic: !definition.isPublic,
        );

    ref
      ..invalidate(definitionProvider(definition.id))
      ..invalidate(discoverTimelineProvider)
      ..invalidate(definedWordListProvider)
      ..invalidate(personalDictionaryOverviewProvider);
  }
}
