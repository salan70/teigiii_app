import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../auth/application/auth_state.dart';
import '../../user_config/application/user_config_state.dart';
import '../../word/repository/word_repository.dart';
import '../domain/word.dart';

part 'word_state.g.dart';

@Riverpod(keepAlive: true)
Future<Word> word(WordRef ref, String wordId) async {
  final wordRepository = ref.read(wordRepositoryProvider);

  final wordDoc = await wordRepository.fetchWordById(wordId);

  final currentUserId = ref.read(userIdProvider)!;
  final mutedUserIdList = await ref.read(mutedUserIdListProvider.future);
  final postedDefinitionCount = await wordRepository.fetchPostedDefinitionCount(
    wordId,
    currentUserId,
    mutedUserIdList,
  );

  return Word(
    id: wordDoc.id,
    word: wordDoc.word,
    reading: wordDoc.reading,
    initialLetter: wordDoc.initialLetter,
    postedDefinitionCount: postedDefinitionCount,
  );
}
