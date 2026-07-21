import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../util/mixin/fetch_more_mixin.dart';
import '../domain/user_search_result_state.dart';
import '../repository/user_search_repository.dart';

part 'user_search_state.g.dart';

@riverpod
Future<String?> userIdSearchByPublicId(
  UserIdSearchByPublicIdRef ref,
  String publicId,
) async {
  return ref.read(userSearchRepositoryProvider).searchByPublicId(publicId);
}

@Riverpod(keepAlive: true)
class UserSearchResultNotifier extends _$UserSearchResultNotifier
    with FetchMoreMixin<UserSearchResultState> {
  @override
  FutureOr<UserSearchResultState> build(String query) => _fetch(true);

  Future<UserSearchResultState> _fetch(bool first) => ref
      .read(userSearchRepositoryProvider)
      .search(query, first ? null : state.value!.nextCursor);

  Future<void> fetchMore() async {
    await fetchMoreHelper(
      ref: ref,
      fetchFunction: () => _fetch(false),
      mergeFunction: (current, next) => UserSearchResultState(
        list: current.list + next.list,
        nextCursor: next.nextCursor,
        hasMore: next.hasMore,
      ),
    );
  }
}
