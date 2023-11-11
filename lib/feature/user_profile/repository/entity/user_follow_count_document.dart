import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../util/constant/firestore_collections.dart';

part 'user_follow_count_document.freezed.dart';

@freezed
class UserFollowCountDocument with _$UserFollowCountDocument {
  const factory UserFollowCountDocument({
    required String userId,
    required int followerCount,
    required int followingCount,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _UserFollowCountDocument;

  factory UserFollowCountDocument.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;
    return UserFollowCountDocument(
      userId: doc.id,
      followerCount: data[UserFollowCountsCollection.followerCount] as int,
      followingCount: data[UserFollowCountsCollection.followingCount] as int,
      createdAt: (data[createdAtFieldName] as Timestamp).toDate(),
      updatedAt: (data[updatedAtFieldName] as Timestamp).toDate(),
    );
  }
}
