import 'package:flutter/material.dart';

import '../token/ds_opacity.dart';
import '../token/ds_spacing.dart';
import '../token/ds_theme_context.dart';

/// AppBar の右側に置くテキストの操作。
///
/// 画面の確定操作（投稿・登録など）に使う。ボタンの塗りは持たず、
/// disabled は同じ色を [DsOpacity.disabled] で薄くして表す。
///
/// @doc doc/specs/mobile-app-design-system.md#初期セット以降の追加
class DsAppBarAction extends StatelessWidget {
  const DsAppBarAction({
    super.key,
    required this.label,
    required this.onPressed,
  });

  /// 操作を表すテキスト。
  final String label;

  /// タップ時の処理。null で disabled。
  final VoidCallback? onPressed;

  /// 最小タップ領域の高さ。
  static const _minTapHeight = 48.0;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.dsColorScheme;
    final style = context.dsTypography.heading;

    return Center(
      child: InkWell(
        onTap: onPressed,
        // 文字の高さだけでは最小タップ領域に届かない。見た目は変わらないため
        // 高さ 48 をコンポーネント内部に閉じる（`DsSearchField` と同じ扱い）。
        child: Container(
          alignment: Alignment.center,
          constraints: const BoxConstraints(minHeight: _minTapHeight),
          padding: const EdgeInsets.symmetric(
            horizontal: DsSpacing.screenContent,
          ),
          child: Text(
            label,
            style: onPressed == null
                ? style.copyWith(
                    color: colorScheme.onSurface.withValues(
                      alpha: DsOpacity.disabled,
                    ),
                  )
                : style,
          ),
        ),
      ),
    );
  }
}
