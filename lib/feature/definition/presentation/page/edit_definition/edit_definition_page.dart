import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/definition_for_write_notifier.dart';
import '../../../domain/definition_for_write.dart';
import '../../component/write_definition_base_page.dart';

@RoutePage()
class EditDefinitionPage extends ConsumerWidget {
  const EditDefinitionPage({
    super.key,
    required this.initialDefinitionForWrite,
  });

  final DefinitionForWrite initialDefinitionForWrite;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncDefinitionForWrite = ref
        .watch(definitionForWriteNotifierProvider(initialDefinitionForWrite));
    final notifier = ref.watch(
      definitionForWriteNotifierProvider(initialDefinitionForWrite).notifier,
    );

    return asyncDefinitionForWrite.when(
      data: (definitionForWrite) {
        final canEdit = notifier.canEdit();

        return WriteDefinitionBasePage(
          definitionForWrite: definitionForWrite,
          notifier: notifier,
          appBarActionWidget: InkWell(
            onTap: canEdit
                ? () async {
                    // await notifier.post();
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
