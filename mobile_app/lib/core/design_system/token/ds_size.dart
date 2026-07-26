/// サイズの semantic token。
///
/// 固定高はトークンにしない。
///
/// 検索欄の高さ 80 と左右余白 40 は、監査時点では「Ds コンポーネント内部へ
/// 閉じる」と判断していたが、`WordSearchResultPage` だけ値が違うため
/// **呼び出し側に例外として残している**（仕様 3.6 の訂正を参照）。
/// 統一は #280 で扱う。それまでこのトークンで表現しようとしないこと。
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
