import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../util/interface/list_state.dart';
import '../../word/domain/word.dart';

part 'word_list_state.freezed.dart';

@freezed
class WordListState with _$WordListState implements ListState {
  const factory WordListState({
    required List<Word> list,

    /// 最後に読み取られたQueryDocumentSnapshot
    /// これがnullの場合、1件もwordを取得していない（[wordList]が空）
    required QueryDocumentSnapshot? lastReadQueryDocumentSnapshot,
    required bool hasMore,
  }) = _WordListState;
}
