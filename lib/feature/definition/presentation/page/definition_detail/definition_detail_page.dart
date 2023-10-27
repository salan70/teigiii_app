import 'package:auto_route/auto_route.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_down_button/pull_down_button.dart';

import '../../../../../core/common_widget/button/show_pull_down_icon_button.dart';
import '../../../../../util/extension/date_time_extension.dart';
import '../../../../auth/application/auth_state.dart';
import '../../../../user_config/application/user_config_service.dart';
import '../../../../user_config/application/user_config_state.dart';
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
    final userId = ref.watch(userIdProvider);
    final asyncMutedUserIdList = ref.watch(mutedUserIdListProvider);

    // プルダウンメニューの項目を作成する
    List<PullDownMenuEntry> createMenuItems(
      String authorId,
      List<String> mutedUserIdList,
    ) {
      // 万が一userIdがnullの場合、
      // 定義の編集/削除をできなくするために空文字を入れる

      // 自身が投稿した定義の場合
      if (userId == authorId) {
        return [
          PullDownMenuItemForDefinitionAction.editDefinition.item(),
          PullDownMenuItemForDefinitionAction.deleteDefinition.item(),
        ];
      }
      // 他ユーザーが投稿した かつ 既にミュート済みの場合
      else if (mutedUserIdList.contains(authorId)) {
        return [
          PullDownMenuItemForUserAction.unmuteUser.item(
            ref: ref,
            targetUser: authorId,
          ),
          PullDownMenuItemForUserAction.reportUser.item(
            ref: ref,
            targetUser: authorId,
          ),
        ];
      } else {
        return [
          PullDownMenuItemForUserAction.muteUser.item(
            ref: ref,
            targetUser: authorId,
          ),
          PullDownMenuItemForUserAction.reportUser.item(
            ref: ref,
            targetUser: authorId,
          ),
        ];
      }
    }

    return asyncDefinition.when(
      data: (definition) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('詳細'),
            actions: [
              asyncMutedUserIdList.maybeWhen(
                data: (mutedUserIdList) {
                  final items =
                      createMenuItems(definition.authorId, mutedUserIdList);
                  return ShowPullDownIconButton(
                    items: items,
                    icon: CupertinoIcons.ellipsis,
                  );
                },
                orElse: () => const SizedBox.shrink(),
              ),
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
                        AvatarIconWidget(
                          imageUrl: definition.authorImageUrl,
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
