import 'package:flutter_test/flutter_test.dart';
import 'package:teigi_app/feature/definition/domain/definition.dart';

void main() {
  final definition = Definition(
    id: 'definition-id',
    wordId: 'word-id',
    word: '言葉',
    wordReading: 'ことば',
    authorId: 'user-id',
    authorName: 'user',
    authorImageUrl: null,
    definition: '本文',
    isPublic: true,
    likesCount: 0,
    isLikedByUser: false,
    editableUntil: DateTime.utc(2026, 7, 21, 1),
    createdAt: DateTime.utc(2026, 7, 21),
  );

  test('API の editableUntil より前だけ本文を編集できる', () {
    expect(definition.canEditAt(DateTime.utc(2026, 7, 21, 0, 59)), isTrue);
    expect(definition.canEditAt(DateTime.utc(2026, 7, 21, 1)), isFalse);
  });
}
