import 'package:teigiii_api/teigiii_api.dart';

import '../domain/definition.dart';

/// API の [DefinitionResponse] から [Definition] への変換。
///
/// 定義単体取得とタイムライン取得で同じマッピングを使うため、
/// 変換ロジックは repository 層に集約する。
/// domain は Freezed のみに依存する規約を守る。
Definition definitionFromResponse(DefinitionResponse response) => Definition(
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
