import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_down_button/pull_down_button.dart';

import '../../../../core/router/app_router.dart';
import '../../../../util/extension/date_time_extension.dart';
import '../../domain/definition.dart';

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
            // 投稿から1時間以内の定義のみ編集可能
            final canEdit = !definition.createdAt.hasOneHourPassed();
            if (!canEdit) {
              _showAlertCannotEditDialog(context);
              return;
            }

            context.pushRoute(
              EditDefinitionRoute(initialDefinition: definition),
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

  /// 編集ができない旨を伝えるダイアログを表示する
  Future<void> _showAlertCannotEditDialog(BuildContext context) async {
    await showDialog<dynamic>(
      context: context,
      builder: (context) {
        return AlertDialog(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: const EdgeInsets.only(
            top: 32,
            right: 24,
            left: 32,
            bottom: 8,
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '編集は投稿してから1時間以内にしかできません。',
                overflow: TextOverflow.clip,
              ),
              SizedBox(height: 8),
              Text(
                '代わりに、この投稿の内容をもとに新規投稿を作成しませんか？',
                overflow: TextOverflow.clip,
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actionsPadding: const EdgeInsets.only(bottom: 16),
          actions: [
            InkWell(
              onTap: () {
                context.popRoute();
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'キャンセル',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                // TODO(me): 適切な画面へ遷移させる
                context
                  ..popRoute()
                  ..pushRoute(
                    PostDefinitionRoute(
                      initialDefinitionForWrite: definition.toDefinitionForWrite(),
                      autoFocusForm: null,
                    ),
                  );
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  '作成する',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ),
            ),
          ],
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
