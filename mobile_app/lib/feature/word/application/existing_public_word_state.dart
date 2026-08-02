import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../repository/word_repository.dart';

part 'existing_public_word_state.g.dart';

/// 登録前の既存語チェック。
///
/// (表記, よみ) が完全一致する公開済みの言葉があればその ID を、
/// なければ null を返す。判定キーが (表記, よみ) であるため、
/// どちらかが空のときは問い合わせない。
@riverpod
Future<String?> existingPublicWordId(
  ExistingPublicWordIdRef ref, {
  required String word,
  required String reading,
}) async {
  if (word.isEmpty || reading.isEmpty) {
    return null;
  }
  return ref
      .read(wordRepositoryProvider)
      .findPublicWordId(word: word, reading: reading);
}
