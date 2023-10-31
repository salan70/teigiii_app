import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/common_provider/snack_bar_controller.dart';
import '../interface/list_state.dart';
import '../logger.dart';

/// 無限スクロールの追加ローディング用のmixin
mixin FetchMoreMixin<T extends ListState> {
  AsyncValue<T> get state;
  set state(AsyncValue<T> value);

  Future<void> fetchMoreHelper({
    required AsyncNotifierProviderRef<T> ref,
    required Future<T> Function() fetchFunction,
    required T Function(T currentData, T newData) mergeFunction,
  }) async {
    // これ以上取得できるDefinitionIdがない場合、何もしない
    if (!state.value!.hasMore) {
      return;
    }

    // ローディング中の場合、何もしない
    if (state.isLoading || state.isRefreshing) {
      return;
    }

    state = AsyncLoading<T>().copyWithPrevious(state);

    try {
      final newData = await fetchFunction();
      final nextState = mergeFunction(state.value!, newData);
      state = AsyncData(nextState);
    } on Exception catch (e, s) {
      logger.e('$e');
      ref
          .read(snackBarControllerProvider.notifier)
          .showSnackBar('読み込めませんでした。もう一度お試しください。', causeError: true);
      state = AsyncError(e, s);
    }
  }
}
