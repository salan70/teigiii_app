import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../feature/introduction/repository/is_first_launch_repository.dart';
import '../../util/logger.dart';
import 'app_router.dart';

part 'first_launch_guard.g.dart';

@riverpod
FirstLaunchGuard firstLaunchGuard(FirstLaunchGuardRef ref) => FirstLaunchGuard(ref);

class FirstLaunchGuard extends AutoRouteGuard {
  FirstLaunchGuard(this.ref);

  final Ref ref;

  @override
  Future<void> onNavigation(
    NavigationResolver resolver,
    StackRouter router,
  ) async {
    final isFirstLaunch =
        await ref.read(isFirstLaunchRepositoryProvider).isFirstLaunch();

    if (isFirstLaunch) {
      logger.d('初回起動しました。');
      await router.replace(const IntroductionRoute());
      return;
    }
    resolver.next();
  }
}
