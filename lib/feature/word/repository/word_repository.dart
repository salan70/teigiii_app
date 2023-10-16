import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../util/firebase_provider.dart';
import 'entity/word_document.dart';

part 'word_repository.g.dart';

@Riverpod(keepAlive: true)
WordRepository wordRepository(WordRepositoryRef ref) =>
    WordRepository(
      ref.watch(firestoreProvider),
    );

class WordRepository {
  WordRepository(this.firestore);

  final FirebaseFirestore firestore;

  Future<WordDocument> fetchWord(String wordId) async {
    final DocumentSnapshot wordSnapshot =
        await firestore.collection('Words').doc(wordId).get();

    return WordDocument.fromFirestore(wordSnapshot);
  }
}
