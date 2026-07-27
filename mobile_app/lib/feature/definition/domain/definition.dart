import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:teigiii_api/teigiii_api.dart';

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
    required String? authorImageUrl,
    required String definition,
    required bool isPublic,
    required int likesCount,
    required bool isLikedByUser,
    required DateTime createdAt,
  }) = _Definition;

  /// API の [DefinitionResponse] から [Definition] を組み立てる。
  ///
  /// 定義単体取得とタイムライン取得で同じマッピングを使うため、
  /// 変換ロジックはここに集約する。
  factory Definition.fromResponse(DefinitionResponse response) => Definition(
    id: response.id,
    wordId: response.word.id,
    word: response.word.word,
    wordReading: response.word.reading,
    authorId: response.author.id,
    authorName: response.author.name,
    authorImageUrl: response.author.avatarUrl,
    definition: response.body,
    isPublic: response.status == DefinitionStatus.public,
    likesCount: response.likesCount,
    isLikedByUser: response.isLikedByMe,
    createdAt: response.createdAt,
  );

  const Definition._();

  DefinitionForWrite toDefinitionForWrite() {
    return DefinitionForWrite(
      id: id,
      authorId: authorId,
      word: word,
      wordReading: wordReading,
      isPublic: isPublic,
      definition: definition,
    );
  }
}
