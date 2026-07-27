import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../util/constant/initial_main_group.dart';
import '../../../util/mixin/fetch_more_mixin.dart';
import '../../word/domain/word.dart';
import '../domain/dictionary_index_entry.dart';
import '../domain/dictionary_index_list_state.dart';
import '../repository/fetch_word_list_repository.dart';

part 'community_dictionary_index_list_state.g.dart';

/// 言葉一覧を、セクションヘッダーを挟んだ表示用リストへ平坦化する。
List<DictionaryIndexEntry> buildIndexedList(List<Word> words) {
  // サーバーは scriptClass 順で返す前提だが、セクションヘッダー挿入の堅牢性のため
  // InitialMainGroup 順で再ソートする（クライアントとサーバーの並び定義は独立）。
  final sorted = [...words]
    ..sort((a, b) {
      final groupCompare = initialMainGroupFromReading(
        a.reading,
      ).index.compareTo(initialMainGroupFromReading(b.reading).index);
      if (groupCompare != 0) {
        return groupCompare;
      }
      final readingCompare = a.reading.compareTo(b.reading);
      if (readingCompare != 0) {
        return readingCompare;
      }
      return a.id.compareTo(b.id);
    });

  final out = <DictionaryIndexEntry>[];
  InitialMainGroup? last;
  for (final w in sorted) {
    final g = initialMainGroupFromReading(w.reading);
    if (g != last) {
      out.add(DictionaryIndexEntry.sectionHeader(g.sectionHeaderLabel));
      last = g;
    }
    out.add(DictionaryIndexEntry.word(w));
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
          // mergeFunction で allWords からヘッダー込みで作り直すため、
          // ここでは平坦化しない。
          list: page.list.map(DictionaryIndexEntry.word).toList(),
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
