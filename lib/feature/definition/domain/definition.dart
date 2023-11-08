import 'package:freezed_annotation/freezed_annotation.dart';

import 'definition_for_write.dart';

part 'definition.freezed.dart';

@freezed
class Definition with _$Definition {
  const factory Definition({
    required String id,
    required String wordId,
    required String word,
    required String wordReading,
    required String authorId,
    required String authorName,
    required String authorImageUrl,
    required String definition,
    required bool isPublic,
    required int likesCount,
    required bool isLikedByUser,
    required DateTime createdAt,
  }) = _Definition;
  const Definition._();

  DefinitionForWrite toDefinitionForWrite() {
    return DefinitionForWrite(
      id: id,
      word: word,
      wordReading: wordReading,
      isPublic: isPublic,
      definition: definition,
    );
  }
}
