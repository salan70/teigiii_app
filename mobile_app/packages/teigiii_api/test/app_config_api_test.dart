import 'package:test/test.dart';
import 'package:teigiii_api/teigiii_api.dart';

/// tests for AppConfigApi
void main() {
  final instance = TeigiiiApi().getAppConfigApi();

  group(AppConfigApi, () {
    // アプリ設定（強制アップデート・メンテナンス）を取得
    //
    // 起動時ポーリングで呼び出す。Firebase ID トークン不要（App Check は必須）。
    //
    //Future<AppConfigResponse> v1AppConfigGet() async
    test('test v1AppConfigGet', () async {
      // TODO
    });
  });
}
