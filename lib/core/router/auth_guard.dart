import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../feature/auth/application/auth_service.dart';
import '../../feature/auth/application/auth_state.dart';
import '../../util/logger.dart';
import '../common_provider/is_loading_overlay_state.dart';
import 'app_router.dart';

part 'auth_guard.g.dart';

@riverpod
AuthGuard authGuard(AuthGuardRef ref) => AuthGuard(ref);

class AuthGuard extends AutoRouteGuard {
  AuthGuard(this.ref);

  final Ref ref;

  @override
  Future<void> onNavigation(
    NavigationResolver resolver,
    StackRouter router,
  ) async {
    // ログイン済みかどうか。
    final isSignedIn = ref.read(isSignedInProvider);

    if (isSignedIn) {
      await ref.read(authServiceProvider).updateUserConfig();
      resolver.next();
      return;
    }

    logger.i('ログインしていないため、匿名ログインします。');
    ref.read(isLoadingOverlayNotifierProvider.notifier).startLoading();

    try {
      await ref.read(authServiceProvider).signIn();

      resolver.next();

      ref.read(isLoadingOverlayNotifierProvider.notifier).finishLoading();
    } on Exception catch (e, s) {
      logger.e('匿名ログイン時にエラーが発生しました。 error:$e, stackTrace:$s');

      ref.read(isLoadingOverlayNotifierProvider.notifier).finishLoading();

      await resolver.redirect(const SignInFailureRoute());
    }
  }
}
