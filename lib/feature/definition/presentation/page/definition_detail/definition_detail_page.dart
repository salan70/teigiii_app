import 'package:auto_route/auto_route.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/common_widget/button/other_user_action_icon_button.dart';
import '../../../../../core/common_widget/button/post_definition_fab.dart';
import '../../../../../core/router/app_router.dart';
import '../../../../../util/extension/date_time_extension.dart';
import '../../../../auth/application/auth_state.dart';
import '../../../application/definition_state.dart';
import '../../component/avatar_icon_widget.dart';
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
                          AvatarIconWidget(imageUrl: definition.authorImageUrl),
                          const SizedBox(width: 16),
                          Text(
                            definition.authorName,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                  fontWeight: FontWeight.normal,
                                ),
                          ),
                          const SizedBox(width: 32),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
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
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Text(
                            definition.wordReading,
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
                    const SizedBox(height: 48),
                    Row(
                      children: [
                        Text(
                          definition.createdAt.toDisplayFormat(),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '投稿',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          definition.updatedAt.toDisplayFormat(),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '更新',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        definition.isEdited
                            ? Row(
                                children: [
                                  const SizedBox(width: 8),
                                  Text(
                                    '編集済み',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurfaceVariant,
                                        ),
                                  ),
                                  Icon(
                                    CupertinoIcons.pencil,
                                    size: 16,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                                ],
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LikeWidget(definition: definition),
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
      error: (error, _) {
        // TODO(me): いい感じのエラー画面を表示させる
        return Scaffold(
          appBar: AppBar(
            title: const Text('詳細'),
          ),
          body: Center(
            child: Text(error.toString()),
          ),
        );
      },
    );
  }
}
