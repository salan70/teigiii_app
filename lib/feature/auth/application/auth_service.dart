import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/common_provider/is_loading_overlay_state.dart';
import '../../../core/common_provider/toast_controller.dart';
import '../../../util/logger.dart';
import '../../definition/repository/fetch_definition_repository.dart';
import '../../definition/repository/like_definition_repository.dart';
import '../../definition/repository/write_definition_repository.dart';
import '../../user_config/application/user_config_state.dart';
import '../../user_config/repository/device_info_repository.dart';
import '../../user_config/repository/user_config_repository.dart';
import '../../user_profile/application/user_id_list_state.dart';
import '../../user_profile/repository/user_follow_repository.dart';
import '../../user_profile/repository/user_profile_repository.dart';
import '../../user_profile/util/user_list_type.dart';
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
      // ユーザー情報登録時にエラーが発生した場合、アカウントを削除する
      if (ref.read(authRepositoryProvider).currentUser != null) {
        await ref.read(authRepositoryProvider).deleteUser();
      }
      state = AsyncValue.error(e, s);
      return;
    }
    state = const AsyncValue.data(null);
  }

  // todo
  // muteの考慮（このユーザーをmuteしているユーザーのミュート一覧画面うまいことやる）
  // userが存在しない場合、UIに表示させず、mutedUserIdListから削除とか良さそう
  Future<void> deleteUser() async {
    ref.read(isLoadingOverlayNotifierProvider.notifier).startLoading();

    try {
      await _deleteUserRelatedData();
      await ref.read(authRepositoryProvider).deleteUser();
      logger.i('ユーザー削除が完了しました。');
    } on Exception catch (e, s) {
      logger.e('ユーザー削除時にエラーが発生しました。 error:$e, stackTrace:$s');
      ref
          .read(toastControllerProvider.notifier)
          .showToast('エラーが発生しました。再度お試しください。');
    } finally {
      ref.read(isLoadingOverlayNotifierProvider.notifier).finishLoading();
    }
  }

  /// ユーザーに関連するデータを削除する
  Future<void> _deleteUserRelatedData() async {
    final currentUserId = ref.read(userIdProvider)!;

    // * definition
    await deleteAllDefinition();

    // * like
    await unlikeAllLikedDefinition();

    // * follow関連
    await unfollowAllFollowing(currentUserId);
    await unfollowedByAllFollower(currentUserId);
    await ref
        .read(userFollowRepositoryProvider)
        .deleteUserFollowCount(currentUserId);

    // * userProfile
    await ref
        .read(userProfileRepositoryProvider)
        .deleteUserProfile(currentUserId);

    // * userConfig
    await ref
        .read(userConfigRepositoryProvider)
        .deleteUserConfig(currentUserId);
  }

  /// ユーザーが投稿したDefinitionと紐づくLikeを全て削除する
  Future<void> deleteAllDefinition() async {
    final currentUserId = ref.read(userIdProvider)!;

    final allPostedDefinitionDocList = await ref
        .read(fetchDefinitionRepositoryProvider)
        .fetchAllPostedDefinitionDocList(currentUserId);

    for (final definitionDoc in allPostedDefinitionDocList) {
      // Definitionを削除
      await ref
          .read(writeDefinitionRepositoryProvider)
          .deleteDefinition(definitionDoc.id, definitionDoc.wordId);

      // 紐づくLikeを削除
      await ref
          .read(likeDefinitionRepositoryProvider)
          .deleteLikeByDefinitionId(definitionDoc.id);
    }
  }

  /// ユーザーがいいねした全てのDefinitionのいいねを解除する
  Future<void> unlikeAllLikedDefinition() async {
    final currentUserId = ref.read(userIdProvider)!;

    final likedDefinitionIdList = await ref
        .read(likeDefinitionRepositoryProvider)
        .fetchAllLikedDefinitionIdList(currentUserId);

    for (final definitionId in likedDefinitionIdList) {
      await ref
          .read(likeDefinitionRepositoryProvider)
          .unlikeDefinition(definitionId, currentUserId);
    }
  }

  /// 全てのフォロワーが、currentUser をフォロー解除する
  Future<void> unfollowedByAllFollower(String currentUserId) async {
    final followerIdList = await ref.read(
      userIdListStateNotifierProvider(
        UserListType.follower,
        targetUserId: currentUserId,
        targetDefinitionId: null,
      ).future,
    );

    for (final followerId in followerIdList.list) {
      await ref
          .read(userFollowRepositoryProvider)
          .unfollow(followerId, currentUserId);
    }
  }

  /// currentUser が全てのフォロー中のユーザーをフォロー解除する
  Future<void> unfollowAllFollowing(String currentUserId) async {
    final followingIdList = await ref.read(
      userIdListStateNotifierProvider(
        UserListType.following,
        targetUserId: currentUserId,
        targetDefinitionId: null,
      ).future,
    );
    for (final followingId in followingIdList.list) {
      await ref
          .read(userFollowRepositoryProvider)
          .unfollow(currentUserId, followingId);
    }
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
