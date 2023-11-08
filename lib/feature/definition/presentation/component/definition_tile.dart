import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/common_widget/adaptive_overflow_text.dart';
import '../../../../core/router/app_router.dart';
import '../../../../util/extension/date_time_extension.dart';
import '../../../../util/logger.dart';
import '../../application/definition_state.dart';
import 'avatar_icon_widget.dart';
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
                padding: const EdgeInsets.only(
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
                      child:
                          AvatarIconWidget(imageUrl: definition.authorImageUrl),
                    ),
                    const SizedBox(width: 8),
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
                              const SizedBox(width: 4),
                              definition.isEdited
                                  ? Row(
                                      children: [
                                        Icon(
                                          CupertinoIcons.pencil,
                                          size: 16,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurfaceVariant,
                                        ),
                                        const SizedBox(width: 4),
                                      ],
                                    )
                                  : const SizedBox.shrink(),
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
                                        const SizedBox(width: 4),
                                      ],
                                    ),
                              Text(
                                definition.updatedAt.timeAgo(DateTime.now()),
                              ),
                            ],
                          ),
                          Text(
                            definition.word,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          AdaptiveOverflowText(
                            text: definition.definition,
                            // TODO(me): maxLinesの値を検討する
                            maxLines: 5,
                          ),
                          const SizedBox(height: 8),
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
        logger.e('definitionId [$definitionId]の取得時にエラーが発生: $error');
        // TODO(me): エラー時に表示させるTileを作成する
        // 「!」みたいなアイコンと、エラーが発生した旨を表示するのが良さげ
        return const SizedBox();
      },
      loading: () {
        return const DefinitionTileShimmer();
      },
    );
  }
}
