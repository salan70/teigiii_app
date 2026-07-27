import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teigi_app/core/common_widget/infinity_scroll_widget.dart';
import 'package:teigi_app/feature/admob/presentation/banner_ad_widget.dart';
import 'package:teigi_app/util/interface/list_state.dart';

/// テスト用の [ListState] 実装。
class _TestListState implements ListState {
  const _TestListState({required this.list});

  @override
  final List<dynamic> list;

  // 追加読み込みの indicator を出さないことで、tile の可視件数を決定的にする。
  @override
  bool get hasMore => false;

  @override
  String? get nextCursor => null;
}

/// [InfinityScrollWidget] に渡すテスト用の Notifier.
///
/// 呼び出し元の Notifier はすべて `@Riverpod(keepAlive: true)` で
/// 生成されているため、非 autoDispose の [AsyncNotifier] で型を合わせている。
class _TestNotifier extends AsyncNotifier<_TestListState> {
  /// build 時に返す state. loading を維持したい場合は null にする。
  static _TestListState? initialState = const _TestListState(list: []);

  @override
  FutureOr<_TestListState> build() {
    final initial = initialState;
    if (initial == null) {
      // 永久 loading.
      return Completer<_TestListState>().future;
    }
    return initial;
  }

  void setListState(_TestListState next) => state = AsyncData(next);
}

final _testProvider = AsyncNotifierProvider<_TestNotifier, _TestListState>(
  _TestNotifier.new,
);

/// tile の高さ。既定サーフェス（800x600）での可視件数を決定的にするため固定する。
const _tileHeight = 100.0;

/// 高さ600のビューポートに [_tileHeight] の tile を並べたときの可視件数。
/// cacheExtent 分の先読みを考慮しても、これを大きく超えて build されるなら
/// 遅延構築が壊れている。
const _lazyBuildUpperBound = 30;

Widget _buildTarget({
  required List<int> builtIndexes,
  bool showBannerAd = false,
  Widget? emptyWidget,
  int itemCountForShimmer = 8,
  Widget Function(Widget child)? wrapBody,
}) {
  final body = InfinityScrollWidget(
    listStateNotifierProvider: _testProvider,
    fetchMore: () {},
    tileBuilder: (item) {
      builtIndexes.add(item as int);
      return SizedBox(height: _tileHeight, child: Text('tile-$item'));
    },
    contentPadding: EdgeInsets.zero,
    shimmerTile: const SizedBox(height: _tileHeight, child: Text('shimmer')),
    shimmerTileNumber: itemCountForShimmer,
    emptyWidget: emptyWidget,
    showBannerAd: showBannerAd,
  );

  return ProviderScope(
    overrides: [
      // 本番の BannerAdWidget は AdMob の MethodChannel と dotenv に依存し、
      // widget test で描画できないためダミーに差し替える。
      bannerAdWidgetProvider.overrideWithValue(
        const SizedBox(key: ValueKey('banner-ad'), height: 64),
      ),
    ],
    child: MaterialApp(
      home: Scaffold(body: wrapBody != null ? wrapBody(body) : body),
    ),
  );
}

void main() {
  setUp(() {
    _TestNotifier.initialState = const _TestListState(list: []);
  });

  group('遅延構築', () {
    testWidgets('件数が多くても初回 pump で tileBuilder が全件呼ばれない', (tester) async {
      _TestNotifier.initialState = _TestListState(
        list: List.generate(500, (index) => index),
      );
      final builtIndexes = <int>[];

      await tester.pumpWidget(_buildTarget(builtIndexes: builtIndexes));
      await tester.pumpAndSettle();

      // ビューポート外まで eager に build されていないこと。
      expect(builtIndexes.toSet().length, lessThan(_lazyBuildUpperBound));
      expect(builtIndexes, isNot(contains(499)));
      expect(find.text('tile-0'), findsOneWidget);
      expect(find.text('tile-499'), findsNothing);
    });

    testWidgets('スクロールすると必要な範囲だけ追加で build される', (tester) async {
      _TestNotifier.initialState = _TestListState(
        list: List.generate(500, (index) => index),
      );
      final builtIndexes = <int>[];

      await tester.pumpWidget(_buildTarget(builtIndexes: builtIndexes));
      await tester.pumpAndSettle();
      builtIndexes.clear();

      await tester.drag(
        find.byType(CustomScrollView),
        const Offset(0, -2000),
        // BouncingScrollPhysics 下でも安定させるため touch slop を無効化する。
        touchSlopY: 0,
      );
      await tester.pumpAndSettle();

      // 追加 build は可視域相当に収まること（全件 build されない）。
      expect(builtIndexes.toSet().length, lessThan(_lazyBuildUpperBound));
      expect(find.text('tile-20'), findsOneWidget);
      expect(find.text('tile-0'), findsNothing);
    });

    testWidgets('showBannerAd: true でも遅延構築され、7件ごとに広告が入る', (tester) async {
      _TestNotifier.initialState = _TestListState(
        list: List.generate(500, (index) => index),
      );
      final builtIndexes = <int>[];

      await tester.pumpWidget(
        _buildTarget(builtIndexes: builtIndexes, showBannerAd: true),
      );
      await tester.pumpAndSettle();

      // 広告ありの構成（tile が Column で 1 段深くなる）でも遅延構築されること。
      expect(builtIndexes.toSet().length, lessThan(_lazyBuildUpperBound));
      expect(builtIndexes, isNot(contains(499)));

      // index 7 までスクロールすると、その直前に広告が 1 つ入っていること。
      await tester.drag(
        find.byType(CustomScrollView),
        const Offset(0, -500),
        touchSlopY: 0,
      );
      await tester.pumpAndSettle();

      expect(find.text('tile-7'), findsOneWidget);
      expect(find.byKey(const ValueKey('banner-ad')), findsOneWidget);
      // 広告は index 0 の直前には入らない。
      expect(
        tester.getTopLeft(find.byKey(const ValueKey('banner-ad'))).dy,
        lessThan(tester.getTopLeft(find.text('tile-7')).dy),
      );
    });

    testWidgets('初回ローディングの shimmer も全件 build されない', (tester) async {
      _TestNotifier.initialState = null;
      final builtIndexes = <int>[];

      await tester.pumpWidget(
        _buildTarget(builtIndexes: builtIndexes, itemCountForShimmer: 500),
      );
      await tester.pump();

      expect(find.text('shimmer'), findsWidgets);
      expect(
        find.text('shimmer').evaluate().length,
        lessThan(_lazyBuildUpperBound),
      );
    });
  });

  group('表示分岐', () {
    testWidgets('空リストでは emptyWidget を表示し例外が出ない', (tester) async {
      await tester.pumpWidget(
        _buildTarget(
          builtIndexes: [],
          emptyWidget: const Text('empty', key: ValueKey('empty')),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('empty')), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('多数の状態から0件へ更新しても例外にならない', (tester) async {
      _TestNotifier.initialState = _TestListState(
        list: List.generate(100, (index) => index),
      );
      final builtIndexes = <int>[];

      await tester.pumpWidget(
        _buildTarget(
          builtIndexes: builtIndexes,
          emptyWidget: const Text('empty', key: ValueKey('empty')),
        ),
      );
      await tester.pumpAndSettle();

      final container = ProviderScope.containerOf(
        tester.element(find.byType(CustomScrollView)),
      );
      container
          .read(_testProvider.notifier)
          .setListState(const _TestListState(list: []));
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('empty')), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('dispose 時に例外が出ない', (tester) async {
      _TestNotifier.initialState = _TestListState(
        list: List.generate(100, (index) => index),
      );

      await tester.pumpWidget(_buildTarget(builtIndexes: []));
      await tester.pumpAndSettle();

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });
  });

  group('NestedScrollView 配下', () {
    testWidgets('SliverAppBar がスクロールに連動して collapse する', (tester) async {
      _TestNotifier.initialState = _TestListState(
        list: List.generate(500, (index) => index),
      );

      await tester.pumpWidget(
        _buildTarget(
          builtIndexes: [],
          wrapBody: (child) => NestedScrollView(
            headerSliverBuilder: (context, _) => [
              // 呼び出し元（word_list_page）に合わせて pinned にする。
              const SliverAppBar(
                pinned: true,
                expandedHeight: 200,
                title: Text('header'),
              ),
            ],
            body: child,
          ),
        ),
      );
      await tester.pumpAndSettle();

      final expandedHeight = tester.getSize(find.byType(AppBar)).height;
      expect(expandedHeight, greaterThan(100));

      await tester.drag(
        find.byType(CustomScrollView),
        const Offset(0, -300),
        touchSlopY: 0,
      );
      await tester.pumpAndSettle();

      // PrimaryScrollController 経由で header に連動していること。
      expect(
        tester.getSize(find.byType(AppBar)).height,
        lessThan(expandedHeight),
      );
    });
  });
}
