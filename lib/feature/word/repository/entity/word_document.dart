import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../util/constant/firestore_collections.dart';

part 'word_document.freezed.dart';

@freezed
class WordDocument with _$WordDocument {
  const factory WordDocument({
    required String id,
    required String word,
    required String reading,
    required String initialSubGroupLabel,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _WordDocument;

  factory WordDocument.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;
    return WordDocument(
      id: doc.id,
      word: data[WordsCollection.word] as String,
      reading: data[WordsCollection.reading] as String,
      initialSubGroupLabel:
          data[WordsCollection.initialSubGroupLabel] as String,
      createdAt: (data[createdAtFieldName] as Timestamp).toDate(),
      updatedAt: (data[updatedAtFieldName] as Timestamp).toDate(),
    );
  }
}
