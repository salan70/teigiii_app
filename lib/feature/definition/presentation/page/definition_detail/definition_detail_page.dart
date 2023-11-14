import 'package:auto_route/auto_route.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/common_widget/avatar_network_image_widget.dart';
import '../../../../../core/common_widget/button/follow_or_unfollow_button.dart';
import '../../../../../core/common_widget/button/other_user_action_icon_button.dart';
import '../../../../../core/common_widget/button/post_definition_fab.dart';
import '../../../../../core/common_widget/error_and_retry_widget.dart';
import '../../../../../core/router/app_router.dart';
import '../../../../../util/extension/date_time_extension.dart';
import '../../../../../util/logger.dart';
import '../../../../auth/application/auth_state.dart';
import '../../../application/definition_state.dart';
import '../../component/like_widget.dart';
import '../../component/self_definition_action_icon_button.dart';
import 'definition_detail_shimmer.dart';

@RoutePage()
class DefinitionDetailPage extends ConsumerWidget {
  const DefinitionDetailPage({
    super.key,
    required this.definitionId,
  });

  final String definitionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncDefinition = ref.watch(definitionProvider(definitionId));

    return asyncDefinition.when(
      data: (definition) {
        final currentUserId = ref.watch(userIdProvider)!;
        final isSelfDefinition = currentUserId == definition.authorId;

        return Scaffold(
          appBar: AppBar(
            title: const Text('詳細'),
            actions: [
              isSelfDefinition
                  ? SelfDefinitionActionIconButton(definition: definition)
                  : OtherUserActionIconButton(ownerId: definition.authorId),
            ],
          ),
          body: EasyRefresh(
            header: const CupertinoHeader(),
            onRefresh: () async {
              ref.invalidate(definitionProvider(definitionId));
            },
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 24,
                  left: 24,
                  right: 24,
                  bottom: 120,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    definition.isPublic
                        ? const SizedBox.shrink()
                        : Center(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      CupertinoIcons.lock_fill,
                                      size: 16,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                                    const SizedBox(width: 2),
                                    Text(
                                      'この投稿はあなただけに見えています',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurfaceVariant,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                              ],
                            ),
                          ),
                    InkWell(
                      onTap: () async {
                        await context.pushRoute(
                          ProfileRoute(targetUserId: definition.authorId),
                        );
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AvatarNetworkImageWidget(
                            imageUrl: definition.authorImageUrl,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              definition.authorName,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    fontWeight: FontWeight.normal,
                                  ),
                            ),
                          ),
                          definition.authorId == currentUserId
                              ? const SizedBox.shrink()
                              : FollowOrUnfollowButton(
                                  targetUserId: definition.authorId,
                                ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () async {
                        await context.pushRoute(
                          WordTopRoute(wordId: definition.wordId),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            definition.word,
                            overflow: TextOverflow.clip,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Text(
                            definition.wordReading,
                            overflow: TextOverflow.clip,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      definition.definition,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '${definition.createdAt.toDisplayFormat()} 投稿',
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                        ),
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        LikeWidget(definition: definition, showCount: false),
                        InkWell(
                          onTap: () async {
                            await context.pushRoute(
                              LikeUserRoute(definitionId: definition.id),
                            );
                          },
                          child: Text('${definition.likesCount}件のいいね'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: const PostDefinitionFAB(definition: null),
        );
      },
      loading: () {
        return Scaffold(
          appBar: AppBar(
            title: const Text('詳細'),
          ),
          body: const DefinitionDeitailShimmer(),
        );
      },
      error: (error, stackTrace) {
        // エラー発生後の再読み込み中の場合、trueになる
        if (asyncDefinition.isRefreshing) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('詳細'),
            ),
            body: const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Align(
                alignment: Alignment.topCenter,
                child: CupertinoActivityIndicator(),
              ),
            ),
          );
        }

        logger.e('定義[$definitionId]のプロフィールの取得に失敗しました。'
            'error: $error, stackTrace: $stackTrace');
        return Scaffold(
          appBar: AppBar(
            title: const Text('詳細'),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: ErrorAndRetryWidget(
                onRetry: () => ref.invalidate(definitionProvider(definitionId)),
              ),
            ),
          ),
        );
      },
    );
  }
}
