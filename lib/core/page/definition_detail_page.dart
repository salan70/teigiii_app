import 'package:auto_route/auto_route.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../feature/auth/application/auth_state.dart';
import '../../feature/definition/application/definition_state.dart';
import '../../feature/definition/presentation/post_definition_fab.dart';
import '../../feature/definition/presentation/self_definition_action_icon_button.dart';
import '../../feature/definition_like/presentation/like_widget.dart';
import '../../feature/user_config/presentation/other_user_action_icon_button.dart';
import '../../feature/user_follow/presentation/follow_or_unfollow_button.dart';
import '../../feature/user_profile/presentation/avatar_network_image_widget.dart';
import '../../util/extension/date_time_extension.dart';
import '../../util/logger.dart';
import '../common_widget/error_and_retry_widget.dart';
import '../common_widget/shimmer_widget.dart';
import '../router/app_router.dart';

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
                                    const Gap(2),
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
                                const Gap(16),
                              ],
                            ),
                          ),
                    InkWell(
                      onTap: () async {
                        await context.pushRoute(
                          ProfileTopRoute(targetUserId: definition.authorId),
                        );
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AvatarNetworkImageWidget(
                            imageUrl: definition.authorImageUrl,
                          ),
                          const Gap(16),
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
                    const Gap(16),
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
                    const Gap(16),
                    Text(
                      definition.definition,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const Gap(16),
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
                            if (definition.likesCount == 0) {
                              // いいねが0件の場合は何もしない
                              return;
                            }

                            await context.pushRoute(
                              UserListLikedRoute(definitionId: definition.id),
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
          floatingActionButton: const PostDefinitionFAB(),
        );
      },
      loading: () {
        return Scaffold(
          appBar: AppBar(
            title: const Text('詳細'),
          ),
          body: const _DefinitionDetailPageShimmer(),
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

        logger.e('定義[$definitionId]の取得に失敗しました。'
            'error: $error, stackTrace: $stackTrace');
        return Scaffold(
          appBar: AppBar(
            title: const Text('詳細'),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: ErrorAndRetryWidget.cannotInquire(
                onRetry: () => ref.invalidate(definitionProvider(definitionId)),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DefinitionDetailPageShimmer extends StatelessWidget {
  const _DefinitionDetailPageShimmer();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(
        top: 24,
        left: 24,
        right: 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ShimmerWidget.circular(width: 48, height: 48),
              Gap(16),
              ShimmerWidget.rectangular(height: 16, width: 120),
            ],
          ),
          Gap(16),
          ShimmerWidget.rectangular(height: 32, width: 300),
          Gap(16),
          ShimmerWidget.rectangular(height: 120),
          Gap(16),
          ShimmerWidget.rectangular(height: 16, width: 120),
          Gap(4),
          ShimmerWidget.rectangular(height: 16, width: 120),
          Gap(8),
          ShimmerWidget.rectangular(height: 20, width: 48),
        ],
      ),
    );
  }
}
