import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';

/// タブ切替時に leaf route を復元するための共有状態。
///
/// `navigatorObservers` ファクトリは nested navigator ごとに
/// [PerfScreenObserver] を新規生成するため、インスタンス変数では
/// push で見た leaf を didChangeTabRoute 側へ渡せない。
class PerfScreenRouteMemory {
  String? activeTabWrapper;
  final leafByTabWrapper = <String, String>{};

  @visibleForTesting
  void reset() {
    activeTabWrapper = null;
    leafByTabWrapper.clear();
  }
}

/// 表示中の画面名をフレーム計測へ伝える Observer.
///
/// `main.dart` の `FirebaseAnalyticsObserver` の隣に並べて使う。
/// auto_route の `navigatorObservers` は router ごとに呼ばれるため
/// 複数インスタンスが生成されるが、通知先は同一の集計器でよい。
///
/// タブ切替（`AutoTabsRouter`）は push / pop を伴わないため、
/// `didInitTabRoute` / `didChangeTabRoute` を別途拾う。
/// `TabPageRoute.routeInfo` はネストした StackRouter への追加 push を
/// 反映しないため、push / pop / replace で見た leaf をタブごとに記憶し、
/// 切替時はそれを通知する。記憶は [memory] でインスタンス間共有する。
class PerfScreenObserver extends AutoRouterObserver {
  PerfScreenObserver(this.onScreenChanged, {PerfScreenRouteMemory? memory})
    : memory = memory ?? sharedMemory;

  /// アプリ全体で共有するデフォルト記憶。
  @visibleForTesting
  static final sharedMemory = PerfScreenRouteMemory();

  final void Function(String screenName) onScreenChanged;
  final PerfScreenRouteMemory memory;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _report(route);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _report(previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _report(newRoute);
  }

  @override
  void didInitTabRoute(TabPageRoute route, TabPageRoute? previousRoute) {
    super.didInitTabRoute(route, previousRoute);
    _activateTab(route);
  }

  @override
  void didChangeTabRoute(TabPageRoute route, TabPageRoute previousRoute) {
    super.didChangeTabRoute(route, previousRoute);
    _activateTab(route);
  }

  void _activateTab(TabPageRoute route) {
    memory.activeTabWrapper = route.name;

    final remembered = memory.leafByTabWrapper[route.name];
    if (remembered != null) {
      onScreenChanged(remembered);
      return;
    }

    // 未訪問タブ: match の初期 children があればそれを使い、
    // なければ直後の didPush に任せる。
    final match = route.routeInfo;
    if (match.hasChildren) {
      final leaf = match.flattened.last.name;
      memory.leafByTabWrapper[route.name] = leaf;
      onScreenChanged(leaf);
    }
  }

  void _report(Route<dynamic>? route) {
    final name = route?.settings.name;
    if (name == null || name.isEmpty) {
      return;
    }

    // Nested AutoRouter の shell 自体は計測対象の画面ではない。
    if (_isTabWrapperName(name)) {
      memory.activeTabWrapper = name;
      return;
    }

    final tab = memory.activeTabWrapper;
    if (tab != null) {
      memory.leafByTabWrapper[tab] = name;
    }
    onScreenChanged(name);
  }

  /// BasePage のタブに渡す `*RouterRoute` を shell とみなす。
  ///
  /// `replaceInRouteName: 'Page,Route'` により Nested `*RouterPage` は
  /// `*RouterRoute` になる。表示中の leaf ではない。
  bool _isTabWrapperName(String name) => name.endsWith('RouterRoute');
}
