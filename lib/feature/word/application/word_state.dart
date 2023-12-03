import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../auth/application/auth_state.dart';
import '../../user_config/application/user_config_state.dart';
import '../../word/repository/word_repository.dart';
import '../../word_list/repository/fetch_word_list_repository.dart';
import '../domain/word.dart';

part 'word_state.g.dart';

/// [wordId] に一致する [Word] を返す。
///
/// 該当する [Word] が見つからない場合、nullを返す。
@riverpod
Future<Word?> word(WordRef ref, String wordId) async {
  final wordDoc = await ref.read(wordRepositoryProvider).fetchWordById(wordId);
  if (wordDoc == null) {
    return null;
  }

  final currentUserId = ref.read(userIdProvider)!;
  final mutedUserIdList = await ref.read(mutedUserIdListProvider.future);
  final postedDefinitionCount = await ref
      .read(fetchWordListRepositoryProvider)
      .fetchPostedDefinitionCount(
        wordId,
        currentUserId,
        mutedUserIdList,
      );

  /// 投稿された定義が0件の場合、 Word は存在しないとみなす。
  if (postedDefinitionCount == 0) {
    return null;
  }

  return Word(
    id: wordDoc.id,
    word: wordDoc.word,
    reading: wordDoc.reading,
    initialSubGroupLabel: wordDoc.initialSubGroupLabel,
    postedDefinitionCount: postedDefinitionCount,
  );
}
