import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/common_provider/firebase_providers.dart';
import '../../../util/constant/config_constant.dart';
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

  Future<WordDocument> fetchWordById(String wordId) async {
    final DocumentSnapshot snapshot =
        await firestore.collection('Words').doc(wordId).get();

    return WordDocument.fromFirestore(snapshot);
  }

  /// [word], [wordReading]両方が一致するWordドキュメントのidを返す
  ///
  /// 見つからない場合はnullを返す
  Future<String?> findWordId(String word, String wordReading) async {
    final snapshot = await firestore
        .collection('Words')
        .where('word', isEqualTo: word)
        .where('reading', isEqualTo: wordReading)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) {
      // 該当するWordドキュメントが見つからない場合、nullを返す
      return null;
    }

    return snapshot.docs.first.id;
  }

  /// [documentSnapshot]に指定したdocumentよりも後のdocumentを取得する
  ///
  /// [documentSnapshot]がnullの場合、最初のdocumentから取得する
  Future<WordListState> fetchWordListStateByInitial(
    String initial,
    String currentUserId,
    List<String> mutedUserIdList,
    QueryDocumentSnapshot? documentSnapshot,
  ) async {
    return _fetchWordListState(
      (doc, limit) => _fetchWordDocSnapshotByInitial(initial, doc, limit),
      currentUserId,
      mutedUserIdList,
      documentSnapshot,
    );
  }

  /// [documentSnapshot]に指定したdocumentよりも後のdocumentを取得する
  ///
  /// [documentSnapshot]がnullの場合、最初のdocumentから取得する
  Future<WordListState> fetchWordListStateBySearchWord(
    String searchWord,
    String currentUserId,
    List<String> mutedUserIdList,
    QueryDocumentSnapshot? documentSnapshot,
  ) async {
    return _fetchWordListState(
      (doc, limit) => _fetchWordDocSnapshotBySearchWord(searchWord, doc, limit),
      currentUserId,
      mutedUserIdList,
      documentSnapshot,
    );
  }

  /// 条件に合うWordを[fetchLimitForWordList]に達するまで取得し、
  /// [WordListState]として返す
  Future<WordListState> _fetchWordListState(
    Future<QuerySnapshot> Function(QueryDocumentSnapshot?, int)
        fetchWordDocSnapshot,
    String currentUserId,
    List<String> mutedUserIdList,
    QueryDocumentSnapshot? documentSnapshot,
  ) async {
    final wordList = <Word>[];
    var hasMore = true;
    var lastDocument = documentSnapshot;
    var fetchLimit = fetchLimitForWordList;

    // 条件に合うWordの取得数の合計が[fetchLimitForWordList]に達するまでループする
    while (fetchLimit > 0) {
      final snapshot = await fetchWordDocSnapshot(lastDocument, fetchLimit);

      final newWordList = await _generateWordList(
        snapshot,
        currentUserId,
        mutedUserIdList,
      );
      wordList.addAll(newWordList);
      fetchLimit -= newWordList.length;

      // これ以上取得できるWordDocがない場合、
      // [lastDocument]を更新せずにループを抜ける
      if (snapshot.docs.length < fetchLimit) {
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

  Future<QuerySnapshot> _fetchWordDocSnapshotByInitial(
    String initial,
    DocumentSnapshot? lastDocument,
    int fetchLimit,
  ) {
    var query = firestore
        .collection('Words')
        .where('initialLetter', isEqualTo: initial)
        .orderBy('reading')
        .limit(fetchLimit);

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }

    return query.get();
  }

  Future<QuerySnapshot> _fetchWordDocSnapshotBySearchWord(
    String searchWord,
    DocumentSnapshot? lastDocument,
    int fetchLimit,
  ) {
    var query = firestore.collection('Words').orderBy('word').startAt(
      [searchWord],
    ).endAt(['$searchWord\uf8ff']).limit(fetchLimit);

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
      final postedDefinitionCount = await fetchPostedDefinitionCount(
        wordDoc.id,
        currentUserId,
        mutedUserIdList,
      );

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

  Future<int> fetchPostedDefinitionCount(
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

    // ミュートしているユーザーがいる場合、ミュートしているユーザーの投稿数を引く
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
