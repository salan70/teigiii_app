import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teigi_app/core/analytics/analytics_client.dart';
import 'package:teigi_app/core/analytics/analytics_service.dart';

/// テスト用の Analytics 記録クライアント。
class FakeAnalyticsClient implements AnalyticsClient {
  final loggedEvents = <({String name, Map<String, Object>? parameters})>[];
  final screenViews = <String>[];
  final userIds = <String?>[];

  @override
  Future<void> logEvent(String name, {Map<String, Object>? parameters}) async {
    loggedEvents.add((name: name, parameters: parameters));
  }

  @override
  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    screenViews.add(screenName);
  }

  @override
  Future<void> setUserId(String? userId) async {
    userIds.add(userId);
  }
}

/// `analyticsClientProvider` / `analyticsServiceProvider` の override 用。
List<Override> analyticsTestOverrides([FakeAnalyticsClient? client]) {
  final fake = client ?? FakeAnalyticsClient();
  return [
    analyticsClientProvider.overrideWithValue(fake),
    analyticsServiceProvider.overrideWithValue(AnalyticsService(fake)),
  ];
}
