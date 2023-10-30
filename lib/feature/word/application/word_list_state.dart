import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/word_list_state.dart';
import '../repository/word_repository.dart';

part 'word_list_state.g.dart';

@riverpod
class WordListStateNotifier extends _$WordListStateNotifier {
  @override
  FutureOr<WordListState> build(
    String initial,
  ) async {
    return await ref
        .read(wordRepositoryProvider)
        .fetchWordDocListByInitial(initial);
  }
}
