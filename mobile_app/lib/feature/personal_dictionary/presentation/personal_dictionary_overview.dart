import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/common_provider/top_level_scroll_controller_provider.dart';
import '../../../core/common_widget/button/account_menu_button.dart';
import '../../../core/common_widget/button/to_global_search_button.dart';
import '../../../core/common_widget/error_and_retry_widget.dart';
import '../../../core/router/app_router.dart';
import '../../definition/presentation/write_definition_base_page.dart';
import '../application/personal_dictionary_state.dart';
import '../domain/personal_dictionary.dart';

/// あなたの辞書の overview、専用 empty 状態、管理一覧への入口。
///
/// @doc doc/specs/mobile-app-functional-spec.md#6-あなたの辞書
class PersonalDictionaryOverviewView extends ConsumerWidget {
  const PersonalDictionaryOverviewView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overview = ref.watch(personalDictionaryOverviewProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('あなたの辞書'),
        actions: const [ToGlobalSearchButton(), AccountMenuButton()],
      ),
      body: overview.when(
        data: (data) => RefreshIndicator.adaptive(
          onRefresh: () async {
            ref.invalidate(personalDictionaryOverviewProvider);
            await ref.read(personalDictionaryOverviewProvider.future);
          },
          child: data.isEmpty
              ? _EmptyPersonalDictionary(
                  controller: ref.watch(
                    topLevelScrollControllerProvider(
                      TopLevelTab.personalDictionary,
                    ),
                  ),
                )
              : _OverviewContent(
                  overview: data,
                  controller: ref.watch(
                    topLevelScrollControllerProvider(
                      TopLevelTab.personalDictionary,
                    ),
                  ),
                ),
        ),
        loading: () => const Center(child: CupertinoActivityIndicator()),
        error: (error, stackTrace) => Center(
          child: ErrorAndRetryWidget.cannotInquire(
            onRetry: () => ref.invalidate(personalDictionaryOverviewProvider),
          ),
        ),
      ),
      floatingActionButton: overview.valueOrNull?.isEmpty == false
          ? FloatingActionButton.extended(
              heroTag: null,
              onPressed: () => _openDefinitionPost(context),
              icon: const Icon(CupertinoIcons.add),
              label: const Text('定義を書く'),
            )
          : null,
    );
  }

  static void _openDefinitionPost(BuildContext context) {
    context.pushRoute(
      DefinitionPostRoute(
        initialDefinitionForWrite: null,
        autoFocusForm: WriteDefinitionFormType.word,
      ),
    );
  }
}

class _EmptyPersonalDictionary extends StatelessWidget {
  const _EmptyPersonalDictionary({required this.controller});

  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: controller,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(32),
      children: [
        const Gap(80),
        Icon(
          Icons.menu_book_outlined,
          size: 72,
          color: Theme.of(context).colorScheme.primary,
        ),
        const Gap(24),
        Text(
          '言葉と自分の定義を、ここに積み重ねていきます。',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const Gap(24),
        ElevatedButton.icon(
          onPressed: () =>
              PersonalDictionaryOverviewView._openDefinitionPost(context),
          icon: const Icon(CupertinoIcons.add),
          label: const Text('最初の定義を書く'),
        ),
      ],
    );
  }
}

class _OverviewContent extends StatelessWidget {
  const _OverviewContent({required this.overview, required this.controller});

  final PersonalDictionaryOverview overview;
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: controller,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
      children: [
        _CountTile(
          label: '定義済みの言葉',
          count: overview.definedWordCount,
          icon: Icons.library_books_outlined,
          onTap: () => context.pushRoute(const DefinedWordListRoute()),
        ),
        _CountTile(
          label: '下書き',
          count: overview.draftCount,
          icon: Icons.edit_note_outlined,
          onTap: () => context.pushRoute(const DefinitionDraftListRoute()),
        ),
        _CountTile(
          label: '保存した言葉',
          count: overview.savedWordCount,
          icon: Icons.bookmark_outline,
          onTap: () => context.pushRoute(const SavedWordListRoute()),
        ),
        const Gap(24),
        Text('最近更新した定義', style: Theme.of(context).textTheme.titleLarge),
        const Gap(8),
        if (overview.recentDefinitions.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Text('まだ確定済みの定義はありません。'),
          )
        else
          for (final definition in overview.recentDefinitions)
            _RecentDefinitionTile(definition: definition),
      ],
    );
  }
}

class _CountTile extends StatelessWidget {
  const _CountTile({
    required this.label,
    required this.count,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final int count;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(label),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('$count', style: Theme.of(context).textTheme.titleLarge),
            const Gap(8),
            const Icon(CupertinoIcons.chevron_forward, size: 18),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}

class _RecentDefinitionTile extends StatelessWidget {
  const _RecentDefinitionTile({required this.definition});

  final RecentDefinition definition;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(definition.word),
      subtitle: Text(
        definition.body,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Icon(
        definition.isPublic ? Icons.public : Icons.lock_outline,
        size: 18,
      ),
      onTap: () =>
          context.pushRoute(DefinitionDetailRoute(definitionId: definition.id)),
    );
  }
}
