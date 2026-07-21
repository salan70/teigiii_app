import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../feature/user_search/application/user_search_state.dart';
import '../../feature/user_search/domain/user_search_result.dart';
import '../../feature/user_search/presentation/user_search_result_tile.dart';
import '../../feature/word/domain/word.dart';
import '../../feature/word/presentation/word_tile.dart';
import '../../feature/word/presentation/word_tile_shimmer.dart';
import '../../feature/word_list/application/word_list_state_by_search_word.dart';
import '../common_widget/infinity_scroll_widget.dart';
import '../common_widget/shimmer_widget.dart';
import '../common_widget/simple_empty_widget.dart';

/// @doc doc/specs/mobile-app-functional-spec.md#10-グローバル検索
@RoutePage()
class GlobalSearchPage extends ConsumerStatefulWidget {
  const GlobalSearchPage({super.key});

  @override
  ConsumerState<GlobalSearchPage> createState() => _GlobalSearchPageState();
}

class _GlobalSearchPageState extends ConsumerState<GlobalSearchPage> {
  final _controller = TextEditingController();
  String? _query;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit(String value) {
    final query = value.trim();
    if (query.isEmpty) {
      return;
    }
    setState(() => _query = query);
  }

  @override
  Widget build(BuildContext context) {
    final query = _query;
    return Scaffold(
      appBar: AppBar(title: const Text('検索')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _controller,
              autofocus: true,
              textInputAction: TextInputAction.search,
              onSubmitted: _submit,
              decoration: InputDecoration(
                hintText: '言葉またはユーザーを検索',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  tooltip: '検索',
                  onPressed: () => _submit(_controller.text),
                  icon: const Icon(Icons.arrow_forward),
                ),
              ),
            ),
          ),
          Expanded(
            child: query == null
                ? const Center(child: Text('検索語を入力してください'))
                : _SearchResults(query: query),
          ),
        ],
      ),
    );
  }
}

class _SearchResults extends ConsumerWidget {
  const _SearchResults({required this.query});

  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wordProvider = wordListStateBySearchWordNotifierProvider(query);
    final userProvider = userSearchResultNotifierProvider(query);
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(text: '言葉'),
              Tab(text: 'ユーザー'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                InfinityScrollWidget(
                  listStateNotifierProvider: wordProvider,
                  fetchMore: ref.read(wordProvider.notifier).fetchMore,
                  tileBuilder: (item) => WordTile(word: item as Word),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  shimmerTile: const WordTileShimmer(),
                  shimmerTileNumber: 4,
                  emptyWidget: const SimpleEmptyWidget(
                    message: '言葉が見つかりませんでした。',
                  ),
                ),
                InfinityScrollWidget(
                  listStateNotifierProvider: userProvider,
                  fetchMore: ref.read(userProvider.notifier).fetchMore,
                  tileBuilder: (item) =>
                      UserSearchResultTile(result: item as UserSearchResult),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  shimmerTile: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: ShimmerWidget.rectangular(height: 56),
                  ),
                  shimmerTileNumber: 4,
                  emptyWidget: const SimpleEmptyWidget(
                    message: 'ユーザーが見つかりませんでした。',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
