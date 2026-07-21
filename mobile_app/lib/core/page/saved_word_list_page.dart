import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/common_widget/infinity_scroll_widget.dart';
import '../../feature/word/domain/word.dart';
import '../../feature/word/presentation/word_tile.dart';
import '../../feature/word/presentation/word_tile_shimmer.dart';
import '../../feature/word_list/application/saved_word_list_state.dart';

@RoutePage()
class SavedWordListPage extends ConsumerWidget {
  const SavedWordListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('保存した言葉')),
      body: InfinityScrollWidget(
        listStateNotifierProvider: savedWordListStateNotifierProvider,
        fetchMore:
            ref.read(savedWordListStateNotifierProvider.notifier).fetchMore,
        tileBuilder: (item) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: WordTile(word: item as Word),
        ),
        contentPadding: EdgeInsets.zero,
        shimmerTile: const WordTileShimmer(),
        shimmerTileNumber: 8,
        emptyWidget: const SizedBox.shrink(),
      ),
    );
  }
}
