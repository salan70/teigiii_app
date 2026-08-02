import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../token/ds_radius.dart';
import '../token/ds_size.dart';
import '../token/ds_spacing.dart';
import '../token/ds_theme_context.dart';

/// 入力内容に対する気づきを、遷移導線つきで示す小さな帯。
///
/// 遷移先の知識と配置（寄せ）は呼び出し側に置く。
/// 内容に合わせた幅になるため、左寄せにするなら [Align] で包む。
///
/// @doc doc/specs/mobile-app-design-system.md#初期コンポーネント最低セット-261
class DsChip extends StatelessWidget {
  /// タップで別の画面へ移動できる帯。
  const DsChip.navigable({super.key, required this.label, required this.onTap});

  /// 帯に表示するテキスト。
  final String label;

  /// タップ時の処理。
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.dsColorScheme;

    return Material(
      color: colorScheme.secondaryContainer,
      borderRadius: DsRadius.pillBorder,
      child: InkWell(
        onTap: onTap,
        borderRadius: DsRadius.pillBorder,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: DsSpacing.containerContent,
            vertical: DsSpacing.item,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  label,
                  style: context.dsTypography.label.copyWith(
                    color: colorScheme.onSecondaryContainer,
                  ),
                ),
              ),
              const Gap(DsSpacing.tight),
              Icon(
                CupertinoIcons.chevron_forward,
                size: DsSize.iconSmall,
                color: colorScheme.onSecondaryContainer,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
