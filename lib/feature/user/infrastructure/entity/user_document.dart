import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_document.freezed.dart';

@freezed
class UserDocument with _$UserDocument {
  const factory UserDocument({
    required String id,
    required String name,
    required String email,
    required String profileImageUrl,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _UserDocument;

  factory UserDocument.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;
    return UserDocument(
      id: doc.id,
      name: data['name'] as String,
      email: data['email'] as String,
      profileImageUrl: data['profileImageUrl'] as String,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }
}
