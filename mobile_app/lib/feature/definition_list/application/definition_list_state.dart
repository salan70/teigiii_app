import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../util/mixin/fetch_more_mixin.dart';
import '../../auth/application/auth_state.dart';
import '../../definition/application/definition_seed_store.dart';
import '../../definition/application/definition_state.dart';
import '../domain/definition_list_state.dart';
import '../repository/definition_list_repository.dart';
import '../util/definition_feed_type.dart';

part 'definition_list_state.g.dart';

/// 定義フィードの一覧 state。
///
/// keepAlive: ホームの TabBarView など、一時的に unwatch されても
/// 一覧・スクロール位置を維持するため。シード参照の解放は
/// [DefinitionSeedStore.releaseFeed]（dispose / 世代上限）で行う。
@Riverpod(keepAlive: true)
class DefinitionListStateNotifier extends _$DefinitionListStateNotifier
    with FetchMoreMixin<DefinitionListState> {
  @override
  FutureOr<DefinitionListState> build(
    DefinitionFeedType definitionFeedType, {
    String? wordId,
    String? targetUserId,
  }) {
    ref.watch(userIdProvider);
    // invalidate 時にシード参照を解放する（keepAlive でも invalidate では dispose する）。
    // store をキャプチャする。onDispose 内で ref.read すると
    // ProviderContainer.dispose 中に StateError になる。
    final store = ref.read(definitionSeedStoreProvider);
    final feedKey = _seedFeedKey;
    ref.onDispose(() => store.releaseFeed(feedKey));
    return _fetchAndSeed(isFirstFetch: true);
  }

  /// シードの世代キー。family の引数ごとに別フィードとして扱う。
  String get _seedFeedKey =>
      'definitionList:${definitionFeedType.name}:$wordId:$targetUserId';

  /// 一覧を取得し、含まれる定義を definitionSeedStore へ投入する。
  ///
  /// 一覧 API は定義本体を返すため、シードしておけば各 tile の
  /// `definitionProvider` が単体取得せずに済む（N+1 の解消）。
  Future<DefinitionListState> _fetchAndSeed({
    required bool isFirstFetch,
  }) async {
    final result = await _fetchBasedOnType(isFirstFetch: isFirstFetch);
    ref.seedDefinitions(
      feedKey: _seedFeedKey,
      definitions: result.list,
      isFirstFetch: isFirstFetch,
    );
    return result;
  }

  String? _cursor(bool isFirstFetch) =>
      isFirstFetch ? null : state.value!.nextCursor;

  Future<DefinitionListState> _fetchForHomeRecommend({
    required bool isFirstFetch,
  }) => ref
      .read(definitionListRepositoryProvider)
      .fetchForHomeRecommend(_cursor(isFirstFetch));

  Future<DefinitionListState> _fetchForHomeFollowing({
    required bool isFirstFetch,
  }) => ref
      .read(definitionListRepositoryProvider)
      .fetchForHomeFollowing(_cursor(isFirstFetch));

  Future<DefinitionListState> _fetchForWordTop(
    WordTopOrderByType orderByType, {
    required bool isFirstFetch,
  }) {
    final id = wordId;
    if (id == null) {
      throw ArgumentError('wordIdがnullです');
    }
    return ref
        .read(definitionListRepositoryProvider)
        .fetchForWordTop(orderByType, id, _cursor(isFirstFetch));
  }

  Future<DefinitionListState> _fetchForProfileCreatedAt({
    required bool isFirstFetch,
  }) {
    final id = targetUserId;
    if (id == null) {
      throw ArgumentError('targetUserIdがnullです');
    }
    return ref
        .read(definitionListRepositoryProvider)
        .fetchForProfileCreatedAt(id, _cursor(isFirstFetch));
  }

  Future<DefinitionListState> _fetchForProfileLiked({
    required bool isFirstFetch,
  }) {
    final id = targetUserId;
    if (id == null) {
      throw ArgumentError('targetUserIdがnullです');
    }
    return ref
        .read(definitionListRepositoryProvider)
        .fetchForLikedByUser(id, _cursor(isFirstFetch));
  }

  Future<DefinitionListState> _fetchForUserWord({required bool isFirstFetch}) {
    final userId = targetUserId;
    final id = wordId;
    if (userId == null) {
      throw ArgumentError('targetUserIdがnullです');
    }
    if (id == null) {
      throw ArgumentError('wordIdがnullです');
    }
    return ref
        .read(definitionListRepositoryProvider)
        .fetchForUserWord(userId, id, _cursor(isFirstFetch));
  }

  Future<void> fetchMore() async {
    await fetchMoreHelper(
      ref: ref,
      fetchFunction: () => _fetchAndSeed(isFirstFetch: false),
      mergeFunction: (currentData, newData) => DefinitionListState(
        list: currentData.list + newData.list,
        nextCursor: newData.nextCursor,
        hasMore: newData.hasMore,
      ),
    );
  }

  Future<DefinitionListState> _fetchBasedOnType({required bool isFirstFetch}) {
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
      case DefinitionFeedType.userWordDefinitions:
        return _fetchForUserWord(isFirstFetch: isFirstFetch);
    }
  }
}
