import '../../../util/interface/list_state.dart';
import 'user_search_result.dart';

class UserSearchResultState implements ListState {
  const UserSearchResultState({
    required this.list,
    required this.nextCursor,
    required this.hasMore,
  });

  @override
  final List<UserSearchResult> list;

  @override
  final String? nextCursor;

  @override
  final bool hasMore;
}
