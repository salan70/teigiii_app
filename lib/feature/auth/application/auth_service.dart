import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/common_provider/toast_controller.dart';
import '../../../util/logger.dart';
import '../../user_config/application/user_config_state.dart';
import '../../user_config/repository/device_info_repository.dart';
import '../repository/auth_repository.dart';
import '../repository/register_user_repository.dart';
import '../util/constant.dart';
import 'auth_state.dart';

part 'auth_service.g.dart';

@Riverpod(keepAlive: true)
class AuthService extends _$AuthService {
  @override
  FutureOr<void> build() async {}

  /// アプリ起動時に行うAuth関連の処理
  ///
  /// 初回ログイン時にエラーが発生した場合、[state]が[AsyncValue.error]になる
  /// この場合、以降のアプリ上での操作の大半ができなくなることを考慮して、エラーハンドリングを行うこと
  ///
  /// 2回目以降のログイン時にエラーが発生した場合は、[state]が[AsyncValue.error]にならない
  Future<void> onAppLaunch() async {
    state = const AsyncValue.loading();

    if (ref.read(isSignedInProvider)) {
      // * ログインしている場合
      logger.i('ログイン済みです。');

      // _updateUserConfig()時のエラーは直接ユーザーに影響が想定のため、
      // AsyncValue.guard()で囲わず、エラーをログ出力するだけとしている
      try {
        await _updateUserConfig();
      } on Exception catch (e, s) {
        logger.e('UserConfigの更新に失敗しました。 error:$e, stackTrace:$s');
      }
      state = const AsyncValue.data(null);
      return;
    }

    // * ログインしていない場合
    logger.i('ログインしていないため、匿名ログインします');
    try {
      await ref.read(authRepositoryProvider).signInAnonymously();

      // ユーザー情報を登録
      await _initUser();
    } on Exception catch (e, s) {
      logger.e('匿名ログイン時にエラーが発生しました。 error:$e, stackTrace:$s');
      ref
          .read(toastControllerProvider.notifier)
          .showToast('エラーが発生しました。再度お試しください。');

      // 匿名ログインは成功しているが、
      // 初回登録時にエラーが発生した場合、アカウントを削除する
      if (ref.read(authRepositoryProvider).currentUser != null) {
        await ref.read(authRepositoryProvider).deleteUser();
      }
      state = AsyncValue.error(e, s);
      return;
    }
    state = const AsyncValue.data(null);
  }

  Future<void> deleteUser() async {
    await ref.read(authRepositoryProvider).deleteUser();
  }

  /// 初回登録時に必要なユーザー情報を登録する
  Future<void> _initUser() async {
    final userId = ref.read(userIdProvider)!;
    // 新規ログイン後に最初にuserIdを取得するのはこの関数内を想定しているため
    // ここでuserIdを出力しておく
    logger.i('[$userId]として新規ログインしました。ユーザー情報を登録します。');

    final osVersion =
        await ref.read(deviceInfoRepositoryProvider).fetchOsVersion() ??
            unexpectedOsText;
    final appVersion = await ref.read(appVersionProvider.future);

    await ref
        .read(registerUserRepositoryProvider)
        .initUser(userId, osVersion, appVersion);
    logger.i('ユーザー情報の登録が完了しました。');
  }

  /// ユーザーの設定に関する情報を更新する
  Future<void> _updateUserConfig() async {
    final osVersion =
        await ref.read(deviceInfoRepositoryProvider).fetchOsVersion() ??
            unexpectedOsText;
    final appVersion = await ref.read(appVersionProvider.future);

    final userId = ref.read(userIdProvider)!;
    // ログインしている場合、最初にuserIdを取得するのはこの関数内を想定しているため
    // ここでuserIdを出力しておく
    logger.i('[$userId]としてログイン中です。ユーザー情報を更新します。');

    await ref.read(registerUserRepositoryProvider).updateVersionInfo(
          userId,
          osVersion,
          appVersion,
        );
  }
}
