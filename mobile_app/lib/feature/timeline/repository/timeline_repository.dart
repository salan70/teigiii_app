import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:teigiii_api/teigiii_api.dart';

import '../../../core/api/api_exception.dart';
import '../../../core/api/api_providers.dart';
import '../domain/timeline.dart';

part 'timeline_repository.g.dart';

@riverpod
TimelineRepository timelineRepository(TimelineRepositoryRef ref) =>
    TimelineRepository(ref.watch(teigiiiApiProvider).getTimelineApi());

/// 完全新着順の discover union を取得する API 境界。
///
/// @doc doc/specs/mobile-app-functional-spec.md#9-2-見つける
class TimelineRepository {
  TimelineRepository(this._api);

  final TimelineApi _api;

  Future<TimelinePage> fetchDiscover({String? cursor, int limit = 20}) async {
    try {
      final data = (await _api.v1TimelineDiscoverGet(
        cursor: cursor,
        limit: limit,
      )).data!;
      return TimelinePage(
        items: data.items.map<TimelineItem>((item) {
          return switch (item) {
            DiscoverFeedDefinitionItem(:final activity) =>
              TimelineDefinitionItem(activity.definition.id),
            DiscoverFeedWordRegisteredItem(:final activity) =>
              TimelineWordRegisteredItem(
                wordId: activity.word.id,
                word: activity.word.word,
                reading: activity.word.reading,
              ),
          };
        }).toList(),
        nextCursor: data.nextCursor,
      );
    } on DioException catch (exception) {
      throw ApiException.fromDioException(exception);
    }
  }
}
