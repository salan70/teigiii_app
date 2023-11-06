import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/definition_for_write_notifier.dart';
import '../../../domain/definition.dart';
import '../../../util/write_definition_form_type.dart';
import '../../component/write_definition_base_page.dart';

/// 定義を投稿するページ
@RoutePage()
class PostDefinitionPage extends ConsumerWidget {
  const PostDefinitionPage({
    super.key,
    required this.initialDefinition,
    required this.autoFocusForm,
  });

  /// 遷移時にフォーカスするTextFormField。
  final WriteDefinitionFormType? autoFocusForm;

  /// 初期値として持つ [Definition]。
  /// TextFieldなどに初期表示させたい値がある場合はこの値を渡す。
  final Definition? initialDefinition;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initialDefinitionForWrite = initialDefinition?.toDefinitionForWrite();

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
                    await notifier.post();
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
