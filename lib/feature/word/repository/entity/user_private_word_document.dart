import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_private_word_document.freezed.dart';

@freezed
class UserPrivateWordDocument with _$UserPrivateWordDocument {
  const factory UserPrivateWordDocument({
    required Map<String, Map<String, int>> privateWordMap,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _UserPrivateWordDocument;

  factory UserPrivateWordDocument.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;

    // privateWordMapをキャスト
    var castedPrivateWordMap = <String, Map<String, int>>{};
    if (data['privateWordMap'] != null) {
      castedPrivateWordMap =
          (data['privateWordMap'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(
          key,
          Map<String, int>.from(value as Map<String, dynamic>),
        ),
      );
    }

    return UserPrivateWordDocument(
      privateWordMap: castedPrivateWordMap,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }
}
