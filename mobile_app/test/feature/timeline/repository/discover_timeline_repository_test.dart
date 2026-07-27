import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:teigi_app/core/api/api_exception.dart';
import 'package:teigi_app/feature/definition/repository/definition_response_mapper.dart';
import 'package:teigi_app/feature/timeline/domain/discover_feed_entry.dart';
import 'package:teigi_app/feature/timeline/repository/discover_timeline_repository.dart';
import 'package:teigiii_api/teigiii_api.dart';

import 'discover_timeline_repository_test.mocks.dart';

@GenerateNiceMocks([MockSpec<TimelineApi>()])
void main() {
  final mockTimelineApi = MockTimelineApi();
  final repository = DiscoverTimelineRepository(mockTimelineApi);

  tearDown(() => reset(mockTimelineApi));

  final definitionItem = DiscoverFeedDefinitionItem(
    DefinitionActivity(
      type: DefinitionActivityTypeEnum.definition,
      occurredAt: DateTime.utc(2026, 7, 18),
      definition: DefinitionResponse(
        id: 'definition1',
        word: WordSummary(id: 'word1', word: '二日目のカレー', reading: 'ふつかめのかれー'),
        author: UserSummary(
          id: 'user1',
          publicId: '123456789',
          name: 'テスト太郎',
          avatarUrl: 'https://api.example.com/v1/avatars/user1',
        ),
        body: '作ってから一晩経ったカレー。',
        status: DefinitionStatus.public,
        isEdited: false,
        likesCount: 5,
        isLikedByMe: true,
        finalizedAt: null,
        editableUntil: null,
        createdAt: DateTime.utc(2026, 7),
        updatedAt: DateTime.utc(2026, 7),
      ),
    ),
  );

  final wordRegisteredActivity = WordRegisteredActivity(
    type: WordRegisteredActivityTypeEnum.wordRegistered,
    occurredAt: DateTime.utc(2026, 7, 18),
    word: WordSummary(id: 'word2', word: '言葉', reading: 'ことば'),
  );

  group('fetchDiscoverTimeline', () {
    test('mixed レスポンスを Definition と WordRegisteredActivity に変換する', () async {
      // * Arrange
      when(mockTimelineApi.v1TimelineDiscoverGet()).thenAnswer(
        (_) async => Response(
          data: V1TimelineDiscoverGet200Response(
            items: [
              definitionItem,
              DiscoverFeedWordRegisteredItem(wordRegisteredActivity),
            ],
            nextCursor: 'cursor1',
          ),
          requestOptions: RequestOptions(path: '/v1/timeline/discover'),
        ),
      );

      // * Act
      final state = await repository.fetchDiscoverTimeline(null);

      // * Assert
      expect(state.list.length, 2);
      expect(
        state.list.first,
        DiscoverFeedEntry.definition(
          definitionFromResponse(definitionItem.activity.definition),
        ),
      );
      expect(
        state.list[1],
        DiscoverFeedEntry.wordRegistered(
          registeredWordActivityFromResponse(wordRegisteredActivity),
        ),
      );
      expect(state.nextCursor, 'cursor1');
      expect(state.hasMore, isTrue);
    });

    test('nextCursor が null の場合 hasMore が false になる', () async {
      // * Arrange
      when(mockTimelineApi.v1TimelineDiscoverGet(cursor: 'cursor1')).thenAnswer(
        (_) async => Response(
          data: V1TimelineDiscoverGet200Response(
            items: [definitionItem],
            nextCursor: null,
          ),
          requestOptions: RequestOptions(path: '/v1/timeline/discover'),
        ),
      );

      // * Act
      final state = await repository.fetchDiscoverTimeline('cursor1');

      // * Assert
      expect(state.hasMore, isFalse);
      expect(state.nextCursor, isNull);
    });

    test('エラーの場合 ApiException を投げる', () async {
      // * Arrange
      final requestOptions = RequestOptions(path: '/v1/timeline/discover');
      when(mockTimelineApi.v1TimelineDiscoverGet()).thenThrow(
        DioException(
          requestOptions: requestOptions,
          response: Response(
            statusCode: 500,
            data: {
              'error': {'code': 'internal_error', 'message': 'Internal error'},
            },
            requestOptions: requestOptions,
          ),
        ),
      );

      // * Act & Assert
      expect(
        () => repository.fetchDiscoverTimeline(null),
        throwsA(isA<ApiException>()),
      );
    });
  });
}
