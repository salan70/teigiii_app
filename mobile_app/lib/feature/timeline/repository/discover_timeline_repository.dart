import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:teigiii_api/teigiii_api.dart';

import '../../../core/api/api_exception.dart';
import '../../../core/api/api_providers.dart';
import '../../definition/repository/definition_response_mapper.dart';
import '../domain/discover_feed_entry.dart';
import '../domain/discover_feed_list_state.dart';
import '../domain/registered_word_activity.dart';

part 'discover_timeline_repository.g.dart';

@riverpod
DiscoverTimelineRepository discoverTimelineRepository(
  DiscoverTimelineRepositoryRef ref,
) => DiscoverTimelineRepository(ref.watch(teigiiiApiProvider).getTimelineApi());

/// API レスポンスの言葉登録アクティビティを domain の型へ変換する。
RegisteredWordActivity registeredWordActivityFromResponse(
  WordRegisteredActivity activity,
) => RegisteredWordActivity(
  wordId: activity.word.id,
  word: activity.word.word,
  reading: activity.word.reading,
  occurredAt: activity.occurredAt,
);

/// おすすめタイムライン（定義 + 言葉登録 mixed）を取得する Repository。
class DiscoverTimelineRepository {
  DiscoverTimelineRepository(this._timelineApi);

  final TimelineApi _timelineApi;

  Future<DiscoverFeedListState> fetchDiscoverTimeline(String? cursor) async {
    try {
      final response = await _timelineApi.v1TimelineDiscoverGet(
        cursor: cursor,
        // type フィルタなし → 定義 + 言葉登録を両方取得
      );
      final page = response.data!;
      return DiscoverFeedListState(
        list: page.items.map(_toEntry).whereType<DiscoverFeedEntry>().toList(),
        nextCursor: page.nextCursor,
        hasMore: page.nextCursor != null,
      );
    } on DioException catch (exception) {
      throw ApiException.fromDioException(exception);
    }
  }

  /// 未知の種別（クライアントより新しいサーバーが返しうる）は null にして捨てる。
  DiscoverFeedEntry? _toEntry(DiscoverFeedItem item) {
    if (item is DiscoverFeedDefinitionItem) {
      return DiscoverFeedEntry.definition(
        definitionFromResponse(item.activity.definition),
      );
    }
    if (item is DiscoverFeedWordRegisteredItem) {
      return DiscoverFeedEntry.wordRegistered(
        registeredWordActivityFromResponse(item.activity),
      );
    }
    return null;
  }
}
