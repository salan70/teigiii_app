import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../feature/definition/application/definition_for_write_notifier.dart';
import '../feature/definition/domain/definition_for_write.dart';
import '../feature/definition/presentation/write_definition_base_page.dart';
import '../feature/definition/util/after_post_navigation_type.dart';

/// 定義を投稿するページ
@RoutePage()
class DefinitionPostPage extends ConsumerWidget {
  const DefinitionPostPage({
    super.key,
    required this.initialDefinitionForWrite,
    required this.autoFocusForm,
    this.afterPostNavigation = AfterPostNavigationType.pop,
  });

  /// 遷移時にフォーカスするTextFormField。
  final WriteDefinitionFormType? autoFocusForm;

  /// 初期値として持つ [DefinitionForWrite]。
  /// TextFieldなどに初期表示させたい値がある場合はこの値を渡す。
  final DefinitionForWrite? initialDefinitionForWrite;

  /// 投稿完了後の遷移先
  ///
  /// - [AfterPostNavigationType.pop]（デフォルト）の場合、前の画面に戻る
  /// - [AfterPostNavigationType.toDetail] の場合、投稿した定義の詳細画面に遷移する
  final AfterPostNavigationType afterPostNavigation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncDefinitionForWrite = ref
        .watch(definitionForWriteNotifierProvider(initialDefinitionForWrite));
    final notifier = ref.watch(
      definitionForWriteNotifierProvider(initialDefinitionForWrite).notifier,
    );

    return asyncDefinitionForWrite.when(
      data: (definitionForWrite) {
        final canPost = notifier.canPost();

        return WriteDefinitionBasePage(
          autoFocusForm: autoFocusForm,
          definitionForWrite: definitionForWrite,
          notifier: notifier,
          appBarActionWidget: InkWell(
            onTap: canPost
                ? () async {
                    primaryFocus?.unfocus();

                    await notifier.post(afterPostNavigation);
                  }
                : null,
            child: Text(
              '投稿',
              style: canPost
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
