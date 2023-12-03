import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/common_provider/firebase_providers.dart';
import '../../../util/constant/firestore_collections.dart';
import 'entity/word_document.dart';

part 'word_repository.g.dart';

@riverpod
WordRepository wordRepository(WordRepositoryRef ref) =>
    WordRepository(ref.watch(firestoreProvider));

class WordRepository {
  WordRepository(this.firestore);

  final FirebaseFirestore firestore;

  CollectionReference get _wordsCollectionRef =>
      firestore.collection(WordsCollection.collectionName);

  /// [wordId] に一致する [WordDocument] を返す。
  ///
  /// 該当するドキュメントが見つからない場合、nullを返す。
  Future<WordDocument?> fetchWordById(String wordId) async {
    final snapshot = await _wordsCollectionRef.doc(wordId).get();

    if (snapshot.exists) {
      return WordDocument.fromFirestore(snapshot);
    }

    return null;
  }

  /// [word], [wordReading] 両方が一致する [WordDocument] のidを返す。
  ///
  /// 見つからない場合はnullを返す。
  Future<String?> findWordId(String word, String wordReading) async {
    final snapshot = await _wordsCollectionRef
        .where(WordsCollection.word, isEqualTo: word)
        .where(WordsCollection.reading, isEqualTo: wordReading)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) {
      // 該当する Word ドキュメントが見つからない場合、nullを返す。
      return null;
    }

    return snapshot.docs.first.id;
  }
}
