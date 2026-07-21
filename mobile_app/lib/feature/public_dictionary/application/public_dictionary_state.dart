import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../util/mixin/fetch_more_mixin.dart';
import '../domain/public_dictionary_state.dart';
import '../repository/public_dictionary_repository.dart';

part 'public_dictionary_state.g.dart';

/// @doc doc/specs/mobile-app-functional-spec.md#12-公開プロフィール
@Riverpod(keepAlive: true)
class PublicDictionaryNotifier extends _$PublicDictionaryNotifier
    with FetchMoreMixin<PublicDictionaryState> {
  @override
  FutureOr<PublicDictionaryState> build(String userId) => _fetch(true);

  Future<PublicDictionaryState> _fetch(bool first) => ref
      .read(publicDictionaryRepositoryProvider)
      .fetch(userId, first ? null : state.value!.nextCursor);

  Future<void> fetchMore() async {
    await fetchMoreHelper(
      ref: ref,
      fetchFunction: () => _fetch(false),
      mergeFunction: (current, next) => PublicDictionaryState(
        list: current.list + next.list,
        nextCursor: next.nextCursor,
        hasMore: next.hasMore,
      ),
    );
  }
}
