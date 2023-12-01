import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/common_provider/toast_controller.dart';
import '../feature/definition/application/definition_for_write_notifier.dart';
import '../feature/definition/domain/definition.dart';
import '../feature/definition/presentation/write_definition_base_page.dart';
import '../feature/definition/util/after_post_navigation_type.dart';
import '../util/extension/date_time_extension.dart';
import '../util/logger.dart';

@RoutePage()
class DefinitionEditPage extends ConsumerWidget {
  const DefinitionEditPage({
    super.key,
    required this.initialDefinition,
  });

  final Definition initialDefinition;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initialDefinitionForWrite = initialDefinition.toDefinitionForWrite();

    final asyncDefinitionForWrite = ref
        .watch(definitionForWriteNotifierProvider(initialDefinitionForWrite));
    final notifier = ref.watch(
      definitionForWriteNotifierProvider(initialDefinitionForWrite).notifier,
    );

    /// 編集（保存）ができない旨を伝えるダイアログを表示する
    Future<void> showAlertCannotEditDialog() async {
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
                onTap: () async {
                  await context.popRoute();
                  await notifier.post(AfterPostNavigationType.toDetail);
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
        },
      );
    }

    return asyncDefinitionForWrite.when(
      data: (definitionForWrite) {
        final canEdit = notifier.canEdit();

        return WriteDefinitionBasePage(
          definitionForWrite: definitionForWrite,
          notifier: notifier,
          appBarActionWidget: InkWell(
            onTap: canEdit
                ? () async {
                    primaryFocus?.unfocus();

                    if (!initialDefinition.createdAt.hasOneHourPassed()) {
                      // 投稿から1時間以内であれば、編集できる
                      await notifier.edit();
                      return;
                    }

                    if (notifier.canPost()) {
                      await showAlertCannotEditDialog();
                      return;
                    }

                    // canEdit()がtrueの場合、canPost()もtrueのため、
                    // ここに到達することはない想定
                    ref.read(toastControllerProvider.notifier).showToast(
                          '保存できませんでした。もう一度お試しください。',
                          causeError: true,
                        );
                    logger.e(
                      '定義編集画面にて、canEdit()がtrueなのにcanPost()がfalseという想定外の事態が発生しました。',
                    );
                    return;
                  }
                : null,
            child: Text(
              '保存',
              style: canEdit
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
