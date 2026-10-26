import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/analytics/analytics_event.dart';
import '../../../core/analytics/analytics_service.dart';
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
    await ref
        .read(analyticsServiceProvider)
        .logEvent(AnalyticsEvent.userSignedInAnonymously);

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
      await ref.read(analyticsServiceProvider).setUserId(null);
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
    await ref.read(analyticsServiceProvider).setUserId(userId);
    await ref
        .read(analyticsServiceProvider)
        .logEvent(AnalyticsEvent.userRegistered);
    logger.i('ユーザー情報の登録が完了しました。');
  }

  /// ユーザーの設定に関する情報を更新する。
  ///
  /// 404 `user_not_found`（Firebase Auth にはユーザーが存在するがサーバー側に
  /// 存在しない状態）の場合、自己修復として `_initUser()` による再登録を行う。
  /// 移行スナップショット取得後に旧アプリで新規登録したユーザー等で発生しうる。
  /// 再登録自体が失敗した場合はそのまま rethrow し、握りつぶさない。
  Future<void> updateUserConfig() async {
    final osVersion =
        await ref.read(deviceInfoRepositoryProvider).fetchOsVersion() ??
        unexpectedOsText;
    final appVersion = await ref.read(appVersionProvider.future);

    final userId = ref.read(userIdProvider)!;
    // ログインしている場合、最初に userId を取得するのはこの関数内を想定しているため
    // ここで userId を出力しておく。
    logger.i('[$userId]としてログイン中です。ユーザー情報を更新します。');

    try {
      await ref
          .read(registerUserRepositoryProvider)
          .updateVersionInfo(osVersion: osVersion, appVersion: appVersion);
      await ref.read(analyticsServiceProvider).setUserId(userId);
    } on ApiException catch (e) {
      if (e.statusCode != 404 || e.code != 'user_not_found') {
        rethrow;
      }
      logger.w('[$userId]はサーバー未登録のため、自己修復として再登録します。');
      await _initUser();
    }
  }

  /// アカウントを削除する。
  ///
  /// 関連データの削除はサーバー側（`DELETE /v1/users/me`）に集約されている。
  ///
  /// サーバー削除の成功を同じ UID に限って保持し、Firebase 削除を再試行する。
  Future<void> deleteUser() async {
    final authRepository = ref.read(authRepositoryProvider);
    final pendingUid = authRepository.serverDeletedUserId;
    final uid = pendingUid ?? await authRepository.prepareAccountDeletion();
    if (pendingUid == null) {
      await ref.read(registerUserRepositoryProvider).deleteUser();
      authRepository.serverDeletedUserId = uid;
    }
    await authRepository.deletePreparedUser(uid);
    final analytics = ref.read(analyticsServiceProvider);
    await analytics.logEvent(AnalyticsEvent.accountDeleted);
    await analytics.setUserId(null);
  }
}
