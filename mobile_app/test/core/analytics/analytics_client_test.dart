import 'package:flutter_test/flutter_test.dart';
import 'package:teigi_app/core/analytics/analytics_client.dart';
import 'package:teigi_app/core/analytics/analytics_event.dart';
import 'package:teigi_app/core/analytics/analytics_link_type.dart';
import 'package:teigi_app/util/constant/url.dart';

void main() {
  group('FirebaseAnalyticsClient.normalizeParameters', () {
    test('bool を 1/0 に変換する', () {
      expect(
        FirebaseAnalyticsClient.normalizeParameters({
          AnalyticsParam.isPublic: true,
          AnalyticsParam.wasPublic: false,
          AnalyticsParam.definitionId: 'id-1',
        }),
        {
          AnalyticsParam.isPublic: 1,
          AnalyticsParam.wasPublic: 0,
          AnalyticsParam.definitionId: 'id-1',
        },
      );
    });

    test('null はそのまま null', () {
      expect(FirebaseAnalyticsClient.normalizeParameters(null), isNull);
    });
  });

  group('inferAnalyticsLinkType', () {
    test('URL 定数から link_type を推定する', () {
      expect(inferAnalyticsLinkType(howToPageUrl), AnalyticsLinkType.howTo);
      expect(inferAnalyticsLinkType(termPageUrl), AnalyticsLinkType.terms);
      expect(
        inferAnalyticsLinkType(privacyPolicyPageUrl),
        AnalyticsLinkType.privacy,
      );
      expect(
        inferAnalyticsLinkType(appStoreUrl),
        AnalyticsLinkType.storeListing,
      );
      expect(
        inferAnalyticsLinkType(inquireFormUrl('123')),
        AnalyticsLinkType.inquiry,
      );
    });

    test('明示指定が優先される', () {
      expect(
        inferAnalyticsLinkType(
          appStoreUrl,
          explicitLinkType: AnalyticsLinkType.forceUpdateStore,
        ),
        AnalyticsLinkType.forceUpdateStore,
      );
    });

    test('未知 URL は null', () {
      expect(inferAnalyticsLinkType('https://example.com'), isNull);
    });
  });
}
