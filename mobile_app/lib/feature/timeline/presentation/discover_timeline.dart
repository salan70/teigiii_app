import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common_widget/error_and_retry_widget.dart';
import '../../../core/router/app_router.dart';
import '../../definition/presentation/definition_tile.dart';
import '../application/timeline_state.dart';
import '../domain/timeline.dart';

class DiscoverTimelineView extends ConsumerWidget {
  const DiscoverTimelineView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(discoverTimelineProvider);
    return state.when(
      data: (page) => RefreshIndicator.adaptive(
        onRefresh: () async {
          ref.invalidate(discoverTimelineProvider);
          await ref.read(discoverTimelineProvider.future);
        },
        child: _DiscoverList(
          page: page,
          isLoadingMore: state.isLoading,
          onFetchMore: () =>
              ref.read(discoverTimelineProvider.notifier).fetchMore(),
        ),
      ),
      loading: () => const Center(child: CupertinoActivityIndicator()),
      error: (error, stackTrace) => Center(
        child: ErrorAndRetryWidget.cannotInquire(
          onRetry: () => ref.invalidate(discoverTimelineProvider),
        ),
      ),
    );
  }
}

class _DiscoverList extends StatelessWidget {
  const _DiscoverList({
    required this.page,
    required this.isLoadingMore,
    required this.onFetchMore,
  });

  final TimelinePage page;
  final bool isLoadingMore;
  final VoidCallback onFetchMore;

  @override
  Widget build(BuildContext context) {
    if (page.items.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [
          SizedBox(height: 160),
          Center(child: Text('新しい活動がありません。')),
        ],
      );
    }
    return NotificationListener<ScrollEndNotification>(
      onNotification: (notification) {
        if (notification.metrics.extentAfter == 0) {
          onFetchMore();
        }
        return false;
      },
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: page.items.length + (page.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == page.items.length) {
            return isLoadingMore
                ? const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CupertinoActivityIndicator()),
                  )
                : const SizedBox(height: 1);
          }
          return switch (page.items[index]) {
            TimelineDefinitionItem(:final definitionId) => DefinitionTile(
              definitionId: definitionId,
            ),
            final TimelineWordRegisteredItem item => _WordRegisteredTile(
              item: item,
            ),
          };
        },
      ),
    );
  }
}

class _WordRegisteredTile extends StatelessWidget {
  const _WordRegisteredTile({required this.item});

  final TimelineWordRegisteredItem item;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
          leading: const CircleAvatar(child: Icon(Icons.auto_stories_outlined)),
          title: Text(item.word),
          subtitle: Text('${item.reading}\n言葉が登録されました'),
          isThreeLine: true,
          trailing: const Icon(CupertinoIcons.chevron_forward, size: 18),
          onTap: () => context.pushRoute(WordTopRoute(wordId: item.wordId)),
        ),
        const Divider(),
      ],
    );
  }
}
