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

  Future<WordListState> fetchWordDocListByInitial(String initial) async {
    final QuerySnapshot snapshot = await firestore
        .collection('Words')
        .where('initialLetter', isEqualTo: initial)
        .get();

    return _toWordListState(snapshot);
  }

  WordListState _toWordListState(QuerySnapshot snapshot) {
    final wordList = _toWordList(snapshot);

    return WordListState(
      wordList: wordList,
      lastReadQueryDocumentSnapshot: snapshot.docs.lastOrNull,
      hasMore: wordList.length == fetchLimitForUserIdList,
    );
  }

  List<Word> _toWordList(QuerySnapshot snapshot) {
    final wordDoc = snapshot.docs.map(WordDocument.fromFirestore).toList();

    return wordDoc.map((wordDoc) {
      return Word(
        id: wordDoc.id,
        word: wordDoc.word,
        reading: wordDoc.reading,
        initialLetter: wordDoc.initialLetter,
        postedDefinitionCount: 3,
      );
    }).toList();
  }
}
