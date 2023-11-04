import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../util/logger.dart';
import '../../auth/application/auth_state.dart';
import '../domain/definition_for_write.dart';

part 'definition_for_write_notifier.g.dart';

@riverpod
class DefinitionForWriteNotifier extends _$DefinitionForWriteNotifier {
  @override
  FutureOr<DefinitionForWrite> build(String? definitionId) async {
    final currentUserId = ref.read(userIdProvider)!;
    return DefinitionForWrite(
      id: definitionId,
      authorId: currentUserId,
      wordId: '',
      word: '',
      wordReading: '',
      isPublic: true,
      definition: '',
    );
  }

  void changeWord(String word) {
    state = AsyncData(state.value!.copyWith(word: word));
  }

  void changeWordReading(String wordReading) {
    state = AsyncData(state.value!.copyWith(wordReading: wordReading));
  }

  void changePublicState({required bool isPublic}) {
    state = AsyncData(state.value!.copyWith(isPublic: isPublic));
  }

  void changeDefinition(String definition) {
    state = AsyncData(state.value!.copyWith(definition: definition));
  }

  Future<void> post() async {
    final definitionForWrite = state.value!;

    logger.d(definitionForWrite);

    // await ref
    //     .read(definitionRepositoryProvider)
    //     .postDefinition(definitionForWrite);
  }
}
