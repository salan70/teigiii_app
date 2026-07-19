import 'package:freezed_annotation/freezed_annotation.dart';

part 'follow_count.freezed.dart';

@freezed
class FollowCount with _$FollowCount {
  const factory FollowCount({
    required String userId,
    required int followerCount,
    required int followingCount,
  }) = _FollowCount;
}
