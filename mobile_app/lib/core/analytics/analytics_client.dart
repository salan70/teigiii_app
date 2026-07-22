import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../common_provider/firebase_providers.dart';

part 'analytics_client.g.dart';

/// Analytics 送信クライアント。
///
/// 本番は Firebase、テストは Fake / Mock で差し替える。
abstract class AnalyticsClient {
  Future<void> logEvent(String name, {Map<String, Object>? parameters});

  Future<void> logScreenView({required String screenName, String? screenClass});

  Future<void> setUserId(String? userId);
}

class FirebaseAnalyticsClient implements AnalyticsClient {
  FirebaseAnalyticsClient(this._analytics);

  final FirebaseAnalytics _analytics;

  /// Firebase は bool パラメータを受け付けないため 1/0 に変換する。
  static Map<String, Object>? normalizeParameters(
    Map<String, Object>? parameters,
  ) {
    if (parameters == null) {
      return null;
    }
    return {
      for (final entry in parameters.entries)
        entry.key: entry.value is bool
            ? ((entry.value as bool) ? 1 : 0)
            : entry.value,
    };
  }

  @override
  Future<void> logEvent(String name, {Map<String, Object>? parameters}) {
    return _analytics.logEvent(
      name: name,
      parameters: normalizeParameters(parameters),
    );
  }

  @override
  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) {
    return _analytics.logScreenView(
      screenName: screenName,
      screenClass: screenClass,
    );
  }

  @override
  Future<void> setUserId(String? userId) {
    return _analytics.setUserId(id: userId);
  }
}

@Riverpod(keepAlive: true)
AnalyticsClient analyticsClient(AnalyticsClientRef ref) =>
    FirebaseAnalyticsClient(ref.watch(firebaseAnalyticsProvider));
