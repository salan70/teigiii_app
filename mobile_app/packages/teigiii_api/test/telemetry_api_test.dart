import 'package:test/test.dart';
import 'package:teigiii_api/teigiii_api.dart';

/// tests for TelemetryApi
void main() {
  final instance = TeigiiiApi().getTelemetryApi();

  group(TelemetryApi, () {
    // フレーム計測の集計を送信
    //
    // セッション単位で画面ごとに集計したフレーム統計を受け取る。Firebase ID トークン不要（App Check は必須）。app_config.perfTelemetryEnabled が false のときは 1 行も保存せず accepted=0 / disabled=true を返す。
    //
    //Future<FrameStatsAcceptedResponse> v1TelemetryFramesPost({ FrameStatsRequest frameStatsRequest }) async
    test('test v1TelemetryFramesPost', () async {
      // TODO
    });
  });
}
