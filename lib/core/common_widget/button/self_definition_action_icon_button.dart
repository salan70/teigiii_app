import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_down_button/pull_down_button.dart';

import '../../../feature/definition/domain/definition.dart';
import '../../router/app_router.dart';

class SelfDefinitionActionIconButton extends ConsumerWidget {
  const SelfDefinitionActionIconButton({super.key, required this.definition});

  final Definition definition;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final globalKey = GlobalKey();

    // プルダウンメニューの項目を作成する
    List<PullDownMenuEntry> createMenuItems(Definition definition) {
      return [
        PullDownMenuItemForDefinitionAction.editDefinition.item(
          onTap: () {
            context.pushRoute(
              EditDefinitionRoute(
                
                initialDefinitionForWrite: definition.toDefinitionForWrite(),
              ),
            );
          },
        ),
        PullDownMenuItemForDefinitionAction.deleteDefinition.item(
          onTap: () {},
        ),
      ];
    }

    return IconButton(
      key: globalKey,
      icon: const Icon(CupertinoIcons.ellipsis),
      onPressed: () async {
        // IconButtonの位置を取得
        final box = globalKey.currentContext?.findRenderObject() as RenderBox?;
        final position = box!.localToGlobal(Offset.zero) & const Size(40, 48);

        if (!context.mounted) {
          return;
        }

        await showPullDownMenu(
          context: context,
          position: position,
          items: createMenuItems(definition),
        );
      },
    );
  }
}

enum PullDownMenuItemForDefinitionAction {
  editDefinition,
  deleteDefinition;

  PullDownMenuItem item({required VoidCallback onTap}) {
    switch (this) {
      case PullDownMenuItemForDefinitionAction.editDefinition:
        return PullDownMenuItem(
          onTap: onTap,
          title: 'この定義を編集',
          icon: CupertinoIcons.pencil,
        );
      case PullDownMenuItemForDefinitionAction.deleteDefinition:
        return PullDownMenuItem(
          onTap: onTap,
          title: 'この定義を削除',
          icon: CupertinoIcons.trash,
        );
    }
  }
}
