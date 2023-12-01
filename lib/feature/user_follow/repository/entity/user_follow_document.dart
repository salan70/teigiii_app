import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../util/constant/firestore_collections.dart';

part 'user_follow_document.freezed.dart';

@freezed
class UserFollowDocument with _$UserFollowDocument {
  const factory UserFollowDocument({
    required String id,
    required String followerId,
    required String followingId,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _UserFollowDocument;

  factory UserFollowDocument.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;
    return UserFollowDocument(
      id: doc.id,
      followerId: data[UserFollowsCollection.followerId] as String,
      followingId: data[UserFollowsCollection.followingId] as String,
      createdAt: (data[createdAtFieldName] as Timestamp).toDate(),
      updatedAt: (data[updatedAtFieldName] as Timestamp).toDate(),
    );
  }
}
