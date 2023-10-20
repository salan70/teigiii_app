import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../user/repository/user_profile_repository.dart';
import '../../user_config/repository/device_info_repository.dart';
import '../../user_config/repository/package_info_repository.dart';
import '../../user_config/repository/user_config_repository.dart';
import '../repository/auth_repository.dart';
import '../util/constant.dart';
import 'auth_state.dart';

part 'auth_service.g.dart';

@Riverpod(keepAlive: true)
class AuthService extends _$AuthService {
  @override
  FutureOr<void> build() async {
    await onAppLaunch();
  }

  /// アプリ起動時に行うAuth関連の処理
  ///
  /// 初回ログイン時にエラーが発生した場合、[state]が[AsyncValue.error]になる
  /// この場合、以降のアプリ上での操作の大半ができなくなることを考慮して、エラーハンドリングを行うこと
  Future<void> onAppLaunch() async {
    state = const AsyncValue.loading();

    // await ref.read(authRepositoryProvider).signOut();
    final currentUserId = ref.read(userIdProvider);
    debugPrint('currentUserId: $currentUserId');
    // ログインしていない場合
    if (currentUserId == null) {
      state = await AsyncValue.guard(() async {
        // 匿名ログイン
        await ref.read(authRepositoryProvider).signInAnonymously();

        // ユーザー情報を登録
        await _addUserConfig();
        await _addUserProfile();
      });
    }

    // ログインしている場合
    else {
      // _updateUserConfig()時のエラーは直接ユーザーに影響がないと思われるので、
      // AsyncValue.guard()で囲わず、debugPrint()でエラーを出力するだけとしている
      try {
        await _updateUserConfig();
      } on Exception catch (e) {
        debugPrint('エラー: $e');
      }
    }

    state = const AsyncValue.data(null);
    return;
  }

  /// ユーザーの設定に関する情報を登録する
  Future<void> _addUserConfig() async {
    final osVersion =
        await ref.read(deviceInfoRepositoryProvider).fetchOsVersion() ??
            unexpectedOsText;

    final appVersion =
        await ref.read(packageInfoRepositoryProvider).fetchAppVersion();

    final userId = ref.read(userIdProvider)!;

    await ref.read(userConfigRepositoryProvider).addUserConfig(
          userId,
          osVersion,
          appVersion,
        );
  }

  /// ユーザープロフィールを登録する
  Future<void> _addUserProfile() async {
    final userId = ref.read(userIdProvider)!;

    await ref
        .read(userProfileRepositoryProvider)
        .addUserProfile(userId, defaultUserName);
  }

  /// ユーザーの設定に関する情報を更新する
  Future<void> _updateUserConfig() async {
    final osVersion =
        await ref.read(deviceInfoRepositoryProvider).fetchOsVersion() ??
            unexpectedOsText;

    final appVersion =
        await ref.read(packageInfoRepositoryProvider).fetchAppVersion();

    final userId = ref.read(userIdProvider)!;

    await ref.read(userConfigRepositoryProvider).updateUserConfig(
          userId,
          osVersion,
          appVersion,
        );
  }
}
