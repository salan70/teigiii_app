import 'package:freezed_annotation/freezed_annotation.dart';

import '../repository/entity/user_follow_count_document.dart';

part 'follow_count.freezed.dart';

@freezed
class FollowCount with _$FollowCount {
  const factory FollowCount({
    required String userId,
    required int followerCount,
    required int followingCount,
  }) = _FollowCount;

  factory FollowCount.fromDocument(UserFollowCountDocument doc) {
    return FollowCount(
      userId: doc.userId,
      followerCount: doc.followerCount,
      followingCount: doc.followingCount,
    );
  }
}
