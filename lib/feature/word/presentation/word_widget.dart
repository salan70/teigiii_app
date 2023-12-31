import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../../core/common_widget/button/filled_button.dart';
import '../../../../../core/router/app_router.dart';
import '../../auth/application/auth_state.dart';
import '../../definition/domain/definition_for_write.dart';
import '../../definition/presentation/write_definition_base_page.dart';
import '../domain/word.dart';

class WordWidget extends ConsumerWidget {
  const WordWidget({super.key, required this.word});

  final Word word;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(24),
          Text(
            word.word,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Text(
            word.reading,
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const Gap(24),
          Text(
            '${word.postedDefinitionCount}投稿',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const Gap(8),
          Center(
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
              text: 'この語句の定義を投稿する',
            ),
          ),
          const Gap(8),
        ],
      ),
    );
  }
}
