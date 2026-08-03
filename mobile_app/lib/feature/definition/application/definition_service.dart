import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/analytics/analytics_event.dart';
import '../../../core/analytics/analytics_service.dart';
import '../../definition_list/application/definition_list_state.dart';
import '../../timeline/application/discover_timeline_state.dart';
import '../../word/application/word_state.dart';
import '../../word_list/application/community_dictionary_index_list_state.dart';
import '../../word_list/application/user_dictionary_index_list_state.dart';
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

    await ref
        .read(analyticsServiceProvider)
        .logEvent(
          AnalyticsEvent.definitionDeleted,
          parameters: {
            AnalyticsParam.definitionId: definition.id,
            AnalyticsParam.wordId: definition.wordId,
            AnalyticsParam.wasPublic: definition.isPublic,
          },
        );

    ref
      ..invalidate(definitionListStateNotifierProvider)
      ..invalidate(discoverTimelineStateNotifierProvider)
      ..invalidate(wordListStateBySearchWordNotifierProvider)
      ..invalidate(userDictionaryIndexListStateNotifierProvider)
      ..invalidate(communityDictionaryIndexListStateNotifierProvider)
      ..invalidate(wordProvider(definition.wordId));
  }

  Future<void> updatePostType(Definition definition) async {
    final isPublic = !definition.isPublic;
    await ref
        .read(writeDefinitionRepositoryProvider)
        .updatePostType(definitionId: definition.id, isPublic: isPublic);

    await ref
        .read(analyticsServiceProvider)
        .logEvent(
          AnalyticsEvent.definitionVisibilityChanged,
          parameters: {
            AnalyticsParam.definitionId: definition.id,
            AnalyticsParam.wordId: definition.wordId,
            AnalyticsParam.isPublic: isPublic,
          },
        );

    ref.refreshDefinition(definition.id);
  }
}
