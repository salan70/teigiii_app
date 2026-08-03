import 'package:flutter/widgets.dart';

/// 角丸の semantic token。
///
/// member は spec 3.2 の表が正本のため、未使用でも維持する。
/// 派生の `*Border` は spec 非掲載のユーティリティのため、実利用があるものだけ定義する。
///
/// @doc doc/specs/mobile-app-design-system.md#3-2-dsradius
abstract final class DsRadius {
  /// ボタン・アバターなど pill 型の要素。
  static const double pill = 48;

  /// 検索・入力フィールド。
  static const double field = 40;

  /// ダイアログ・カード・メニュー。
  static const double container = 16;

  /// スナックバー・ローディング表示の弱い角丸。
  static const double subtle = 4;

  /// shimmer の矩形。
  static const double shimmer = 2;

  /// [pill] の [BorderRadius]。
  static const BorderRadius pillBorder = BorderRadius.all(
    Radius.circular(pill),
  );

  /// [field] の [BorderRadius]。
  static const BorderRadius fieldBorder = BorderRadius.all(
    Radius.circular(field),
  );

  /// [container] の [BorderRadius]。
  static const BorderRadius containerBorder = BorderRadius.all(
    Radius.circular(container),
  );

  /// [shimmer] の [BorderRadius]。
  static const BorderRadius shimmerBorder = BorderRadius.all(
    Radius.circular(shimmer),
  );
}
