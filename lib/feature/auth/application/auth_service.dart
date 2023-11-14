import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../util/logger.dart';
import '../../user_config/application/user_config_state.dart';
import '../../user_config/repository/device_info_repository.dart';
import '../../user_config/repository/user_config_repository.dart';
import '../../user_profile/repository/user_follow_repository.dart';
import '../../user_profile/repository/user_profile_repository.dart';
import '../repository/auth_repository.dart';
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
  Future<void> onAppLaunch() async {
    state = const AsyncValue.loading();
    // TODO(me): デバッグ用。リリース時に削除する
    // await ref.read(authRepositoryProvider).signOut();

    final isSignedIn = ref.read(isSignedInProvider);
    // ログインしている場合
    if (isSignedIn) {
      logger.i('ログイン済みです。');
      // _updateUserConfig()時のエラーは直接ユーザーに影響がないと思われるので、
      // AsyncValue.guard()で囲わず、エラーをログ出力するだけとしている
      try {
        await _updateUserConfig();
      } on Exception catch (e) {
        logger.e('$e');
      }

      state = const AsyncValue.data(null);
      return;
    }

    // ログインしていない場合
    state = await AsyncValue.guard(() async {
      logger.i('ログインしていないため、匿名ログインします');
      // 匿名ログイン
      await ref.read(authRepositoryProvider).signInAnonymously();

      // ユーザー情報を登録
      // TODO(me): バッチ実行する（全て保存するか、何も保存しないか）
      // ここ失敗したら、signOut()したほうが良さそう
      await _addUserConfig();
      await _addUserProfile();
      await _addUserFollowCount();

      return;
    });

    return;
  }

  /// ユーザーの設定に関する情報を登録する
  Future<void> _addUserConfig() async {
    final osVersion =
        await ref.read(deviceInfoRepositoryProvider).fetchOsVersion() ??
            unexpectedOsText;

    final appVersion = await ref.read(appVersionProvider.future);

    final userId = ref.read(userIdProvider)!;

    // 新規ログイン後にこの関数が呼ばれる想定のため、ここでuserIdを出力しておく
    logger.i('[$userId]として新規ログインしました。ユーザー情報を登録します。');

    await ref.read(userConfigRepositoryProvider).addUserConfig(
          userId,
          osVersion,
          appVersion,
        );
  }

  /// ユーザープロフィールを登録する
  Future<void> _addUserProfile() async {
    final userId = ref.read(userIdProvider)!;

    await ref.read(userProfileRepositoryProvider).addUserProfile(userId);
  }

  /// ユーザーのフォロー/フォロワー数を登録する
  Future<void> _addUserFollowCount() async {
    final userId = ref.read(userIdProvider)!;
    await ref.read(userFollowRepositoryProvider).addUserFollowCount(userId);
  }

  /// ユーザーの設定に関する情報を更新する
  Future<void> _updateUserConfig() async {
    final osVersion =
        await ref.read(deviceInfoRepositoryProvider).fetchOsVersion() ??
            unexpectedOsText;

    final appVersion = await ref.read(appVersionProvider.future);

    final userId = ref.read(userIdProvider)!;
    // ログインしている場合、この関数が呼ばれる想定のため、ここでuserIdを出力しておく
    logger.i('[$userId]としてログイン中です。ユーザー情報を更新します。');

    await ref.read(userConfigRepositoryProvider).updateVersionInfo(
          userId,
          osVersion,
          appVersion,
        );
  }
}
