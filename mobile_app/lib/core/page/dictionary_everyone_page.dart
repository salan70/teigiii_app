import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../feature/community_dictionary/application/community_word_list.dart';
import '../../feature/community_dictionary/domain/community_dictionary.dart';
import '../../feature/word/domain/word.dart';
import '../common_provider/top_level_scroll_controller_provider.dart';
import '../common_widget/button/to_global_search_button.dart';
import '../common_widget/error_and_retry_widget.dart';
import '../router/app_router.dart';

@RoutePage()
class DictionaryEveryoneRouterPage extends AutoRouter {
  const DictionaryEveryoneRouterPage({super.key});
}

/// 共有言葉を読み順で絞り込み・検索できる一覧。
///
/// @doc doc/specs/mobile-app-functional-spec.md#7-みんなの辞書
@RoutePage()
class DictionaryEveryonePage extends ConsumerStatefulWidget {
  const DictionaryEveryonePage({super.key});

  @override
  ConsumerState<DictionaryEveryonePage> createState() =>
      _DictionaryEveryonePageState();
}

class _DictionaryEveryonePageState
    extends ConsumerState<DictionaryEveryonePage> {
  final _searchController = TextEditingController();
  Timer? _debounce;
  CommunityWordFilter _filter = CommunityWordFilter.all;
  String _query = '';

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() => _query = value.trim());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = communityWordListProvider(_filter, _query);
    final state = ref.watch(provider);
    return GestureDetector(
      onTap: () => primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('みんなの辞書'),
          automaticallyImplyLeading: false,
          actions: [
            TextButton(
              onPressed: () => context.pushRoute(const WordRegistrationRoute()),
              child: const Text('言葉を登録'),
            ),
            const ToGlobalSearchButton(),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                textInputAction: TextInputAction.search,
                decoration: const InputDecoration(
                  prefixIcon: Icon(CupertinoIcons.search),
                  hintText: '表記・よみで検索',
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  for (final filter in CommunityWordFilter.values)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(filter.label),
                        selected: filter == _filter,
                        onSelected: (_) => setState(() => _filter = filter),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: state.when(
                data: (page) => _CommunityWordList(
                  words: page.list,
                  hasMore: page.hasMore,
                  isLoadingMore: state.isLoading,
                  controller: ref.watch(
                    topLevelScrollControllerProvider(
                      TopLevelTab.communityDictionary,
                    ),
                  ),
                  onFetchMore: () => ref.read(provider.notifier).fetchMore(),
                ),
                loading: () =>
                    const Center(child: CupertinoActivityIndicator()),
                error: (error, stackTrace) => Center(
                  child: ErrorAndRetryWidget.cannotInquire(
                    onRetry: () => ref.invalidate(provider),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CommunityWordList extends StatelessWidget {
  const _CommunityWordList({
    required this.words,
    required this.hasMore,
    required this.isLoadingMore,
    required this.controller,
    required this.onFetchMore,
  });

  final List<Word> words;
  final bool hasMore;
  final bool isLoadingMore;
  final ScrollController controller;
  final VoidCallback onFetchMore;

  @override
  Widget build(BuildContext context) {
    if (words.isEmpty) {
      return const Center(child: Text('条件に合う言葉はありません。'));
    }
    return NotificationListener<ScrollEndNotification>(
      onNotification: (notification) {
        if (notification.metrics.extentAfter == 0) {
          onFetchMore();
        }
        return false;
      },
      child: ListView.builder(
        controller: controller,
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        itemCount: words.length + (hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == words.length) {
            return isLoadingMore
                ? const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CupertinoActivityIndicator()),
                  )
                : const SizedBox(height: 1);
          }
          final word = words[index];
          final showHeading =
              index == 0 ||
              words[index - 1].initialSubGroupLabel !=
                  word.initialSubGroupLabel;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showHeading)
                Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 4),
                  child: Text(
                    word.initialSubGroupLabel,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(word.word),
                subtitle: Text(word.reading),
                trailing: Text('${word.postedDefinitionCount}定義'),
                onTap: () => context.pushRoute(WordTopRoute(wordId: word.id)),
              ),
            ],
          );
        },
      ),
    );
  }
}
