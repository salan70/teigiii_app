import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:teigiii_api/teigiii_api.dart';

import '../../../../core/router/app_router.dart';
import '../../../../util/extension/date_time_extension.dart';
import '../../user_profile/presentation/avatar_network_image_widget.dart';

/// タイムラインの「新たな言葉」タイル。
///
/// 定義タイルと同じ余白・タイポ階層に揃え、専用アイコンを左に置く。
class WordRegisteredTile extends StatelessWidget {
  const WordRegisteredTile({super.key, required this.activity});

  final WordRegisteredActivity activity;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurfaceVariant = theme.colorScheme.onSurfaceVariant;
    final avatarDiameter = AvatarSize.medium.diameter;

    return InkWell(
      onTap: () => context.pushRoute(WordTopRoute(wordId: activity.word.id)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: avatarDiameter,
                  height: avatarDiameter,
                  child: CircleAvatar(
                    radius: avatarDiameter / 2,
                    // primaryContainer は蛍光寄りなので、既存 primary に近い
                    // secondaryContainer + primary で抑えた緑系にする。
                    backgroundColor: theme.colorScheme.secondaryContainer,
                    child: Icon(
                      Icons.auto_stories_outlined,
                      size: avatarDiameter / 2,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
                const Gap(8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 定義タイルの「投稿者名 + 時刻」行と同じ配置・スタイル。
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Expanded(
                            child: Text(
                              '新たな言葉',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(activity.occurredAt.timeAgo(DateTime.now())),
                        ],
                      ),
                      Text(
                        activity.word.word,
                        overflow: TextOverflow.clip,
                        style: theme.textTheme.titleLarge,
                      ),
                      const Gap(8),
                      Text(
                        activity.word.reading,
                        style: theme.textTheme.bodyMedium!.copyWith(
                          color: onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
