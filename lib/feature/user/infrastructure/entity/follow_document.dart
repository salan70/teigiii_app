import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'follow_document.freezed.dart';

@freezed
class FollowDocument with _$FollowDocument {
  const factory FollowDocument({
    required String id,
    required String followerId,
    required String followingId,
    required DateTime createdAt,
  }) = _FollowDocument;

  factory FollowDocument.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;
    return FollowDocument(
      id: doc.id,
      followerId: data['followerId'] as String,
      followingId: data['followingId'] as String,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
}
