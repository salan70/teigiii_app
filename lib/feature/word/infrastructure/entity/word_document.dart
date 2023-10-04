import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'word_document.freezed.dart';

@freezed
class WordDocument with _$WordDocument {
  const factory WordDocument({
    required String id,
    required String word,
    required String reading,
    required String initialLetter,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _WordDocument;

  factory WordDocument.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;
    return WordDocument(
      id: doc.id,
      word: data['word'] as String,
      reading: data['reading'] as String,
      initialLetter: data['initialLetter'] as String,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }
}
