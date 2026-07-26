/// 不透明度の semantic token。
///
/// 完全な透明は不透明度ではなく透明色の指定なので、`Colors.transparent` を使う。
///
/// @doc doc/specs/mobile-app-design-system.md#3-5-dsopacity
abstract final class DsOpacity {
  /// 無効状態・オーバーレイの遮蔽。
  static const double disabled = 0.3;
}
