import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 撮影する 1 状態。`targets.json` の `states[].id` に 1 対 1 で対応する。
class Scenario {
  const Scenario({
    required this.widget,
    this.overrides = const [],
    this.height,
  });

  /// 撮る対象。画面は `MaterialApp.home` に、コンポーネントは中央に置く。
  final Widget widget;

  /// 状態を作る provider の差し替え。
  final List<Override> overrides;

  /// 撮影領域の高さ。省くと画面は 844、コンポーネントは 220。
  final double? height;
}

/// 状態ごとに新しい [Scenario] を作る関数。
///
/// 差し替える Notifier は撮影のたびに作り直す必要があるため、値ではなく関数で持つ。
typedef ScenarioBuilder = Scenario Function();
