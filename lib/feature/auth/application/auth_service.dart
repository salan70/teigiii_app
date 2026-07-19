import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/api_exception.dart';
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

      // `POST /v1/users` が commit 済みでも応答のタイムアウト・ドロップで
      // 例外になる場合がある。Firebase Auth だけ削除するとサーバー側に
      // アクセス不能なユーザーが孤児として残るため、Firebase Auth を消す前に
      // ベストエフォートでサーバーユーザーを削除する（未作成なら 404 で無害）。
      try {
        await ref.read(registerUserRepositoryProvider).deleteUser();
      } on Exception catch (cleanupError, cleanupStack) {
        logger.w(
          'サーバーユーザーのクリーンアップに失敗しました（続行します）。'
          ' error:$cleanupError, stackTrace:$cleanupStack',
        );
      }

      // ユーザー情報登録時にエラーが発生した場合、
      // 最初からやり直すために Firebase Auth を削除する。
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
  ///
  /// サーバー削除が成功した後に Firebase Auth 削除が失敗すると、再試行時に
  /// サーバー削除が「既に削除済み」で 404/401 を返し、Firebase Auth を削除
  /// できないまま詰まる。そのため既に削除済みのレスポンスは成功とみなし、
  /// Firebase Auth 削除まで確実に到達させる。
  Future<void> deleteUser() async {
    try {
      await ref.read(registerUserRepositoryProvider).deleteUser();
    } on ApiException catch (e, s) {
      // 論理削除済みユーザーの再削除は 404/401 になる。サーバー側の削除は
      // 完了しているとみなし、残りの Firebase Auth 削除へ進む。
      if (e.statusCode != 404 && e.statusCode != 401) {
        rethrow;
      }
      logger.w(
        'サーバーユーザーは既に削除済みとみなして続行します。'
        ' error:$e, stackTrace:$s',
      );
    }
    await ref.read(authRepositoryProvider).deleteUser();
  }
}
