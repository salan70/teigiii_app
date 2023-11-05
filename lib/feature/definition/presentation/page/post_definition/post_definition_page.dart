import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/definition_for_write_notifier.dart';
import '../../../util/write_definition_form_type.dart';
import '../../component/write_definition_base_page.dart';

@RoutePage()
class PostDefinitionPage extends ConsumerWidget {
  const PostDefinitionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncDefinitionForWrite =
        ref.watch(definitionForWriteNotifierProvider(null));
    final notifier = ref.watch(
      definitionForWriteNotifierProvider(null).notifier,
    );

    return asyncDefinitionForWrite.when(
      data: (definitionForWrite) {
        final canPost = notifier.canPost();

        return WriteDefinitionBasePage(
          autoFocusForm: WriteDefinitionFormType.word,
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
