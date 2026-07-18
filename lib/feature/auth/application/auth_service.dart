import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../util/logger.dart';
import '../../user_config/application/user_config_state.dart';
import '../../user_config/repository/device_info_repository.dart';
import '../../user_profile/domain/user_profile.dart';
import '../repository/auth_repository.dart';
import '../repository/register_user_repository.dart';
import '../util/constant.dart';
import 'auth_state.dart';

part 'auth_service.g.dart';

@riverpod
AuthService authService(AuthServiceRef ref) => AuthService(ref);

class AuthService {
  AuthService(this.ref);

  final Ref ref;

  /// 匿名ログインし、ユーザー情報を登録する。
  ///
  /// アプリ起動時に、ログインしていない場合に呼ばれることを想定している。
  Future<void> signIn() async {
    // 匿名ユーザーとして登録する。
    await ref.read(authRepositoryProvider).signInAnonymously();

    try {
      // ユーザー情報を登録する。
      await _initUser();
    } on Exception catch (e, s) {
      logger.e(
        '匿名ログイン時にエラーが発生したため、アカウントを削除します。'
        ' error:$e, stackTrace:$s',
      );

      // ユーザー情報登録時にエラーが発生した場合、
      // 最初からやり直すためにアカウントを削除する。
      await ref.read(authRepositoryProvider).deleteUser();
      rethrow;
    }
  }

  /// 初回登録時に必要なユーザー情報を登録する。
  Future<void> _initUser() async {
    final userId = ref.read(userIdProvider)!;
    logger.i('[$userId]として新規ログインしました。ユーザー情報を登録します。');

    final osVersion =
        await ref.read(deviceInfoRepositoryProvider).fetchOsVersion() ??
        unexpectedOsText;
    final appVersion = await ref.read(appVersionProvider.future);

    await ref
        .read(registerUserRepositoryProvider)
        .initUser(
          name: UserProfile.defaultName,
          osVersion: osVersion,
          appVersion: appVersion,
        );
    logger.i('ユーザー情報の登録が完了しました。');
  }

  /// ユーザーの設定に関する情報を更新する。
  Future<void> updateUserConfig() async {
    final osVersion =
        await ref.read(deviceInfoRepositoryProvider).fetchOsVersion() ??
        unexpectedOsText;
    final appVersion = await ref.read(appVersionProvider.future);

    final userId = ref.read(userIdProvider)!;
    // ログインしている場合、最初に userId を取得するのはこの関数内を想定しているため
    // ここで userId を出力しておく。
    logger.i('[$userId]としてログイン中です。ユーザー情報を更新します。');

    await ref
        .read(registerUserRepositoryProvider)
        .updateVersionInfo(osVersion: osVersion, appVersion: appVersion);
  }

  /// アカウントを削除する。
  ///
  /// 関連データの削除はサーバー側（`DELETE /v1/users/me`）に集約されている。
  Future<void> deleteUser() async {
    await ref.read(registerUserRepositoryProvider).deleteUser();
    await ref.read(authRepositoryProvider).deleteUser();
  }
}
