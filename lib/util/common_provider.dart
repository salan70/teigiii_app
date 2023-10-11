import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'common_provider.g.dart';

/// オーバーレイローディングをUIに表示させるかどうかを管理する
@riverpod
class IsLoadingOverlayNotifier
    extends _$IsLoadingOverlayNotifier {
  @override
  bool build() {
    return false;
  }

  Future<void> startLoading() async {
    state = true;
  }

  Future<void> finishLoading() async {
    state = false;
  }
}
