import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'common_provider.g.dart';

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
