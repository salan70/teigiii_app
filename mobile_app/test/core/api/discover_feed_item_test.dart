import 'package:flutter_test/flutter_test.dart';
import 'package:teigiii_api/teigiii_api.dart';

Map<String, dynamic> definitionActivityJson() => {
  'type': 'definition',
  'occurredAt': '2026-07-18T00:00:00.000Z',
  'definition': {
    'id': 'def-1',
    'word': {'id': 'word-1', 'word': '定義', 'reading': 'ていぎ'},
    'author': {
      'id': 'user-1',
      'publicId': '123456789',
      'name': 'テストユーザー',
      'avatarUrl': null,
    },
    'body': '本文',
    'status': 'public',
    'isEdited': false,
    'likesCount': 0,
    'isLikedByMe': false,
    'finalizedAt': '2026-07-18T00:00:00.000Z',
    'editableUntil': '2026-07-18T01:00:00.000Z',
    'createdAt': '2026-07-18T00:00:00.000Z',
    'updatedAt': '2026-07-18T00:00:00.000Z',
  },
};

Map<String, dynamic> wordRegisteredActivityJson() => {
  'type': 'wordRegistered',
  'occurredAt': '2026-07-18T00:00:00.000Z',
  'word': {'id': 'word-2', 'word': '言葉', 'reading': 'ことば'},
};

void main() {
  test('definition バリアントをデシリアライズできる', () {
    final item = DiscoverFeedItem.fromJson(definitionActivityJson());

    expect(item, isA<DiscoverFeedDefinitionItem>());
    final activity = (item as DiscoverFeedDefinitionItem).activity;
    expect(activity.definition.id, 'def-1');
    expect(activity.definition.word.word, '定義');
  });

  test('wordRegistered バリアントをデシリアライズできる', () {
    final item = DiscoverFeedItem.fromJson(wordRegisteredActivityJson());

    expect(item, isA<DiscoverFeedWordRegisteredItem>());
    final activity = (item as DiscoverFeedWordRegisteredItem).activity;
    expect(activity.word.id, 'word-2');
  });

  test('未知の type は FormatException になる', () {
    expect(
      () => DiscoverFeedItem.fromJson(const {'type': 'unknown'}),
      throwsFormatException,
    );
  });

  test('toJson は元のバリアントの JSON を返す', () {
    final json = wordRegisteredActivityJson();

    final item = DiscoverFeedItem.fromJson(json);

    expect(item.toJson()['type'], 'wordRegistered');
    expect((item.toJson()['word'] as Map<String, dynamic>)['id'], 'word-2');
  });
}
