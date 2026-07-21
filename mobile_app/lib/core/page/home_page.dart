import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../feature/definition/presentation/post_definition_fab.dart';
import '../../feature/definition_list/presentation/definition_list.dart';
import '../../feature/definition_list/util/definition_feed_type.dart';
import '../../feature/timeline/presentation/discover_timeline.dart';
import '../../feature/timeline/repository/timeline_tab_repository.dart';
import '../../util/extension/scroll_controller_extension.dart';
import '../common_provider/key_provider.dart';
import '../common_provider/top_level_scroll_controller_provider.dart';
import '../common_widget/button/to_global_search_button.dart';
import '../common_widget/simple_empty_widget.dart';
import '../common_widget/stickey_tab_bar_deligate.dart';

@RoutePage()
class HomeRouterPage extends AutoRouter {
  const HomeRouterPage({super.key});
}

/// 完全新着の見つけるとフォロー中の定義を切り替えるタイムライン。
///
/// @doc doc/specs/mobile-app-functional-spec.md#9-タイムライン
@RoutePage()
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this)
      ..addListener(_saveSelectedTab);
    unawaited(_restoreSelectedTab());
  }

  Future<void> _restoreSelectedTab() async {
    final index = await ref.read(timelineTabRepositoryProvider).load();
    if (mounted) {
      _tabController.index = index;
    }
  }

  void _saveSelectedTab() {
    if (!_tabController.indexIsChanging) {
      unawaited(
        ref.read(timelineTabRepositoryProvider).save(_tabController.index),
      );
    }
  }

  @override
  void dispose() {
    _tabController
      ..removeListener(_saveSelectedTab)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          key: ref.watch(globalKeyProvider),
          controller: ref.watch(
            topLevelScrollControllerProvider(TopLevelTab.timeline),
          ),
          headerSliverBuilder: (BuildContext context, bool _) => [
            const SliverAppBar(
              elevation: 0,
              title: Text('タイムライン'),
              automaticallyImplyLeading: false,
              actions: [ToGlobalSearchButton()],
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: StickyTabBarDelegate(
                tabBar: TabBar(
                  controller: _tabController,
                  labelStyle: Theme.of(context).textTheme.titleMedium,
                  indicatorWeight: 3,
                  tabs: const [
                    Tab(text: '見つける'),
                    Tab(text: 'フォロー中'),
                  ],
                  onTap: (index) {
                    if (_tabController.index == index &&
                        !_tabController.indexIsChanging) {
                      PrimaryScrollController.of(context).scrollToTop();
                    }
                  },
                ),
              ),
            ),
          ],
          body: TabBarView(
            controller: _tabController,
            children: const [
              DiscoverTimelineView(),
              DefinitionList(
                definitionFeedType: DefinitionFeedType.homeFollowing,
                emptyWidget: SimpleEmptyWidget(
                  message: 'フォローしたユーザーの投稿が表示されます🏄‍♂',
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: const PostDefinitionFAB(),
    );
  }
}
