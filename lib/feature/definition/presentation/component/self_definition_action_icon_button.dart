import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_down_button/pull_down_button.dart';

import '../../../../core/router/app_router.dart';
import '../../../../util/extension/date_time_extension.dart';
import '../../application/definition_service.dart';
import '../../domain/definition.dart';
import '../../util/definition_post_type.dart';

class SelfDefinitionActionIconButton extends ConsumerWidget {
  const SelfDefinitionActionIconButton({super.key, required this.definition});

  final Definition definition;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final globalKey = GlobalKey();

    // プルダウンメニューの項目を作成する
    List<PullDownMenuEntry> createMenuItems() {
      final targetPostType = definition.isPublic
          ? DefinitionPostType.private
          : DefinitionPostType.public;

      return [
        PullDownMenuItem(
          title: targetPostType.labelForChange,
          icon: targetPostType.icon,
          onTap: () {
            _showChangePostTypeConfirmDialog(context, ref);
          },
        ),
        PullDownMenuItem(
          title: 'この定義を編集',
          icon: CupertinoIcons.pencil,
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
        PullDownMenuItem(
          title: 'この定義を削除',
          icon: CupertinoIcons.trash,
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
          items: createMenuItems(),
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
                      initialDefinitionForWrite:
                          definition.toDefinitionForWrite(),
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

  /// 公開設定を変更してもいいか確認するダイアログを表示する
  Future<void> _showChangePostTypeConfirmDialog(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final afterUpdatePostType = definition.isPublic
        ? DefinitionPostType.private
        : DefinitionPostType.public;

    await showDialog<dynamic>(
      context: context,
      builder: (context) {
        return AlertDialog(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: const EdgeInsets.only(
            top: 16,
            bottom: 8,
          ),
          title: const Center(child: Text('確認')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                afterUpdatePostType.confirmChangeMessage,
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
                  'しない',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                ref
                    .read(definitionServiceProvider.notifier)
                    .updatePostType(definition);
                context.popRoute();
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'する',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).colorScheme.error,
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
