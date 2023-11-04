import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'definition_document.freezed.dart';

@freezed
class DefinitionDocument with _$DefinitionDocument {
  const factory DefinitionDocument({
    required String id,
    required String wordId,
    required String authorId,
    required String definition,
    required int likesCount,
    required bool isPublic,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _DefinitionDocument;

  factory DefinitionDocument.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;
    return DefinitionDocument(
      id: doc.id,
      wordId: data['wordId'] as String,
      authorId: data['authorId'] as String,
      definition: data['definition'] as String,
      likesCount: data['likesCount'] as int,
      isPublic: data['isPublic'] as bool,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }
}
