import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/common_widget/infinity_scroll_widget.dart';
import '../../../core/common_widget/shimmer_widget.dart';
import '../../../core/common_widget/simple_empty_widget.dart';
import '../../../core/router/app_router.dart';
import '../application/public_dictionary_state.dart';
import '../domain/public_dictionary.dart';

class PublicDictionaryList extends ConsumerWidget {
  const PublicDictionaryList({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = publicDictionaryNotifierProvider(userId);
    return InfinityScrollWidget(
      listStateNotifierProvider: provider,
      fetchMore: ref.read(provider.notifier).fetchMore,
      tileBuilder: (item) =>
          _PublicDictionaryTile(item: item as PublicDictionaryItem),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      shimmerTile: const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: ShimmerWidget.rectangular(height: 56),
      ),
      shimmerTileNumber: 5,
      emptyWidget: const SimpleEmptyWidget(message: '公開されている定義はありません。'),
    );
  }
}

class _PublicDictionaryTile extends StatelessWidget {
  const _PublicDictionaryTile({required this.item});

  final PublicDictionaryItem item;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.pushRoute(WordTopRoute(wordId: item.word.id)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.word.word,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(item.word.reading),
                    ],
                  ),
                ),
                Text('${item.publicDefinitionCount}定義'),
                const Gap(4),
                const Icon(CupertinoIcons.chevron_forward, size: 18),
              ],
            ),
          ),
          const Divider(height: 1),
        ],
      ),
    );
  }
}
