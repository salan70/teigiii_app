import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_down_button/pull_down_button.dart';

import '../../../feature/auth/application/auth_state.dart';
import '../../../feature/user_config/application/user_config_service.dart';
import '../../../feature/user_config/application/user_config_state.dart';

/// タップするとプルダウンメニューが表示される
class EllipsisIconButton extends ConsumerWidget {
  const EllipsisIconButton({
    super.key,
    required this.ownerId,
  });

  final String ownerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final globalKey = GlobalKey();
    final currentUserId = ref.watch(userIdProvider);
    final asyncMutedUserIdList = ref.watch(mutedUserIdListProvider);

    // プルダウンメニューの項目を作成する
    List<PullDownMenuEntry> createMenuItems(
      String? currentUserId,
      String ownerId,
      List<String> mutedUserIdList,
    ) {
      // 万が一currentUserIdがnullの場合はfalseとなる
      // 自身が投稿した定義の場合
      if (currentUserId == ownerId) {
        return [
          PullDownMenuItemForDefinitionAction.editDefinition.item(),
          PullDownMenuItemForDefinitionAction.deleteDefinition.item(),
        ];
      }
      // 他ユーザーが投稿した かつ 既にミュート済みの場合
      else if (mutedUserIdList.contains(ownerId)) {
        return [
          PullDownMenuItemForUserAction.unmuteUser.item(
            ref: ref,
            targetUser: ownerId,
          ),
          PullDownMenuItemForUserAction.reportUser.item(
            ref: ref,
            targetUser: ownerId,
          ),
        ];
      } else {
        return [
          PullDownMenuItemForUserAction.muteUser.item(
            ref: ref,
            targetUser: ownerId,
          ),
          PullDownMenuItemForUserAction.reportUser.item(
            ref: ref,
            targetUser: ownerId,
          ),
        ];
      }
    }

    return asyncMutedUserIdList.maybeWhen(
      orElse: () => const SizedBox.shrink(),
      data: (mutedUserIdList) {
        final items = createMenuItems(
          currentUserId,
          ownerId,
          mutedUserIdList,
        );
        return IconButton(
          key: globalKey,
          icon: const Icon(CupertinoIcons.ellipsis),
          onPressed: () async {
            // IconButtonの位置を取得
            final box =
                globalKey.currentContext?.findRenderObject() as RenderBox?;
            final position =
                box!.localToGlobal(Offset.zero) & const Size(40, 48);

            if (!context.mounted) {
              return;
            }

            await showPullDownMenu(
              context: context,
              position: position,
              items: items,
            );
          },
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
