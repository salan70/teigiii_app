import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

/// [CupertinoSliverRefreshControl]のbuilderで使用する想定
///
/// [CupertinoActivityIndicator]のradiusを任意の値するために作成
/// 中身は、[CupertinoSliverRefreshControl.buildRefreshIndicator]の大部分をコピー
Widget buildCustomRefreshIndicator(
  BuildContext context,
  RefreshIndicatorMode refreshState,
  double pulledExtent,
  double refreshTriggerPullDistance,
  double refreshIndicatorExtent,
) {
  final percentageComplete =
      clampDouble(pulledExtent / refreshTriggerPullDistance, 0, 1);
  const margin = 16.0;
  const radius = 10.0;

  return Center(
    child: Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        Positioned(
          top: margin,
          left: 0,
          right: 0,
          child: _buildIndicatorForRefreshState(
            refreshState,
            radius,
            percentageComplete,
          ),
        ),
      ],
    ),
  );
}

Widget _buildIndicatorForRefreshState(
  RefreshIndicatorMode refreshState,
  double radius,
  double percentageComplete,
) {
  switch (refreshState) {
    case RefreshIndicatorMode.drag:
      // While we're dragging, we draw individual ticks of the spinner while simultaneously
      // easing the opacity in. The opacity curve values here were derived using
      // Xcode through inspecting a native app running on iOS 13.5.
      const Curve opacityCurve = Interval(0, 0.35, curve: Curves.easeInOut);
      return Opacity(
        opacity: opacityCurve.transform(percentageComplete),
        child: CupertinoActivityIndicator.partiallyRevealed(
          radius: radius,
          progress: percentageComplete,
        ),
      );
    case RefreshIndicatorMode.armed:
    case RefreshIndicatorMode.refresh:
      // Once we're armed or performing the refresh, we just show the normal spinner.
      return CupertinoActivityIndicator(radius: radius);
    case RefreshIndicatorMode.done:
      // When the user lets go, the standard transition is to shrink the spinner.
      return CupertinoActivityIndicator(radius: radius * percentageComplete);
    case RefreshIndicatorMode.inactive:
      // Anything else doesn't show anything.
      return const SizedBox.shrink();
  }
}
