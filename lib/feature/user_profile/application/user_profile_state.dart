import 'dart:math';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../auth/application/auth_state.dart';
import '../../user_profile/repository/user_profile_repository.dart';
import '../domain/follow_count.dart';
import '../domain/user_profile.dart';
import '../repository/user_follow_repository.dart';

part 'user_profile_state.g.dart';

@Riverpod(keepAlive: true)
Future<UserProfile> userProfile(UserProfileRef ref, String userId) async {
  // TODO(me): デバッグ用のためリリース時に削除する
  // await Future<void>.delayed(const Duration(seconds: 2));
  // 1/2の確率でエラーを発生させる
  if (Random().nextBool()) {
    throw Exception('やばいで！！！！！');
  }

  final userProfileDoc =
      await ref.read(userProfileRepositoryProvider).fetchUserProfile(userId);

  return UserProfile(
    id: userId,
    name: userProfileDoc.name,
    bio: userProfileDoc.bio,
    profileImageUrl: userProfileDoc.profileImageUrl,
    croppedFile: null,
  );
}

@Riverpod(keepAlive: true)
Future<FollowCount> followCount(
  FollowCountRef ref,
  String userId,
) async {
  final userFollowCountDoc =
      await ref.read(userFollowRepositoryProvider).fetchUserFollowCount(userId);

  return FollowCount.fromDocument(userFollowCountDoc);
}

@Riverpod(keepAlive: true)
Future<bool> isFollowing(IsFollowingRef ref, String targetUserId) async {
  final currentUserId = ref.read(userIdProvider)!;

  return ref
      .read(userFollowRepositoryProvider)
      .isFollowing(currentUserId, targetUserId);
}

@Riverpod(keepAlive: true)
Future<List<String>> followingIdList(
  FollowingIdListRef ref,
  String targetUserId,
) async {
  return ref
      .read(userFollowRepositoryProvider)
      .fetchAllFollowingIdList(targetUserId);
}
