import '../../util/constant/url.dart';
import 'analytics_event.dart';

/// URL から `external_link_opened` の `link_type` を推定する。
///
/// 未知の URL は null（イベント非送信）。
String? inferAnalyticsLinkType(String url, {String? explicitLinkType}) {
  if (explicitLinkType != null) {
    return explicitLinkType;
  }
  if (url == howToPageUrl) {
    return AnalyticsLinkType.howTo;
  }
  if (url == termPageUrl) {
    return AnalyticsLinkType.terms;
  }
  if (url == privacyPolicyPageUrl) {
    return AnalyticsLinkType.privacy;
  }
  if (url == appStoreUrl || url == googlePlayStoreUrl) {
    return AnalyticsLinkType.storeListing;
  }
  if (url.startsWith('https://docs.google.com/forms/')) {
    return AnalyticsLinkType.inquiry;
  }
  return null;
}
