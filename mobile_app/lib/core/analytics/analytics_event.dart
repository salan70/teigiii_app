/// Analytics イベント名・パラメータキーの定数。
///
/// 正本: `doc/specs/analytics-events.md`
abstract final class AnalyticsEvent {
  static const appLaunched = 'app_launched';
  static const userSignedInAnonymously = 'user_signed_in_anonymously';
  static const userRegistered = 'user_registered';

  static const definitionPosted = 'definition_posted';
  static const definitionUpdated = 'definition_updated';
  static const definitionDeleted = 'definition_deleted';
  static const definitionVisibilityChanged = 'definition_visibility_changed';
  static const wordSaved = 'word_saved';
  static const wordUnsaved = 'word_unsaved';

  static const definitionLiked = 'definition_liked';
  static const definitionUnliked = 'definition_unliked';
  static const userFollowed = 'user_followed';
  static const userUnfollowed = 'user_unfollowed';
  static const userMuted = 'user_muted';
  static const userUnmuted = 'user_unmuted';

  static const policyAgreed = 'policy_agreed';
  static const trackingAuthorizationCompleted =
      'tracking_authorization_completed';
  static const profileUpdated = 'profile_updated';
  static const accountDeleted = 'account_deleted';
  static const forceUpdateShown = 'force_update_shown';
  static const maintenanceShown = 'maintenance_shown';
  static const externalLinkOpened = 'external_link_opened';
}

abstract final class AnalyticsParam {
  static const flavor = 'flavor';
  static const definitionId = 'definition_id';
  static const wordId = 'word_id';
  static const authorId = 'author_id';
  static const targetUserId = 'target_user_id';
  static const isPublic = 'is_public';
  static const wasPublic = 'was_public';
  static const status = 'status';
  static const changedName = 'changed_name';
  static const changedBio = 'changed_bio';
  static const changedAvatar = 'changed_avatar';
  static const linkType = 'link_type';
}

/// `external_link_opened` の `link_type` 値。
abstract final class AnalyticsLinkType {
  static const howTo = 'how_to';
  static const inquiry = 'inquiry';
  static const terms = 'terms';
  static const privacy = 'privacy';
  static const storeListing = 'store_listing';
  static const forceUpdateStore = 'force_update_store';
}
