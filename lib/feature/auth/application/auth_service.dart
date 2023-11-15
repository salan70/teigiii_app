import 'package:riverpod_annotation/riverpod_annotation.dart';

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
    // TODO(me): デバッグ用。リリース時に削除する
    // await ref.read(authRepositoryProvider).signOut();

    if (ref.read(isSignedInProvider)) {
      // * ログインしている場合
      logger.i('ログイン済みです。');

      // _updateUserConfig()時のエラーは直接ユーザーに影響がないと思われるので、
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
    state = await AsyncValue.guard(() async {
      logger.i('ログインしていないため、匿名ログインします');
      await ref.read(authRepositoryProvider).signInAnonymously();

      // ユーザー情報を登録
      // ここ失敗したら、signOut()かアカウント削除したほうが良さそう
      await _initUser();

      return;
    });
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
