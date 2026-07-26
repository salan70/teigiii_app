import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../token/ds_size.dart';
import '../token/ds_spacing.dart';
import '../token/ds_theme_context.dart';

/// 遷移を伴うリスト行。
///
/// 行の意味は [label] が持ち、遷移先の知識は呼び出し側に置く。
///
/// @doc doc/specs/mobile-app-design-system.md#初期コンポーネント最低セット-261
class DsListTile extends StatelessWidget {
  /// 先頭にアイコンを置く行。
  const DsListTile.withLeadingIcon({
    super.key,
    required this.label,
    required this.leadingIcon,
    required this.onTap,
  });

  /// ラベルだけの行。
  const DsListTile.label({super.key, required this.label, required this.onTap})
    : leadingIcon = null;

  /// 行のラベル。
  final String label;

  /// 先頭のアイコン。
  final IconData? leadingIcon;

  /// タップ時の処理。null で操作不可。
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.dsColorScheme;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: DsSpacing.inline),
        child: Row(
          children: [
            if (leadingIcon != null) ...[
              Icon(leadingIcon, size: DsSize.iconLarge),
              const Gap(DsSpacing.inline),
            ],
            Expanded(child: Text(label, style: context.dsTypography.heading)),
            Icon(
              CupertinoIcons.chevron_forward,
              size: DsSize.iconMedium,
              color: colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
