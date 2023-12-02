import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/common_provider/dialog_controller.dart';
import '../core/router/app_router.dart';
import '../feature/definition/application/definition_for_write_notifier.dart';
import '../feature/definition/domain/definition.dart';
import '../feature/definition/presentation/write_definition_base_page.dart';
import '../util/extension/date_time_extension.dart';
import '../util/mixin/presentation_mixin.dart';

@RoutePage()
class DefinitionEditPage extends ConsumerWidget with PresentationMixin {
  const DefinitionEditPage({
    super.key,
    required this.initialDefinition,
  });

  final Definition initialDefinition;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initialDefinitionForWrite = initialDefinition.toDefinitionForWrite();

    final definitionForWriteProvider =
        definitionForWriteNotifierProvider(initialDefinitionForWrite);

    final asyncDefinitionForWrite = ref.watch(definitionForWriteProvider);
    final notifier = ref.watch(definitionForWriteProvider.notifier);

    return asyncDefinitionForWrite.when(
      data: (definitionForWrite) {
        return WriteDefinitionBasePage(
          definitionForWrite: definitionForWrite,
          notifier: notifier,
          appBarActionWidget: InkWell(
            onTap: notifier.canEdit()
                ? () async {
                    primaryFocus?.unfocus();

                    // 投稿から1時間以内であれば、編集を保存する。
                    if (!initialDefinition.createdAt.hasOneHourPassed()) {
                      await executeWithOverlayLoading(
                        ref,
                        action: () async {
                          await notifier.edit();
                          await ref.read(appRouterProvider).pop();
                        },
                        showErrorToast: true,
                        errorToastMessage: '保存できませんでした。もう一度お試しください。',
                        successToastMessage: '保存しました！',
                      );

                      return;
                    }

                    // 投稿から1時間以上経過している場合、新規投稿するかどうかを確認する。
                    ref.read(dialogControllerProvider).show(
                      _AlertCannotEditDialog(
                        onPost: () async {
                          late final String definitionId;
                          await executeWithOverlayLoading(
                            ref,
                            action: () async {
                              definitionId = await notifier.post();
                            },
                            showErrorToast: true,
                            errorToastMessage: '投稿できませんでした。もう一度お試しください。',
                            successToastMessage: '投稿しました！',
                          );

                          // 新規投稿した定義の詳細画面に遷移する。
                          await ref.read(appRouterProvider).popAndPush(
                                DefinitionDetailRoute(
                                  definitionId: definitionId,
                                ),
                              );
                        },
                      ),
                    );
                  }
                : null,
            child: Text(
              '保存',
              style: notifier.canEdit()
                  ? Theme.of(context).textTheme.titleLarge
                  : Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.3),
                      ),
            ),
          ),
        );
      },
      loading: () => Scaffold(
        appBar: AppBar(
          elevation: 0,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stackTrace) => Scaffold(
        appBar: AppBar(
          elevation: 0,
        ),
        body: Center(
          child: Text(error.toString()),
        ),
      ),
    );
  }
}

class _AlertCannotEditDialog extends ConsumerWidget {
  const _AlertCannotEditDialog({required this.onPost});

  /// 編集ができない際に、新規として投稿する場合に行う処理。
  final VoidCallback onPost;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            '投稿から1時間が経過したため保存できませんでした。',
            overflow: TextOverflow.clip,
          ),
          SizedBox(height: 8),
          Text(
            '代わりに、入力した内容で新規投稿しませんか？',
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
          onTap: () async {
            await context.popRoute();
            onPost();
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              '新規投稿する',
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
