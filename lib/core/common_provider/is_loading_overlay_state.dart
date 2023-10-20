import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'is_loading_overlay_state.g.dart';

/// オーバーレイローディングをUIに表示させるかどうかを管理する
@Riverpod(keepAlive: true)
class IsLoadingOverlayNotifier extends _$IsLoadingOverlayNotifier {
  @override
  bool build() {
    return false;
  }

  void startLoading() {
    state = true;
  }

  void finishLoading() {
    state = false;
  }
}
