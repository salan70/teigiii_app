import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../feature/definition/domain/definition_draft.dart';
import '../../feature/definition/presentation/write_definition_base_page.dart';
import '../../feature/personal_dictionary/application/personal_dictionary_state.dart';
import '../../feature/personal_dictionary/domain/personal_dictionary.dart';
import '../common_widget/error_and_retry_widget.dart';
import '../router/app_router.dart';

@RoutePage()
class DefinitionDraftListPage extends ConsumerWidget {
  const DefinitionDraftListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(definitionDraftListProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('下書き')),
      body: state.when(
        data: (page) => _DraftList(page: page),
        loading: () => const Center(child: CupertinoActivityIndicator()),
        error: (error, stackTrace) => Center(
          child: ErrorAndRetryWidget.cannotInquire(
            onRetry: () => ref.invalidate(definitionDraftListProvider),
          ),
        ),
      ),
    );
  }
}

class _DraftList extends ConsumerWidget {
  const _DraftList({required this.page});

  final PagedItems<DefinitionDraft> page;

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    DefinitionDraft draft,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        content: const Text('この下書きを削除しますか？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('削除'),
          ),
        ],
      ),
    );
    if (confirmed != true) {
      return;
    }
    try {
      await ref.read(definitionDraftListProvider.notifier).delete(draft.id);
    } on Object {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('下書きを削除できませんでした。')));
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (page.items.isEmpty) {
      return const Center(child: Text('下書きはありません。'));
    }
    return NotificationListener<ScrollEndNotification>(
      onNotification: (notification) {
        if (notification.metrics.extentAfter == 0) {
          ref.read(definitionDraftListProvider.notifier).fetchMore();
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
          final draft = page.items[index];
          return ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              draft.displayLabel,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(draft.isPublic ? '公開で投稿予定' : '非公開で投稿予定'),
            trailing: IconButton(
              tooltip: '下書きを削除',
              onPressed: () => _confirmDelete(context, ref, draft),
              icon: const Icon(CupertinoIcons.delete),
            ),
            onTap: () => context.pushRoute(
              DefinitionPostRoute(
                draftId: draft.id,
                initialDefinitionForWrite: null,
                autoFocusForm: WriteDefinitionFormType.definition,
              ),
            ),
          );
        },
      ),
    );
  }
}
