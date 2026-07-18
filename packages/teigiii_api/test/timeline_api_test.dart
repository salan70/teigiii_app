import 'package:test/test.dart';
import 'package:teigiii_api/teigiii_api.dart';

/// tests for TimelineApi
void main() {
  final instance = TeigiiiApi().getTimelineApi();

  group(TimelineApi, () {
    // 見つける（公開定義 + 言葉登録の混在フィード・完全な新着順）
    //
    // ミュート中ユーザーの活動は除外する。
    //
    //Future<V1TimelineDiscoverGet200Response> v1TimelineDiscoverGet({ String cursor, int limit }) async
    test('test v1TimelineDiscoverGet', () async {
      // TODO
    });

    // フォロー中（公開定義のみ・完全な新着順）
    //
    // ミュート中ユーザーの活動は除外する。
    //
    //Future<V1UsersIdDefinitionsGet200Response> v1TimelineFollowingGet({ String cursor, int limit }) async
    test('test v1TimelineFollowingGet', () async {
      // TODO
    });
  });
}
