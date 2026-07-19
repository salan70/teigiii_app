import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../util/constant/initial_main_group.dart';
import '../../../util/mixin/fetch_more_mixin.dart';
import '../domain/definition_id_list_state.dart';
import '../repository/definition_id_list_repository.dart';
import '../util/definition_feed_type.dart';

part 'definition_id_list_state.g.dart';

@Riverpod(keepAlive: true)
class DefinitionIdListStateNotifier extends _$DefinitionIdListStateNotifier
    with FetchMoreMixin<DefinitionIdListState> {
  @override
  FutureOr<DefinitionIdListState> build(
    DefinitionFeedType definitionFeedType, {
    String? wordId,
    String? targetUserId,
    InitialSubGroup? initialSubGroup,
  }) => _fetchBasedOnType(isFirstFetch: true);

  String? _cursor(bool isFirstFetch) =>
      isFirstFetch ? null : state.value?.nextCursor;

  Future<DefinitionIdListState> _fetchForHomeRecommend({
    required bool isFirstFetch,
  }) => ref
      .read(definitionIdListRepositoryProvider)
      .fetchForHomeRecommend(_cursor(isFirstFetch));

  Future<DefinitionIdListState> _fetchForHomeFollowing({
    required bool isFirstFetch,
  }) => ref
      .read(definitionIdListRepositoryProvider)
      .fetchForHomeFollowing(_cursor(isFirstFetch));

  Future<DefinitionIdListState> _fetchForWordTop(
    WordTopOrderByType orderByType, {
    required bool isFirstFetch,
  }) {
    final id = wordId;
    if (id == null) {
      throw ArgumentError('wordIdがnullです');
    }
    return ref
        .read(definitionIdListRepositoryProvider)
        .fetchForWordTop(orderByType, id, _cursor(isFirstFetch));
  }

  Future<DefinitionIdListState> _fetchForProfileCreatedAt({
    required bool isFirstFetch,
  }) {
    final id = targetUserId;
    if (id == null) {
      throw ArgumentError('targetUserIdがnullです');
    }
    return ref
        .read(definitionIdListRepositoryProvider)
        .fetchForProfileCreatedAt(id, _cursor(isFirstFetch));
  }

  Future<DefinitionIdListState> _fetchForProfileLiked({
    required bool isFirstFetch,
  }) {
    final id = targetUserId;
    if (id == null) {
      throw ArgumentError('targetUserIdがnullです');
    }
    return ref
        .read(definitionIdListRepositoryProvider)
        .fetchForLikedByUser(id, _cursor(isFirstFetch));
  }

  Future<DefinitionIdListState> _fetchForIndividualDictionary({
    required bool isFirstFetch,
  }) {
    final userId = targetUserId;
    final subGroup = initialSubGroup;
    if (userId == null) {
      throw ArgumentError('targetUserIdがnullです');
    }
    if (subGroup == null) {
      throw ArgumentError('initialSubGroupがnullです');
    }
    return ref
        .read(definitionIdListRepositoryProvider)
        .fetchForIndividualDictionary(userId, subGroup, _cursor(isFirstFetch));
  }

  Future<void> fetchMore() async {
    await fetchMoreHelper(
      ref: ref,
      fetchFunction: () => _fetchBasedOnType(isFirstFetch: false),
      mergeFunction: (currentData, newData) => DefinitionIdListState(
        list: currentData.list + newData.list,
        nextCursor: newData.nextCursor,
        hasMore: newData.hasMore,
      ),
    );
  }

  Future<DefinitionIdListState> _fetchBasedOnType({
    required bool isFirstFetch,
  }) {
    switch (definitionFeedType) {
      case DefinitionFeedType.homeRecommend:
        return _fetchForHomeRecommend(isFirstFetch: isFirstFetch);
      case DefinitionFeedType.homeFollowing:
        return _fetchForHomeFollowing(isFirstFetch: isFirstFetch);
      case DefinitionFeedType.wordTopOrderByCreatedAt:
        return _fetchForWordTop(
          WordTopOrderByType.createdAt,
          isFirstFetch: isFirstFetch,
        );
      case DefinitionFeedType.wordTopOrderByLikesCount:
        return _fetchForWordTop(
          WordTopOrderByType.likesCount,
          isFirstFetch: isFirstFetch,
        );
      case DefinitionFeedType.profileOrderByCreatedAt:
        return _fetchForProfileCreatedAt(isFirstFetch: isFirstFetch);
      case DefinitionFeedType.profileLiked:
        return _fetchForProfileLiked(isFirstFetch: isFirstFetch);
      case DefinitionFeedType.individualIndex:
        return _fetchForIndividualDictionary(isFirstFetch: isFirstFetch);
    }
  }
}
