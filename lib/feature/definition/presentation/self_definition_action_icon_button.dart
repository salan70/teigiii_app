import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:pull_down_button/pull_down_button.dart';

import '../../../../core/common_provider/dialog_controller.dart';
import '../../../../core/common_widget/dialog/confirm_dialog.dart';
import '../../../../core/router/app_router.dart';
import '../../../../util/extension/date_time_extension.dart';
import '../../../util/mixin/presentation_mixin.dart';
import '../../word/application/word_state.dart';
import '../application/definition_service.dart';
import '../domain/definition.dart';
import '../util/after_post_navigation_type.dart';
import '../util/definition_post_type.dart';

class SelfDefinitionActionIconButton extends ConsumerWidget
    with PresentationMixin {
  SelfDefinitionActionIconButton({super.key, required this.definition});

  final Definition definition;

  final globalKey = GlobalKey();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // プルダウンメニューの項目を作成する。
    List<PullDownMenuEntry> createMenuItems() {
      final targetPostType = definition.isPublic
          ? DefinitionPostType.private
          : DefinitionPostType.public;

      return [
        PullDownMenuItem(
          title: targetPostType.labelForChange,
          icon: targetPostType.icon,
          onTap: () => ref
              .read(dialogControllerProvider)
              .show(_ChangePostTypeConfirmDialog(definition: definition)),
        ),
        PullDownMenuItem(
          title: 'この定義を編集',
          icon: CupertinoIcons.pencil,
          onTap: () {
            // 投稿から1時間以内の定義のみ編集可能。
            final canEdit = !definition.createdAt.hasOneHourPassed();
            if (!canEdit) {
              ref
                  .read(dialogControllerProvider)
                  .show(_CannotEditAlertDialog(definition: definition));
              return;
            }

            context.pushRoute(
              DefinitionEditRoute(initialDefinition: definition),
            );
          },
        ),
        PullDownMenuItem(
          title: 'この定義を削除',
          icon: CupertinoIcons.trash,
          onTap: () {
            ref.read(dialogControllerProvider).show(
                  ConfirmDialog(
                    confirmMessage: '本当に削除してもよろしいですか？',
                    onAccept: () async {
                      await executeWithOverlayLoading(
                        ref,
                        action: () async {
                          await ref
                              .read(definitionServiceProvider)
                              .deleteDefinition(definition);

                          // ラグを防ぐため、待機する。
                          await ref.read(
                            wordProvider(definition.wordId).future,
                          );

                          if (!context.mounted) {
                            return;
                          }
                          await context.popRoute();
                        },
                        successToastMessage: '削除しました。',
                      );
                    },
                    confirmButtonText: '削除する',
                  ),
                );
          },
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
}

class _CannotEditAlertDialog extends StatelessWidget {
  const _CannotEditAlertDialog({required this.definition});

  final Definition definition;

  @override
  Widget build(BuildContext context) {
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
          Gap(8),
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
          onTap: context.popRoute,
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
            context
              ..popRoute()
              ..pushRoute(
                DefinitionPostRoute(
                  initialDefinitionForWrite: definition.toDefinitionForWrite(),
                  autoFocusForm: null,
                  afterPostNavigation: AfterPostNavigationType.toDetail,
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
  }
}

class _ChangePostTypeConfirmDialog extends ConsumerWidget
    with PresentationMixin {
  const _ChangePostTypeConfirmDialog({required this.definition});

  final Definition definition;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final afterUpdatePostType = definition.isPublic
        ? DefinitionPostType.private
        : DefinitionPostType.public;

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
          onTap: context.popRoute,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'しない',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ),
        InkWell(
          onTap: () async {
            final afterUpdatePostType = definition.isPublic
                ? DefinitionPostType.private
                : DefinitionPostType.public;

            await executeWithOverlayLoading(
              ref,
              action: () async {
                await ref
                    .read(definitionServiceProvider)
                    .updatePostType(definition);
                await ref.read(appRouterProvider).pop();
              },
              successToastMessage: afterUpdatePostType.completeChangeMessage,
            );
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
  }
}
