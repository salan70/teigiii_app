import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../feature/personal_dictionary/application/personal_dictionary_state.dart';
import '../../feature/personal_dictionary/domain/personal_dictionary.dart';
import '../common_widget/error_and_retry_widget.dart';
import '../router/app_router.dart';

@RoutePage()
class SavedWordListPage extends ConsumerWidget {
  const SavedWordListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(savedWordListProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('保存した言葉')),
      body: state.when(
        data: (page) => _SavedWordList(page: page),
        loading: () => const Center(child: CupertinoActivityIndicator()),
        error: (error, stackTrace) => Center(
          child: ErrorAndRetryWidget.cannotInquire(
            onRetry: () => ref.invalidate(savedWordListProvider),
          ),
        ),
      ),
    );
  }
}

class _SavedWordList extends ConsumerWidget {
  const _SavedWordList({required this.page});

  final PagedItems<SavedWord> page;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (page.items.isEmpty) {
      return const Center(child: Text('保存した言葉はありません。'));
    }
    return NotificationListener<ScrollEndNotification>(
      onNotification: (notification) {
        if (notification.metrics.extentAfter == 0) {
          ref.read(savedWordListProvider.notifier).fetchMore();
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
            subtitle: Text(item.reading),
            trailing: Text(item.isDefinedByMe ? '定義済み' : '未定義'),
            onTap: () => context.pushRoute(WordTopRoute(wordId: item.id)),
          );
        },
      ),
    );
  }
}
