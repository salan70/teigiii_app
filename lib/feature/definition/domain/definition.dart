import 'package:freezed_annotation/freezed_annotation.dart';

part 'definition.freezed.dart';

@freezed
class Definition with _$Definition {
  const factory Definition({
    required String id,
    required String wordId,
    required String authorId,
    required String word,
    required String definition,
    required DateTime createdAt,
    required DateTime updatedAt,
    required String authorName,
    required String authorImageUrl,
    required int likesCount,
    required bool isLikedByUser,
  }) = _Definition;
}
