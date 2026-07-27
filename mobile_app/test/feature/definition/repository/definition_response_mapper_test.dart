import 'package:flutter_test/flutter_test.dart';
import 'package:teigi_app/feature/definition/repository/definition_response_mapper.dart';
import 'package:teigiii_api/teigiii_api.dart';

void main() {
  DefinitionResponse buildResponse({
    required DefinitionStatus status,
    String? avatarUrl = 'https://api.example.com/v1/avatars/user1',
  }) {
    return DefinitionResponse(
      id: 'definition1',
      word: WordSummary(id: 'word1', word: '二日目のカレー', reading: 'ふつかめのかれー'),
      author: UserSummary(
        id: 'user1',
        publicId: '123456789',
        name: 'テスト太郎',
        avatarUrl: avatarUrl,
      ),
      body: '作ってから一晩経ったカレー。',
      status: status,
      isEdited: false,
      likesCount: 5,
      isLikedByMe: true,
      finalizedAt: DateTime.utc(2026, 7),
      editableUntil: DateTime.utc(2026, 7, 1, 1),
      createdAt: DateTime.utc(2026, 7),
      updatedAt: DateTime.utc(2026, 7, 2),
    );
  }

  group('definitionFromResponse', () {
    test('全フィールドを DefinitionResponse からマッピングする', () {
      // * Act
      final definition = definitionFromResponse(
        buildResponse(status: DefinitionStatus.public),
      );

      // * Assert
      expect(definition.id, 'definition1');
      expect(definition.wordId, 'word1');
      expect(definition.word, '二日目のカレー');
      expect(definition.wordReading, 'ふつかめのかれー');
      expect(definition.authorId, 'user1');
      expect(definition.authorName, 'テスト太郎');
      expect(
        definition.authorImageUrl,
        'https://api.example.com/v1/avatars/user1',
      );
      expect(definition.definition, '作ってから一晩経ったカレー。');
      expect(definition.isPublic, isTrue);
      expect(definition.likesCount, 5);
      expect(definition.isLikedByUser, isTrue);
      expect(definition.createdAt, DateTime.utc(2026, 7));
    });

    test('avatarUrl が null の場合 authorImageUrl も null になる', () {
      // * Act
      final definition = definitionFromResponse(
        buildResponse(status: DefinitionStatus.public, avatarUrl: null),
      );

      // * Assert
      expect(definition.authorImageUrl, isNull);
    });

    test('status が public の場合のみ isPublic が true になる', () {
      // * Act & Assert
      expect(
        definitionFromResponse(
          buildResponse(status: DefinitionStatus.public),
        ).isPublic,
        isTrue,
      );
      expect(
        definitionFromResponse(
          buildResponse(status: DefinitionStatus.private),
        ).isPublic,
        isFalse,
      );
      expect(
        definitionFromResponse(
          buildResponse(status: DefinitionStatus.draft),
        ).isPublic,
        isFalse,
      );
    });
  });
}
