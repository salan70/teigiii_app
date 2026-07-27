import 'package:freezed_annotation/freezed_annotation.dart';

import '../../word/domain/word.dart';

part 'dictionary_index_entry.freezed.dart';

/// あかさたな連絡先風辞書リストに並ぶ要素。
///
/// セクションヘッダーと言葉が混在するため sealed class で表現する。
@freezed
sealed class DictionaryIndexEntry with _$DictionaryIndexEntry {
  const factory DictionaryIndexEntry.sectionHeader(String label) =
      DictionaryIndexSectionHeader;

  const factory DictionaryIndexEntry.word(Word word) = DictionaryIndexWordEntry;
}
