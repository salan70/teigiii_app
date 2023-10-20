import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/common_provider/is_loading_overlay_state.dart';
import '../repository/auth_repository.dart';
import 'auth_state.dart';

part 'auth_service.g.dart';

@riverpod
class AuthService extends _$AuthService {
  @override
  FutureOr<void> build() {}

  /// アプリ起動時に行うAuth関連の処理
  Future<void> onAppLaunch() async {
    final isLoadingOverlayNotifier =
        ref.read(isLoadingOverlayNotifierProvider.notifier)..startLoading();
    await Future<void>.delayed(const Duration(seconds: 2));

    final currentUserId = await ref.read(userIdProvider.future);
    // ログインしていない場合
    if (currentUserId == null) {
      // TODO(me): エラーハンドリング
      // 専用のエラー画面を表示させるようにしたい（LoginFailurePage的な）
      // 匿名ログイン
      await ref.read(authRepositoryProvider).signInAnonymously();
      // TODO(me): ユーザー情報をFirestoreに登録

      isLoadingOverlayNotifier.finishLoading();
      return;
    }

    // ログインしている場合
    // TODO(me): （必要あれば）Firestoreのユーザー情報を更新
    isLoadingOverlayNotifier.finishLoading();
    return;
  }
}
