import '../../../util/interface/list_state.dart';
import 'public_dictionary.dart';

class PublicDictionaryState implements ListState {
  const PublicDictionaryState({
    required this.list,
    required this.nextCursor,
    required this.hasMore,
  });

  @override
  final List<PublicDictionaryItem> list;

  @override
  final String? nextCursor;

  @override
  final bool hasMore;
}
