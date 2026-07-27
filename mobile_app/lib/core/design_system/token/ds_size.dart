/// サイズの semantic token。
///
/// 固定高はトークンにしない。
///
/// 検索欄の高さ・左右余白は #280 で `DsSearchField` 内部へ閉じた
/// （高さ 48 / 左右 40）。このトークンでは表現しない。
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
