import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/word.dart';
import '../repository/word_repository.dart';

part 'word_state.g.dart';

/// [wordId] に一致する [Word] を返す。
///
/// 該当する [Word] が見つからない場合、nullを返す。
@riverpod
Future<Word?> word(WordRef ref, String wordId) async {
  return ref.read(wordRepositoryProvider).fetchWordById(wordId);
}
