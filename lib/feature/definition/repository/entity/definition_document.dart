import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../util/constant/firestore_collections.dart';

part 'definition_document.freezed.dart';

@freezed
class DefinitionDocument with _$DefinitionDocument {
  const factory DefinitionDocument({
    required String id,
    required String wordId,
    required String word,
    required String wordReading,
    required String wordReadingInitialSubGroupLabel,
    required String authorId,
    required String definition,
    required int likesCount,
    required bool isPublic,
    required bool isEdited,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _DefinitionDocument;

  factory DefinitionDocument.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;
    return DefinitionDocument(
      id: doc.id,
      wordId: data[DefinitionsCollection.wordId] as String,
      word: data[DefinitionsCollection.word] as String,
      wordReading: data[DefinitionsCollection.wordReading] as String,
      wordReadingInitialSubGroupLabel:
          data[DefinitionsCollection.wordReadingInitialSubGroupLabel] as String,
      authorId: data[DefinitionsCollection.authorId] as String,
      definition: data[DefinitionsCollection.definition] as String,
      likesCount: data[DefinitionsCollection.likesCount] as int,
      isPublic: data[DefinitionsCollection.isPublic] as bool,
      isEdited: data[DefinitionsCollection.isEdited] as bool,
      createdAt: (data[createdAtFieldName] as Timestamp).toDate(),
      updatedAt: (data[updatedAtFieldName] as Timestamp).toDate(),
    );
  }
}
