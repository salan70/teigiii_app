import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_config_document.freezed.dart';

@freezed
class UserConfigDocument with _$UserConfigDocument {
  const factory UserConfigDocument({
    required String id,
    required String appVersion,
    required String deviceOs,
    required List<String> mutedUserIdList,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _UserConfigDocument;

  factory UserConfigDocument.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;
    return UserConfigDocument(
      id: doc.id,
      appVersion: data['appVersion'] as String,
      deviceOs: data['deviceOs'] as String,
      mutedUserIdList: (data['mutedUserIdList'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }
}
