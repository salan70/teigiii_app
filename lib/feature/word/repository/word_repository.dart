import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/common_provider/firebase_providers.dart';
import '../../../util/constant/config_constant.dart';
import '../../../util/extension/firestore_extension.dart';
import '../domain/word.dart';
import '../domain/word_list_state.dart';
import 'entity/word_document.dart';

part 'word_repository.g.dart';

@Riverpod(keepAlive: true)
WordRepository wordRepository(WordRepositoryRef ref) => WordRepository(
      ref.watch(firestoreProvider),
    );

class WordRepository {
  WordRepository(this.firestore);

  final FirebaseFirestore firestore;

  Future<WordDocument> fetchWord(String wordId) async {
    final DocumentSnapshot snapshot =
        await firestore.collection('Words').doc(wordId).get();

    return WordDocument.fromFirestore(snapshot);
  }

  Future<WordListState> fetchWordDocListByInitialFirst(
    String initial,
    Map<String, Map<String, int>> userPrivateWordMap,
  ) async {
    final snapshot = await firestore
        .collection('Words')
        .where(
          Filter.and(
            Filter('initialLetter', isEqualTo: initial),
            Filter.or(
              Filter('privateDefinitionCount', isEqualTo: 0),
              // 本当はFieldPath.documentId()を使いたいが、エラーになるため、
              // ドキュメントIDを保持するidフィールドを指定している
              Filter(
                'id',
                whereIn: ['word31', 'word32'],
              ),
            ),
          ),
        )
        .orderBy('reading')
        .limit(fetchLimitForWordList)
        .get();

    return _toWordListState(snapshot, initial, userPrivateWordMap);
  }

  Future<WordListState> fetchWordDocListByInitialMore(
    String initial,
    QueryDocumentSnapshot lastReadQueryDocumentSnapshot,
    Map<String, Map<String, int>> userPrivateWordMap,
  ) async {
    final QuerySnapshot snapshot = await firestore
        .collection('Words')
        .where(
          Filter.and(
            Filter('initialLetter', isEqualTo: initial),
            Filter.or(
              Filter('privateDefinitionCount', isEqualTo: 0),
              // 本当はFieldPath.documentId()を使いたいが、エラーになるため、
              // ドキュメントIDを保持するidフィールドを指定している
              Filter('id', whereIn: ['word31', 'word32']),
            ),
          ),
        )
        .orderBy('reading')
        .startAfterDocument(lastReadQueryDocumentSnapshot)
        .limit(fetchLimitForWordList)
        .get();

    return _toWordListState(snapshot, initial, userPrivateWordMap);
  }

  WordListState _toWordListState(
    QuerySnapshot snapshot,
    String initial,
    Map<String, Map<String, int>> userPrivateWordMap,
  ) {
    final wordList = _toWordList(snapshot, initial, userPrivateWordMap);

    return WordListState(
      wordList: wordList,
      lastReadQueryDocumentSnapshot: snapshot.docs.lastOrNull,
      hasMore: wordList.length == fetchLimitForWordList,
    );
  }

  List<Word> _toWordList(
    QuerySnapshot snapshot,
    String initial,
    Map<String, Map<String, int>> userPrivateWordMap,
  ) {
    final wordDoc = snapshot.docs.map(WordDocument.fromFirestore).toList();

    return wordDoc.map((wordDoc) {
      final postedDefinitionCount = wordDoc.publicDefinitionCount +
          (userPrivateWordMap[initial]?[wordDoc.id] ?? 0);

      return Word(
        id: wordDoc.id,
        word: wordDoc.word,
        reading: wordDoc.reading,
        initialLetter: wordDoc.initialLetter,
        postedDefinitionCount: postedDefinitionCount,
      );
    }).toList();
  }
}
