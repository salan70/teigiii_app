import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';

/// 表示中の画面名をフレーム計測へ伝える Observer.
///
/// `main.dart` の `FirebaseAnalyticsObserver` の隣に並べて使う。
/// auto_route の `navigatorObservers` は router ごとに呼ばれるため
/// 複数インスタンスが生成されるが、通知先は同一の集計器でよい。
///
/// タブ切替（`AutoTabsRouter`）は push / pop を伴わないため、
/// `AutoRouterObserver.didChangeTabRoute` を別途拾う。
class PerfScreenObserver extends AutoRouterObserver {
  PerfScreenObserver(this.onScreenChanged);

  final void Function(String screenName) onScreenChanged;

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
  void didChangeTabRoute(TabPageRoute route, TabPageRoute previousRoute) {
    super.didChangeTabRoute(route, previousRoute);
    onScreenChanged(route.name);
  }

  void _report(Route<dynamic>? route) {
    final name = route?.settings.name;
    if (name != null && name.isNotEmpty) {
      onScreenChanged(name);
    }
  }
}
