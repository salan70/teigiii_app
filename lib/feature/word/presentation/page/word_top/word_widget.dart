import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/word_state.dart';
import 'word_widget_shimmer.dart';

class WordWidget extends ConsumerWidget {
  const WordWidget({super.key, required this.wordId});

  final String wordId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncWord = ref.watch(wordProvider(wordId));

    return asyncWord.when(
      data: (word) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
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
              const SizedBox(height: 24),
              Text(
                '${word.postedDefinitionCount}投稿',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        );
      },
      loading: WordWidgetShimmer.new,
      // TODO(me): 良い感じのエラー画面を作成（ダイアログをオーバーレイで出すのがいいかも）
      error: (error, stackTrace) => const Center(child: Text('エラー')),
    );
  }
}
