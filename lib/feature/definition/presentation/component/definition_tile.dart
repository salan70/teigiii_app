import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/common_widget/adaptive_overflow_text.dart';
import '../../../../core/common_widget/avatar_network_image_widget.dart';
import '../../../../core/common_widget/error_and_retry_widget.dart';
import '../../../../core/router/app_router.dart';
import '../../../../util/extension/date_time_extension.dart';
import '../../../../util/logger.dart';
import '../../application/definition_state.dart';
import 'definition_tile_shimmer.dart';
import 'like_widget.dart';

class DefinitionTile extends ConsumerWidget {
  const DefinitionTile({
    super.key,
    required this.definitionId,
  });

  final String definitionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncDefinition = ref.watch(definitionProvider(definitionId));
    return asyncDefinition.when(
      data: (definition) {
        return InkWell(
          onTap: () async {
            await context.pushRoute(
              DefinitionDetailRoute(
                definitionId: definition.id,
              ),
            );
          },
          child: Column(
            children: [
              Padding(
                padding: REdgeInsets.only(
                  top: 16,
                  left: 16,
                  right: 16,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () async {
                        await context.pushRoute(
                          ProfileRoute(targetUserId: definition.authorId),
                        );
                      },
                      child: AvatarNetworkImageWidget(
                        imageUrl: definition.authorImageUrl,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  definition.authorName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(width: 4.w),
                              definition.isPublic
                                  ? const SizedBox.shrink()
                                  : Row(
                                      children: [
                                        Icon(
                                          CupertinoIcons.lock_fill,
                                          size: 16.sp,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurfaceVariant,
                                        ),
                                        SizedBox(width: 4.w),
                                      ],
                                    ),
                              Text(
                                definition.createdAt.timeAgo(DateTime.now()),
                              ),
                            ],
                          ),
                          Text(
                            definition.word,
                            overflow: TextOverflow.clip,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          SizedBox(height: 8.h),
                          AdaptiveOverflowText(
                            text: definition.definition,
                            // TODO(me): maxLinesの値を検討する
                            maxLines: 5,
                          ),
                          SizedBox(height: 8.h),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: LikeWidget(definition: definition),
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
      },
      error: (error, stackTrace) {
        // エラー発生後の再読み込み中の場合、trueになる
        if (asyncDefinition.isRefreshing) {
          return Column(
            children: [
              SizedBox(height: 16.h),
              const CupertinoActivityIndicator(),
              SizedBox(height: 24.h),
              const Divider(),
            ],
          );
        }

        logger.e(
          'definitionId [$definitionId]の取得時にエラーが発生: $error, stackTrace: $stackTrace',
        );
        return Column(
          children: [
            SizedBox(height: 16.h),
            SimpleErrorAndRetryWidget(
              onRetry: () => ref.invalidate(definitionProvider(definitionId)),
            ),
            SizedBox(height: 16.h),
            const Divider(),
          ],
        );
      },
      loading: () => const DefinitionTileShimmer(),
    );
  }
}
