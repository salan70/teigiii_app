import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../util/constant/firestore_collections.dart';

part 'like_document.freezed.dart';

@freezed
class LikeDocument with _$LikeDocument {
  const factory LikeDocument({
    required String id,
    required String definitionId,
    required String userId,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _LikeDocument;

  factory LikeDocument.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;
    return LikeDocument(
      id: doc.id,
      definitionId: data[LikesCollection.definitionId] as String,
      userId: data[LikesCollection.userId] as String,
      createdAt: (data[createdAtFieldName] as Timestamp).toDate(),
      updatedAt: (data[updatedAtFieldName] as Timestamp).toDate(),
    );
  }
}
