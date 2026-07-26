/// サイズの semantic token。
///
/// 固定高（検索フィールドの 80 など）はトークンにせず、対応する Ds
/// コンポーネント内部へ閉じる。
///
/// @doc doc/specs/mobile-app-design-system.md#3-3-dssize
abstract final class DsSize {
  /// 本文に添えるアイコン。
  static const double iconSmall = 16;

  /// 標準のアクションアイコン。
  static const double iconMedium = 20;

  /// 単独で意味を持つアイコン。
  static const double iconLarge = 24;

  /// プロフィール系の大アイコン。
  static const double avatarIcon = 40;
}
