import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../util/interface/list_state.dart';
import '../../word/domain/word.dart';
import 'dictionary_index_entry.dart';

part 'dictionary_index_list_state.freezed.dart';

/// あかさたな連絡先風辞書リストの state。
///
/// [list] はセクションヘッダーと言葉が並ぶ平坦化済みリスト。
/// [allWords] はページング結合用の生 Word リスト。
@freezed
class DictionaryIndexListState
    with _$DictionaryIndexListState
    implements ListState<DictionaryIndexEntry> {
  const factory DictionaryIndexListState({
    required List<DictionaryIndexEntry> list,
    required List<Word> allWords,
    required String? nextCursor,
    required bool hasMore,
  }) = _DictionaryIndexListState;
}
