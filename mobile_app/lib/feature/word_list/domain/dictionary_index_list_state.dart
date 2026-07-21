import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../util/interface/list_state.dart';
import '../../word/domain/word.dart';

part 'dictionary_index_list_state.freezed.dart';

/// あかさたな連絡先風辞書リストの state。
///
/// [list] は String（セクションヘッダー）と [Word] が交互に並ぶ平坦化済みリスト。
/// [allWords] はページング結合用の生 Word リスト。
@freezed
class DictionaryIndexListState
    with _$DictionaryIndexListState
    implements ListState {
  const factory DictionaryIndexListState({
    required List<dynamic> list,
    required List<Word> allWords,
    required String? nextCursor,
    required bool hasMore,
  }) = _DictionaryIndexListState;
}
