import 'package:auto_route/auto_route.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_down_button/pull_down_button.dart';

import '../../../../../core/common_widget/button/ellipsis_icon_button.dart';
import '../../../../../core/common_widget/button/post_definition_fab.dart';
import '../../../../../core/router/app_router.dart';
import '../../../../../util/extension/date_time_extension.dart';
import '../../../../user_config/application/user_config_service.dart';
import '../../../application/definition_state.dart';
import '../../component/avatar_icon_widget.dart';
import '../../component/like_widget.dart';
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
        return Scaffold(
          appBar: AppBar(
            title: const Text('詳細'),
            actions: [
              EllipsisIconButton(ownerId: definition.authorId),
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
                    Row(
                      children: [
                        InkWell(
                          onTap: () async {
                            await context.pushRoute(
                              ProfileRoute(targetUserId: definition.authorId),
                            );
                          },
                          child: AvatarIconWidget(
                            imageUrl: definition.authorImageUrl,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(definition.authorName),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      definition.word,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    Text(definition.definition),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Text(
                          definition.createdAt.toDisplayFormat(),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '作成',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    Row(
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
                      ],
                    ),
                    const SizedBox(height: 8),
                    LikeWidget(definition: definition),
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

enum PullDownMenuItemForUserAction {
  muteUser,
  unmuteUser,
  reportUser;

  PullDownMenuItem item({
    required WidgetRef ref,
    required String targetUser,
  }) {
    switch (this) {
      case PullDownMenuItemForUserAction.muteUser:
        return PullDownMenuItem(
          onTap: () async {
            await ref
                .read(userConfigServiceProvider.notifier)
                .muteUser(targetUser);
          },
          title: 'このユーザーをミュート',
          icon: CupertinoIcons.speaker_slash,
        );
      case PullDownMenuItemForUserAction.unmuteUser:
        return PullDownMenuItem(
          onTap: () async {
            await ref
                .read(userConfigServiceProvider.notifier)
                .unmuteUser(targetUser);
          },
          title: 'このユーザーのミュートを解除',
          icon: CupertinoIcons.speaker,
        );
      case PullDownMenuItemForUserAction.reportUser:
        return PullDownMenuItem(
          onTap: () {
            // TODO(me): ユーザー報告を実装する
          },
          title: 'このユーザーを報告',
          icon: CupertinoIcons.flag,
        );
    }
  }
}

enum PullDownMenuItemForDefinitionAction {
  editDefinition,
  deleteDefinition;

  PullDownMenuItem item() {
    switch (this) {
      case PullDownMenuItemForDefinitionAction.editDefinition:
        return PullDownMenuItem(
          onTap: () {
            // TODO(me): 定義編集画面へ遷移させる
          },
          title: 'この定義を編集',
          icon: CupertinoIcons.pencil,
        );
      case PullDownMenuItemForDefinitionAction.deleteDefinition:
        return PullDownMenuItem(
          onTap: () {
            // TODO(me): 定義削除を実装する
          },
          title: 'この定義を削除',
          icon: CupertinoIcons.trash,
        );
    }
  }
}
