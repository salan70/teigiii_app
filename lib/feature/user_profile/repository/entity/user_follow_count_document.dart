import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_follow_count_document.freezed.dart';

@freezed
class UserFollowCountDocument with _$UserFollowCountDocument {
  const factory UserFollowCountDocument({
    required String id,
    required int followerCount,
    required int followingCount,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _UserFollowCountDocument;

  factory UserFollowCountDocument.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;
    return UserFollowCountDocument(
      id: doc.id,
      followerCount: data['followerCount'] as int,
      followingCount: data['followingCount'] as int,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }
}