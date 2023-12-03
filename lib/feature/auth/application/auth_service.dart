import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/common_provider/flavor_state.dart';
import '../../../util/logger.dart';
import '../../definition/repository/fetch_definition_repository.dart';
import '../../definition/repository/write_definition_repository.dart';
import '../../definition_like/repository/like_definition_repository.dart';
import '../../user_config/application/user_config_state.dart';
import '../../user_config/repository/device_info_repository.dart';
import '../../user_config/repository/user_config_repository.dart';
import '../../user_follow/repository/user_follow_repository.dart';
import '../../user_list/application/user_id_list_state_notifier.dart';
import '../../user_list/util/user_list_type.dart';
import '../../user_profile/domain/user_profile.dart';
import '../../user_profile/repository/storage_repository.dart';
import '../../user_profile/repository/user_profile_repository.dart';
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
      logger.e('匿名ログイン時にエラーが発生したため、アカウントを削除します。'
          ' error:$e, stackTrace:$s');

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

    final imageUrl = ref.read(flavorProvider).generateRandomIconImageUrl();
    final userProfile = UserProfile.defaultValue(userId, imageUrl);

    final osVersion =
        await ref.read(deviceInfoRepositoryProvider).fetchOsVersion() ??
            unexpectedOsText;
    final appVersion = await ref.read(appVersionProvider.future);

    await ref
        .read(registerUserRepositoryProvider)
        .initUser(userId, userProfile, osVersion, appVersion);
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

    await ref.read(registerUserRepositoryProvider).updateVersionInfo(
          userId,
          osVersion,
          appVersion,
        );
  }

  Future<void> deleteUser() async {
    await _deleteUserRelatedData();
    await ref.read(authRepositoryProvider).deleteUser();
  }

  /// ユーザーに関連するデータを削除する。
  Future<void> _deleteUserRelatedData() async {
    final currentUserId = ref.read(userIdProvider)!;

    // TODO(me): バッチ実行したい。

    // * definition
    await deleteAllDefinition();

    // * like
    await unlikeAllLikedDefinition();

    // * follow 関連
    await unfollowAllFollowing(currentUserId);
    await unfollowByAllFollower(currentUserId);
    await ref
        .read(userFollowRepositoryProvider)
        .deleteUserFollowCount(currentUserId);

    // * userProfile
    await ref
        .read(userProfileRepositoryProvider)
        .deleteUserProfile(currentUserId);
    await ref.read(storageRepositoryProvider).deleteFile(currentUserId);

    // * userConfig
    await ref
        .read(userConfigRepositoryProvider)
        .deleteUserConfig(currentUserId);
  }

  /// ユーザーが投稿した Definition と紐づくLikeを全て削除する。
  Future<void> deleteAllDefinition() async {
    final currentUserId = ref.read(userIdProvider)!;

    final allPostedDefinitionDocList = await ref
        .read(fetchDefinitionRepositoryProvider)
        .fetchAllPostedDefinitionDocList(currentUserId);

    for (final definitionDoc in allPostedDefinitionDocList) {
      // Definition を削除する。
      await ref
          .read(writeDefinitionRepositoryProvider)
          .deleteDefinition(definitionDoc.id, definitionDoc.wordId);

      // 紐づく Like を削除する。
      await ref
          .read(likeDefinitionRepositoryProvider)
          .deleteLikeByDefinitionId(definitionDoc.id);
    }
  }

  /// ユーザーがいいねした全ての Definition のいいねを解除する。
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

  /// 全てのフォロワーが、currentUser をフォロー解除する。
  Future<void> unfollowByAllFollower(String currentUserId) async {
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

  /// currentUser が全てのフォロー中のユーザーをフォロー解除する。
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
}
