import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../util/constant/initial_main_group.dart';
import '../../../util/mixin/fetch_more_mixin.dart';
import '../../word/domain/word.dart';
import '../domain/dictionary_index_list_state.dart';
import '../repository/fetch_word_list_repository.dart';

part 'community_dictionary_index_list_state.g.dart';

List<dynamic> buildIndexedList(List<Word> words) {
  final out = <dynamic>[];
  InitialMainGroup? last;
  for (final w in words) {
    final g = initialMainGroupFromReading(w.reading);
    if (g != last) {
      out.add(g.sectionHeaderLabel);
      last = g;
    }
    out.add(w);
  }
  return out;
}

@Riverpod(keepAlive: true)
class CommunityDictionaryIndexListStateNotifier
    extends _$CommunityDictionaryIndexListStateNotifier
    with FetchMoreMixin<DictionaryIndexListState> {
  @override
  FutureOr<DictionaryIndexListState> build() async {
    final state = await ref
        .read(fetchWordListRepositoryProvider)
        .fetchCommunityWordList(null);
    return DictionaryIndexListState(
      list: buildIndexedList(state.list),
      allWords: state.list,
      nextCursor: state.nextCursor,
      hasMore: state.hasMore,
    );
  }

  Future<void> fetchMore() async {
    await fetchMoreHelper(
      ref: ref,
      fetchFunction: () async {
        final page = await ref
            .read(fetchWordListRepositoryProvider)
            .fetchCommunityWordList(state.value!.nextCursor);
        return DictionaryIndexListState(
          list: page.list,
          allWords: page.list,
          nextCursor: page.nextCursor,
          hasMore: page.hasMore,
        );
      },
      mergeFunction: (currentData, newData) {
        final allWords = currentData.allWords + newData.allWords;
        return DictionaryIndexListState(
          list: buildIndexedList(allWords),
          allWords: allWords,
          nextCursor: newData.nextCursor,
          hasMore: newData.hasMore,
        );
      },
    );
  }
}
