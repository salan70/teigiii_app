import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../feature/personal_dictionary/application/personal_dictionary_state.dart';
import '../../feature/personal_dictionary/domain/personal_dictionary.dart';
import '../common_widget/error_and_retry_widget.dart';
import '../router/app_router.dart';

@RoutePage()
class DefinedWordListPage extends ConsumerWidget {
  const DefinedWordListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(definedWordListProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('定義済みの言葉')),
      body: state.when(
        data: (page) => _DefinedWordList(page: page),
        loading: () => const Center(child: CupertinoActivityIndicator()),
        error: (error, stackTrace) => Center(
          child: ErrorAndRetryWidget.cannotInquire(
            onRetry: () => ref.invalidate(definedWordListProvider),
          ),
        ),
      ),
    );
  }
}

class _DefinedWordList extends ConsumerWidget {
  const _DefinedWordList({required this.page});

  final PagedItems<DefinedWord> page;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (page.items.isEmpty) {
      return const Center(child: Text('定義済みの言葉はありません。'));
    }
    return NotificationListener<ScrollEndNotification>(
      onNotification: (notification) {
        if (notification.metrics.extentAfter == 0) {
          ref.read(definedWordListProvider.notifier).fetchMore();
        }
        return false;
      },
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: page.items.length + (page.hasMore ? 1 : 0),
        separatorBuilder: (_, _) => const Divider(),
        itemBuilder: (context, index) {
          if (index == page.items.length) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CupertinoActivityIndicator()),
            );
          }
          final item = page.items[index];
          return ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(item.word),
            subtitle: Text(
              '${item.reading}\n公開 ${item.publicCount}・非公開 ${item.privateCount}',
            ),
            isThreeLine: true,
            trailing: const Icon(CupertinoIcons.chevron_forward, size: 18),
            onTap: () => context.pushRoute(WordTopRoute(wordId: item.id)),
          );
        },
      ),
    );
  }
}
