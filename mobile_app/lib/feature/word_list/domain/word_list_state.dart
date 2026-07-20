import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../util/interface/list_state.dart';
import '../../word/domain/word.dart';

part 'word_list_state.freezed.dart';

@freezed
class WordListState with _$WordListState implements ListState {
  const factory WordListState({
    required List<Word> list,
    required String? nextCursor,
    required bool hasMore,
  }) = _WordListState;
}
