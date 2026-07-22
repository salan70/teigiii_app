import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'analytics_client.dart';

part 'analytics_service.g.dart';

/// Firebase Analytics への薄い facade。
///
/// Crashlytics 用 logger とは分離する。application 層からのみ呼び出す。
///
/// @doc doc/specs/analytics-events.md#概要
@Riverpod(keepAlive: true)
AnalyticsService analyticsService(AnalyticsServiceRef ref) =>
    AnalyticsService(ref.watch(analyticsClientProvider));

class AnalyticsService {
  AnalyticsService(this._client);

  final AnalyticsClient _client;

  Future<void> logEvent(String name, {Map<String, Object>? parameters}) {
    return _client.logEvent(name, parameters: parameters);
  }

  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) {
    return _client.logScreenView(
      screenName: screenName,
      screenClass: screenClass,
    );
  }

  Future<void> setUserId(String? userId) {
    return _client.setUserId(userId);
  }
}
