import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/common_widget/error_and_retry_widget.dart';
import '../../definition/presentation/definition_tile.dart';
import '../../definition/presentation/definition_tile_shimmer.dart';
import '../../definition_list/appication/definition_id_list_state.dart';
import '../../definition_list/presentation/definition_list.dart';
import '../../definition_list/util/definition_feed_type.dart';

class WordMyDefinitionsPreview extends ConsumerWidget {
  const WordMyDefinitionsPreview({super.key, required this.wordId});

  static const _previewLimit = 3;

  final String wordId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = definitionIdListStateNotifierProvider(
      DefinitionFeedType.wordMine,
      wordId: wordId,
    );
    final asyncDefinitions = ref.watch(provider);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('あなたの定義', style: Theme.of(context).textTheme.titleLarge),
          const Gap(12),
          asyncDefinitions.when(
            data: (state) {
              if (state.list.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: Text('まだ定義がありません')),
                );
              }

              final previewIds = state.list.take(_previewLimit).toList();
              return Column(
                children: [
                  for (final id in previewIds) DefinitionTile(definitionId: id),
                  if (state.hasMore || state.list.length > _previewLimit)
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).push<void>(
                            MaterialPageRoute(
                              builder: (_) =>
                                  WordMyDefinitionsPage(wordId: wordId),
                            ),
                          );
                        },
                        child: const Text('すべて見る'),
                      ),
                    ),
                ],
              );
            },
            loading: () => const Column(
              children: [DefinitionTileShimmer(), CupertinoActivityIndicator()],
            ),
            error: (_, _) => Center(
              child: SimpleErrorAndRetryWidget(
                onRetry: () => ref.invalidate(provider),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WordMyDefinitionsPage extends StatelessWidget {
  const WordMyDefinitionsPage({super.key, required this.wordId});

  final String wordId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('あなたの定義')),
      body: DefinitionList(
        definitionFeedType: DefinitionFeedType.wordMine,
        wordId: wordId,
        emptyWidget: const Center(child: Text('まだ定義がありません')),
      ),
    );
  }
}
