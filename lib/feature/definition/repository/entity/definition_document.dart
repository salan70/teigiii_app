import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'definition_document.freezed.dart';

@freezed
class DefinitionDocument with _$DefinitionDocument {
  const factory DefinitionDocument({
    required String id,
    required String wordId,
    required String content,
    required String authorId,
    required bool isPublic,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _DefinitionDocument;

  factory DefinitionDocument.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;
    return DefinitionDocument(
      id: doc.id,
      wordId: data['wordId'] as String,
      content: data['content'] as String,
      authorId: data['authorId'] as String,
      isPublic: data['isPublic'] as bool,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }
}
