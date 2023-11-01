import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/common_provider/firebase_providers.dart';
import '../../../util/constant/config_constant.dart';
import '../../../util/logger.dart';
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

  Future<WordListState> fetchWordListStateFirst(
    String initial,
    String currentUserId,
    List<String> mutedUserIdList,
  ) async {
    return _fetchWordListState(
      initial,
      currentUserId,
      mutedUserIdList,
      null,
    );
  }

  Future<WordListState> fetchWordListStateMore(
    String initial,
    String currentUserId,
    List<String> mutedUserIdList,
    QueryDocumentSnapshot lastDocument,
  ) async {
    return _fetchWordListState(
      initial,
      currentUserId,
      mutedUserIdList,
      lastDocument,
    );
  }

  Future<WordListState> _fetchWordListState(
    String initial,
    String currentUserId,
    List<String> mutedUserIdList,
    QueryDocumentSnapshot? documentSnapshot,
  ) async {
    final wordList = <Word>[];
    var hasMore = true;
    var lastDocument = documentSnapshot;

    while (hasMore) {
      final snapshot = await _fetchWordDocSnapshot(initial, lastDocument);
      final newWordList = await _generateWordList(
        snapshot,
        currentUserId,
        mutedUserIdList,
      );

      wordList.addAll(newWordList);

      // これ以上取得できるWordDocがない場合
      if (snapshot.docs.length < fetchLimitForWordList) {
        hasMore = false;
        break;
      }

      // これ以上取得できる、条件に合うWordDocがない場合
      if (newWordList.isEmpty) {
        hasMore = false;
        break;
      }

      lastDocument = snapshot.docs.last;
    }

    return WordListState(
      wordList: wordList,
      lastReadQueryDocumentSnapshot: lastDocument,
      hasMore: hasMore,
    );
  }

  Future<QuerySnapshot> _fetchWordDocSnapshot(
    String initial,
    DocumentSnapshot? lastDocument,
  ) {
    var query = firestore
        .collection('Words')
        .where('initialLetter', isEqualTo: initial)
        .orderBy('reading')
        .limit(fetchLimitForWordList);

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }

    return query.get();
  }

  /// snapshotからWordのリストを生成する
  ///
  /// Wordのリストを生成する際、条件に合う定義の投稿数を取得する
  ///
  /// 条件に合う定義の投稿数が0の場合、そのWordを追加しない
  Future<List<Word>> _generateWordList(
    QuerySnapshot snapshot,
    String currentUserId,
    List<String> mutedUserIdList,
  ) async {
    final wordDocList = snapshot.docs.map(WordDocument.fromFirestore).toList();

    final wordList = <Word>[];
    for (final wordDoc in wordDocList) {
      final postedDefinitionCount = await _fetchPostedDefinitionCount(
        wordDoc.id,
        currentUserId,
        mutedUserIdList,
      );

      logger.d('postedDefinitionCount: $postedDefinitionCount');

      // 条件に合う定義が投稿されていない場合、Wordを追加しない
      if (postedDefinitionCount == 0) {
        continue;
      }

      wordList.add(
        Word(
          id: wordDoc.id,
          word: wordDoc.word,
          reading: wordDoc.reading,
          initialLetter: wordDoc.initialLetter,
          postedDefinitionCount: postedDefinitionCount,
        ),
      );
    }

    return wordList;
  }

  Future<int> _fetchPostedDefinitionCount(
    String wordId,
    String currentUserId,
    List<String> mutedUserIdList,
  ) async {
    final allDefinitionSnapshot = await firestore
        .collection('Definitions')
        .where('wordId', isEqualTo: wordId)
        .where(
          Filter.or(
            Filter('authorId', isEqualTo: currentUserId),
            Filter('isPublic', isEqualTo: true),
          ),
        )
        .count()
        .get();
    final allDefinitionCount = allDefinitionSnapshot.count;

    if (mutedUserIdList.isEmpty) {
      return allDefinitionCount;
    }

    final mutedDefinitionCount = await _fetchMutedDefinitionCount(
      wordId,
      mutedUserIdList,
      allDefinitionCount,
    );

    return allDefinitionCount - mutedDefinitionCount;
  }

  Future<int> _fetchMutedDefinitionCount(
    String wordId,
    List<String> mutedUserIdList,
    int maxCount,
  ) async {
    var mutedDefinitionCount = 0;

    // mutedUserIdListを10項目ずつのチャンクに分割
    for (var i = 0; i < mutedUserIdList.length; i += 10) {
      final end =
          i + 10 < mutedUserIdList.length ? i + 10 : mutedUserIdList.length;
      final chunk = mutedUserIdList.sublist(i, end);

      final mutedSnapshot = await firestore
          .collection('Definitions')
          .where('wordId', isEqualTo: wordId)
          .where('authorId', whereIn: chunk)
          .where('isPublic', isEqualTo: true)
          .count()
          .get();

      mutedDefinitionCount += mutedSnapshot.count;

      // maxCountに達することは、
      // これ以上snapshotを取得する意味がないことを意味する
      if (mutedDefinitionCount == maxCount) {
        break;
      }
    }

    return mutedDefinitionCount;
  }
}
