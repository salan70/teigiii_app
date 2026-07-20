import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../../core/common_widget/button/filled_button.dart';
import '../../../../../core/router/app_router.dart';
import '../../auth/application/auth_state.dart';
import '../../definition/domain/definition_for_write.dart';
import '../../definition/presentation/write_definition_base_page.dart';
import '../application/word_save_controller.dart';
import '../domain/word.dart';

class WordWidget extends ConsumerWidget {
  const WordWidget({super.key, required this.word});

  final Word word;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedOverride = ref.watch(wordSavedOverrideProvider(word.id));
    final isSaved = savedOverride ?? word.isSavedByMe;
    final isSaving = ref.watch(wordSaveInProgressProvider(word.id));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(24),
          Text(word.word, style: Theme.of(context).textTheme.titleLarge),
          Text(
            word.reading,
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(24),
          Text(
            '公開定義 ${word.postedDefinitionCount}件',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const Gap(8),
          Row(
            children: [
              Expanded(
                child: PrimaryFilledButton(
                  onPressed: () {
                    context.pushRoute(
                      DefinitionPostRoute(
                        initialDefinitionForWrite: DefinitionForWrite.fromWord(
                          word,
                          ref.read(userIdProvider)!,
                        ),
                        autoFocusForm: WriteDefinitionFormType.definition,
                      ),
                    );
                  },
                  text: 'この言葉を定義する',
                ),
              ),
              const Gap(8),
              IconButton(
                key: const Key('word-save-button'),
                onPressed: isSaving
                    ? null
                    : () async {
                        try {
                          await ref
                              .read(wordSaveControllerProvider)
                              .toggle(word);
                        } on Object catch (_) {
                          if (!context.mounted) {
                            return;
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('保存状態を更新できませんでした。')),
                          );
                        }
                      },
                tooltip: isSaved ? '保存を解除' : '保存',
                icon: Icon(isSaved ? Icons.bookmark : Icons.bookmark_border),
              ),
            ],
          ),
          const Gap(8),
        ],
      ),
    );
  }
}
