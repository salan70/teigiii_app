import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../util/logger.dart';
import 'analytics_client.dart';

part 'analytics_service.g.dart';

@Riverpod(keepAlive: true)
AnalyticsService analyticsService(AnalyticsServiceRef ref) =>
    AnalyticsService(ref.watch(analyticsClientProvider));

/// Firebase Analytics への薄い facade。
///
/// Crashlytics 用 logger とは分離する。application 層からのみ呼び出す。
/// 計測失敗は業務処理へ伝播させない。
///
/// @doc doc/specs/analytics-events.md#概要
class AnalyticsService {
  AnalyticsService(this._client);

  final AnalyticsClient _client;

  Future<void> logEvent(String name, {Map<String, Object>? parameters}) async {
    try {
      await _client.logEvent(name, parameters: parameters);
    } on Exception catch (e, s) {
      logger.w('Analytics logEvent($name) に失敗しました。 error:$e, stackTrace:$s');
    }
  }

  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    try {
      await _client.logScreenView(
        screenName: screenName,
        screenClass: screenClass,
      );
    } on Exception catch (e, s) {
      logger.w(
        'Analytics logScreenView($screenName) に失敗しました。'
        ' error:$e, stackTrace:$s',
      );
    }
  }

  Future<void> setUserId(String? userId) async {
    try {
      await _client.setUserId(userId);
    } on Exception catch (e, s) {
      logger.w('Analytics setUserId に失敗しました。 error:$e, stackTrace:$s');
    }
  }
}
