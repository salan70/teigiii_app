import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_down_button/pull_down_button.dart';

import '../../../../auth/application/auth_state.dart';
import '../../../../user_config/application/user_config_service.dart';
import '../../../../user_config/application/user_config_state.dart';
import '../../../domain/definition.dart';

class MoreIconButtonInAppBar extends ConsumerWidget {
  const MoreIconButtonInAppBar({super.key, required this.definition});

  final Definition definition;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final globalKey = GlobalKey();

    return IconButton(
      key: globalKey,
      icon: const Icon(CupertinoIcons.ellipsis),
      onPressed: () async {
        // IconButtonの位置を取得
        final box = globalKey.currentContext?.findRenderObject() as RenderBox?;
        final position = box!.localToGlobal(Offset.zero) & const Size(40, 48);

        final items = await _createMenuItems(ref);

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
  }

  /// プルダウンメニューの項目を作成する
  // TODO(me): refを引数で渡しても問題ないか調べる
  Future<List<PullDownMenuEntry>> _createMenuItems(
    WidgetRef ref,
  ) async {
    // 万が一userIdがnullの場合、
    // 定義の編集/削除をできなくするために空文字を入れる
    final userId = ref.read(userIdProvider) ?? '';
    final mutedUserIdList = await ref.read(mutedUserIdListProvider.future);

    // 自身が投稿した定義の場合
    if (userId == definition.authorId) {
      return [
        PullDownMenuItem(
          onTap: () {}, // TODO(me): 定義の編集画面に遷移する
          title: 'この定義を編集',
          icon: CupertinoIcons.pencil,
        ),
        PullDownMenuItem(
          onTap: () {}, // TODO(me): 定義を削除する
          title: 'この定義を削除',
          icon: CupertinoIcons.trash,
        ),
      ];
    }
    // 他ユーザーが投稿した かつ 既にミュート済みの場合
    else if (mutedUserIdList.contains(definition.authorId)) {
      return [
        PullDownMenuItem(
          onTap: () async {
            await ref
                .read(userConfigServiceProvider.notifier)
                .unmuteUser(definition.authorId);
          },
          title: 'このユーザーのミュートを解除',
          icon: CupertinoIcons.speaker,
        ),
        PullDownMenuItem(
          onTap: () {}, // TODO(me): ユーザーを報告する
          title: 'このユーザーを報告',
          icon: CupertinoIcons.flag,
        ),
      ];
    } else {
      return [
        PullDownMenuItem(
          onTap: () async {
            await ref
                .read(userConfigServiceProvider.notifier)
                .muteUser(definition.authorId);
          },
          title: 'このユーザーをミュート',
          icon: CupertinoIcons.speaker_slash,
        ),
        PullDownMenuItem(
          onTap: () {}, // TODO(me): ユーザーを報告する
          title: 'このユーザーを報告',
          icon: CupertinoIcons.flag,
        ),
      ];
    }
  }
}
