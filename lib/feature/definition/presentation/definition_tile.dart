import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/common_widget/adaptive_overflow_text.dart';
import '../../../../core/common_widget/avatar_network_image_widget.dart';
import '../../../../core/common_widget/error_and_retry_widget.dart';
import '../../../../core/router/app_router.dart';
import '../../../../util/extension/date_time_extension.dart';
import '../../../../util/logger.dart';
import '../../definition_like/presentation/like_widget.dart';
import '../application/definition_state.dart';
import 'definition_tile_shimmer.dart';

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
                padding: const EdgeInsets.only(top: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () async {
                        await context.pushRoute(
                          ProfileTopRoute(targetUserId: definition.authorId),
                        );
                      },
                      child: AvatarNetworkImageWidget(
                        imageUrl: definition.authorImageUrl,
                      ),
                    ),
                    const Gap(8),
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
                              const Gap(4),
                              definition.isPublic
                                  ? const SizedBox.shrink()
                                  : Row(
                                      children: [
                                        Icon(
                                          CupertinoIcons.lock_fill,
                                          size: 16,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurfaceVariant,
                                        ),
                                        const Gap(4),
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
                          const Gap(8),
                          AdaptiveOverflowText(
                            text: definition.definition,
                            maxLines: 5,
                          ),
                          const Gap(8),
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
          return const Column(
            children: [
              Gap(16),
              CupertinoActivityIndicator(),
              Gap(24),
              Divider(),
            ],
          );
        }

        logger.e(
          'definitionId [$definitionId]の取得時にエラーが発生: $error, stackTrace: $stackTrace',
        );
        return Column(
          children: [
            const Gap(16),
            SimpleErrorAndRetryWidget(
              onRetry: () => ref.invalidate(definitionProvider(definitionId)),
            ),
            const Gap(16),
            const Divider(),
          ],
        );
      },
      loading: () => const DefinitionTileShimmer(),
    );
  }
}
