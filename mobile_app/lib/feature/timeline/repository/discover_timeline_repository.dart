import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:teigiii_api/teigiii_api.dart';

import '../../../core/api/api_exception.dart';
import '../../../core/api/api_providers.dart';
import '../../definition/domain/definition.dart';
import '../domain/discover_feed_list_state.dart';

part 'discover_timeline_repository.g.dart';

@riverpod
DiscoverTimelineRepository discoverTimelineRepository(
  DiscoverTimelineRepositoryRef ref,
) => DiscoverTimelineRepository(ref.watch(teigiiiApiProvider).getTimelineApi());

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
        list: page.items
            .map<dynamic>((item) {
              if (item is DiscoverFeedDefinitionItem) {
                return Definition.fromResponse(item.activity.definition);
              }
              if (item is DiscoverFeedWordRegisteredItem) {
                return item.activity;
              }
              return null;
            })
            .where((e) => e != null)
            .toList(),
        nextCursor: page.nextCursor,
        hasMore: page.nextCursor != null,
      );
    } on DioException catch (exception) {
      throw ApiException.fromDioException(exception);
    }
  }
}
