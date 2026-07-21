import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:teigi_app/feature/timeline/domain/timeline.dart';
import 'package:teigi_app/feature/timeline/repository/timeline_repository.dart';
import 'package:teigiii_api/teigiii_api.dart';

import 'timeline_repository_test.mocks.dart';

@GenerateNiceMocks([MockSpec<TimelineApi>()])
void main() {
  test('discover は定義と言葉登録を順序どおり保持する', () async {
    final api = MockTimelineApi();
    final repository = TimelineRepository(api);
    final occurredAt = DateTime.utc(2026, 7, 21);
    when(api.v1TimelineDiscoverGet()).thenAnswer(
      (_) async => Response(
        data: V1TimelineDiscoverGet200Response(
          items: [
            DiscoverFeedDefinitionItem(
              DefinitionActivity(
                type: DefinitionActivityTypeEnum.definition,
                occurredAt: occurredAt,
                definition: DefinitionResponse.fromJson({
                  'id': 'definition-1',
                  'author': {
                    'id': 'user-1',
                    'publicId': 'user',
                    'name': 'User',
                    'bio': '',
                    'avatarUrl': null,
                    'followingCount': 0,
                    'followerCount': 0,
                    'isFollowedByMe': false,
                  },
                  'word': {'id': 'word-1', 'word': '愛', 'reading': 'あい'},
                  'body': '定義',
                  'status': 'public',
                  'createdAt': occurredAt.toIso8601String(),
                  'updatedAt': occurredAt.toIso8601String(),
                  'editableUntil': occurredAt.toIso8601String(),
                  'likesCount': 0,
                  'isLikedByMe': false,
                  'isEdited': false,
                  'finalizedAt': occurredAt.toIso8601String(),
                }),
              ),
            ),
            DiscoverFeedWordRegisteredItem(
              WordRegisteredActivity(
                type: WordRegisteredActivityTypeEnum.wordRegistered,
                occurredAt: occurredAt,
                word: WordSummary(id: 'word-2', word: '余白', reading: 'よはく'),
              ),
            ),
          ],
          nextCursor: 'next',
        ),
        requestOptions: RequestOptions(path: '/v1/timeline/discover'),
      ),
    );

    final page = await repository.fetchDiscover();

    expect(page.items[0], const TimelineDefinitionItem('definition-1'));
    expect(
      page.items[1],
      const TimelineWordRegisteredItem(
        wordId: 'word-2',
        word: '余白',
        reading: 'よはく',
      ),
    );
    expect(page.nextCursor, 'next');
  });
}
