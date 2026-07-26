import 'package:flutter/material.dart';

/// [ColorScheme] で表せない意味色の semantic token。
///
/// 基本の配色は [ColorScheme] をそのまま使う。ここに置くのは
/// 「[ColorScheme] のどの役割にも当てはまらないが、意味が明確な色」だけ。
///
/// @doc doc/specs/mobile-app-design-system.md#3-トークン-taxonomy
@immutable
class DsColors extends ThemeExtension<DsColors> {
  const DsColors({required this.like});

  /// 既定の意味色。
  ///
  /// 現行の `likeColor` は light / dark で同じ値を使っているため、
  /// テーマごとに出し分けていない。
  static const DsColors standard = DsColors(like: Colors.pink);

  /// 「いいね（♡）」を表す色。
  final Color like;

  @override
  DsColors copyWith({Color? like}) => DsColors(like: like ?? this.like);

  @override
  DsColors lerp(ThemeExtension<DsColors>? other, double t) {
    if (other is! DsColors) {
      return this;
    }
    return DsColors(like: Color.lerp(like, other.like, t)!);
  }
}
