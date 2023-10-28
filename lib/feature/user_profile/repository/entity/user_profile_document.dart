import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../util/constant/default_value.dart';

part 'user_profile_document.freezed.dart';

@freezed
class UserProfileDocument with _$UserProfileDocument {
  const factory UserProfileDocument({
    required String id,
    required String name,
    required String bio,
    required String profileImageUrl,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _UserProfileDocument;

  factory UserProfileDocument.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;
    return UserProfileDocument(
      id: doc.id,
      name: data['name'] as String,
      bio: data['bio'] as String,
      profileImageUrl: data['profileImageUrl'] as String? ?? defaultImageUrl,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }
}
