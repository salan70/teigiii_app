import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/common_provider/firebase_providers.dart';
import '../../../util/constant/config_constant.dart';
import '../../../util/constant/firestore_collections.dart';
import '../../word/domain/word.dart';
import '../../word/repository/entity/word_document.dart';
import '../domain/word_list_state.dart';

part 'fetch_word_list_repository.g.dart';

@riverpod
FetchWordListRepository fetchWordListRepository(FetchWordListRepositoryRef ref) =>
    FetchWordListRepository(ref.watch(firestoreProvider));

class FetchWordListRepository {
  FetchWordListRepository(this.firestore);

  final FirebaseFirestore firestore;

  CollectionReference get _wordsCollectionRef =>
      firestore.collection(WordsCollection.collectionName);

  CollectionReference get _definitionsCollectionRef =>
      firestore.collection(DefinitionsCollection.collectionName);
      

  /// [documentSnapshot] に指定したdocumentよりも後のdocumentを取得する。
  ///
  /// [documentSnapshot] がnullの場合、最初のdocumentから取得する。
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

  /// [documentSnapshot] に指定したdocumentよりも後のdocumentを取得する。
  ///
  /// [documentSnapshot] がnullの場合、最初のdocumentから取得する。
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

  /// 条件に合う [Word] を [fetchLimitForWordList] に達するまで取得し、
  /// [WordListState] として返す。
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

    // 条件に合う Word の取得数の合計が fetchLimitForWordList に達するまでループする
    while (fetchLimit > 0) {
      final snapshot = await fetchWordDocSnapshot(lastDocument, fetchLimit);

      final newWordList = await _generateWordList(
        snapshot,
        currentUserId,
        mutedUserIdList,
      );
      wordList.addAll(newWordList);
      fetchLimit -= newWordList.length;

      // これ以上取得できる WordDoc がない場合、
      // lastDocument を更新せずにループを抜ける。
      if (snapshot.docs.length < fetchLimit) {
        hasMore = false;
        break;
      }

      lastDocument = snapshot.docs.last;
    }

    return WordListState(
      list: wordList,
      lastReadQueryDocumentSnapshot: lastDocument,
      hasMore: hasMore,
    );
  }

  Future<QuerySnapshot> _fetchWordDocSnapshotByInitial(
    String initial,
    DocumentSnapshot? lastDocument,
    int fetchLimit,
  ) {
    var query = _wordsCollectionRef
        .where(WordsCollection.initialSubGroupLabel, isEqualTo: initial)
        .orderBy(WordsCollection.reading)
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
    var query = _wordsCollectionRef.orderBy(WordsCollection.word).startAt(
      [searchWord],
    ).endAt(['$searchWord\uf8ff']).limit(fetchLimit);

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }

    return query.get();
  }

  /// snapshot から [Word] のリストを生成する。
  ///
  /// [Word] のリストを生成する際、条件に合う定義の投稿数を取得する。
  ///
  /// 条件に合う定義の投稿数が0の場合、その [Word] を追加しない
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

      // 条件に合う定義が投稿されていない場合、 [Word] を追加しない。
      if (postedDefinitionCount == 0) {
        continue;
      }

      wordList.add(
        Word(
          id: wordDoc.id,
          word: wordDoc.word,
          reading: wordDoc.reading,
          initialSubGroupLabel: wordDoc.initialSubGroupLabel,
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
    final allDefinitionSnapshot = await _definitionsCollectionRef
        .where(DefinitionsCollection.wordId, isEqualTo: wordId)
        .where(
          Filter.or(
            Filter(DefinitionsCollection.authorId, isEqualTo: currentUserId),
            Filter(DefinitionsCollection.isPublic, isEqualTo: true),
          ),
        )
        .count()
        .get();
    final allDefinitionCount = allDefinitionSnapshot.count;

    if (mutedUserIdList.isEmpty) {
      return allDefinitionCount;
    }

    // ミュートしているユーザーがいる場合、ミュートしているユーザーの投稿数を引く。
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

    // mutedUserIdList を10項目ずつのチャンクに分割する。
    for (var i = 0; i < mutedUserIdList.length; i += 10) {
      final end =
          i + 10 < mutedUserIdList.length ? i + 10 : mutedUserIdList.length;
      final chunk = mutedUserIdList.sublist(i, end);

      final mutedSnapshot = await _definitionsCollectionRef
          .where(DefinitionsCollection.wordId, isEqualTo: wordId)
          .where(DefinitionsCollection.authorId, whereIn: chunk)
          .where(DefinitionsCollection.isPublic, isEqualTo: true)
          .count()
          .get();

      mutedDefinitionCount += mutedSnapshot.count;

      // maxCount に達することは、
      // これ以上 snapshot を取得する意味がないことを意味する。
      if (mutedDefinitionCount == maxCount) {
        break;
      }
    }

    return mutedDefinitionCount;
  }
}
