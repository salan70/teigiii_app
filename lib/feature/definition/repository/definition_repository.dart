import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/common_provider/firebase_providers.dart';
import '../../../util/constant/config_constant.dart';
import '../../../util/extension/firestore_extension.dart';
import '../domain/definition_for_write.dart';
import '../domain/definition_id_list_state.dart';
import '../util/definition_feed_type.dart';
import 'entity/definition_document.dart';

part 'definition_repository.g.dart';

@Riverpod(keepAlive: true)
DefinitionRepository definitionRepository(DefinitionRepositoryRef ref) =>
    DefinitionRepository(
      ref.watch(firestoreProvider),
    );

class DefinitionRepository {
  DefinitionRepository(this.firestore);

  final FirebaseFirestore firestore;

  /// 「ホーム画面: おすすめタブ」で表示するDefinitionIDのListを取得する
  ///
  /// [lastDocument]がnullの場合、最初のdocumentから取得する。
  /// 無限スクロールなどで、2回目以降の取得の場合、
  /// [lastDocument]に前回取得した最後のdocumentを指定すること。
  Future<DefinitionIdListState> fetchHomeRecommendDefinitionIdListState(
    String currentUserId,
    List<String> mutedUserIdList,
    QueryDocumentSnapshot? lastDocument,
  ) async {
    return _fetchUnmutedDefinitionIdList(
      (doc, limit) => _fetchHomeRecommendSnapshot(
        currentUserId,
        doc,
        limit,
      ),
      currentUserId,
      mutedUserIdList,
      lastDocument,
    );
  }

  Future<QuerySnapshot> _fetchHomeRecommendSnapshot(
    String currentUserId,
    QueryDocumentSnapshot? lastDocument,
    int fetchLimit,
  ) async {
    var query = firestore
        .collection('Definitions')
        .where(
          Filter.or(
            Filter('authorId', isEqualTo: currentUserId),
            Filter('isPublic', isEqualTo: true),
          ),
        )
        .orderBy('createdAt', descending: true)
        .limit(fetchLimit);

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
      // TODO(me): デバッグ用のためリリース時に削除する
      // 1/2の確率でエラーを発生させる
      if (Random().nextInt(3) == 0) {
        throw Exception('やばいで！！！！！');
      }
    }

    return query.get();
  }

  /// 「ホーム画面: フォロー中タブ」で表示するDefinitionIDのListを取得する
  ///
  /// [lastDocument]がnullの場合、最初のdocumentから取得する。
  /// 無限スクロールなどで、2回目以降の取得の場合、
  /// [lastDocument]に前回取得した最後のdocumentを指定すること。
  Future<DefinitionIdListState> fetchHomeFollowingDefinitionIdList(
    String currentUserId,
    List<String> targetUserIdList,
    QueryDocumentSnapshot? lastDocument,
  ) async {
    // targetUserIdListをチャンクに分割
    final chunks = _splitListIntoChunks(targetUserIdList, 10);

    final combinedDocuments = <DocumentSnapshot>[];
    for (final chunk in chunks) {
      final snapshot = await _fetchHomeFollowingSnapshotForChunk(
        currentUserId,
        chunk,
        lastDocument,
      );
      combinedDocuments.addAll(snapshot.docs);
    }

    // 結果をcreatedAtでソートして最初の10件を取得
    final sortedDocumentList =
        _sortAndLimitDocumentsByCreatedAt(combinedDocuments, 10);

    return _toDefinitionIdListState(sortedDocumentList);
  }

  /// [list] を [chunkSize] ごとに分割する
  List<List<String>> _splitListIntoChunks(List<String> list, int chunkSize) {
    final chunks = <List<String>>[];
    for (var i = 0; i < list.length; i += chunkSize) {
      final chunkEnd = i + chunkSize;
      chunks.add(
        list.sublist(i, chunkEnd > list.length ? list.length : chunkEnd),
      );
    }
    return chunks;
  }

  /// 「ホーム画面: フォロー中タブ」表示対象のSnapshotを取得する。
  Future<QuerySnapshot> _fetchHomeFollowingSnapshotForChunk(
    String currentUserId,
    List<String> targetUserIdChunk,
    QueryDocumentSnapshot? lastDocument,
  ) async {
    var query = firestore
        .collection('Definitions')
        .where('authorId', whereIn: targetUserIdChunk)
        .where(
          Filter.or(
            Filter('authorId', isEqualTo: currentUserId),
            Filter('isPublic', isEqualTo: true),
          ),
        )
        .orderBy('createdAt', descending: true)
        .limit(fetchLimitForDefinitionList);

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }

    return query.get();
  }

  /// [documentList] をcreatedAtでソートし、[limit] 件のドキュメントを取得する
  List<QueryDocumentSnapshot> _sortAndLimitDocumentsByCreatedAt(
    List<DocumentSnapshot> documentList,
    int limit,
  ) {
    // ソート処理
    documentList.sort((a, b) {
      final timestampA = a.get('createdAt') as Timestamp;
      final timestampB = b.get('createdAt') as Timestamp;
      return timestampB.toDate().compareTo(timestampA.toDate());
    });
    // 最初の`limit`件のドキュメントを取得
    return documentList.take(limit).cast<QueryDocumentSnapshot>().toList();
  }

  /// List<DocumentSnapshot>からDefinitionIdListStateを生成する
  DefinitionIdListState _toDefinitionIdListState(
    List<QueryDocumentSnapshot> documentList,
  ) {
    final idList = documentList.map((doc) => doc.id).toList();

    // documentListが空でなければ最後のドキュメントを取得、空ならnull
    final lastDoc = documentList.isNotEmpty ? documentList.last : null;

    return DefinitionIdListState(
      definitionIdList: idList,
      lastReadQueryDocumentSnapshot: lastDoc,
      hasMore: idList.length == fetchLimitForDefinitionList,
    );
  }

  /// 「語句トップ画面」で表示するDefinitionIDのListを取得する
  ///
  /// [lastDocument]がnullの場合、最初のdocumentから取得する。
  /// 無限スクロールなどで、2回目以降の取得の場合、
  /// [lastDocument]に前回取得した最後のdocumentを指定すること。
  Future<DefinitionIdListState> fetchWordTopDefinitionIdListState(
    WordTopOrderByType orderByType,
    String currentUserId,
    List<String> mutedUserIdList,
    String wordId,
    QueryDocumentSnapshot? lastDocument,
  ) async {
    return _fetchUnmutedDefinitionIdList(
      (doc, limit) => _fetchWordTopSnapshot(
        orderByType,
        currentUserId,
        wordId,
        doc,
        limit,
      ),
      currentUserId,
      mutedUserIdList,
      lastDocument,
    );
  }

  Future<QuerySnapshot> _fetchWordTopSnapshot(
    WordTopOrderByType orderByType,
    String currentUserId,
    String wordId,
    DocumentSnapshot? lastDocument,
    int fetchLimit,
  ) async {
    late final String orderByField;
    switch (orderByType) {
      case WordTopOrderByType.createdAt:
        orderByField = 'createdAt';
        break;
      case WordTopOrderByType.likesCount:
        orderByField = 'likesCount';
        break;
    }

    var query = firestore
        .collection('Definitions')
        .where('wordId', isEqualTo: wordId)
        .where(
          Filter.or(
            Filter('authorId', isEqualTo: currentUserId),
            Filter('isPublic', isEqualTo: true),
          ),
        )
        .orderBy(orderByField, descending: true)
        .limit(fetchLimit);

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }

    return query.get();
  }

  /// ミュートしていないDefinitionIdのリストを
  /// [fetchLimitForDefinitionList]に達するまで取得する
  Future<DefinitionIdListState> _fetchUnmutedDefinitionIdList(
    Future<QuerySnapshot> Function(QueryDocumentSnapshot?, int)
        fetchWordDocSnapshot,
    String currentUserId,
    List<String> mutedUserIdList,
    QueryDocumentSnapshot? documentSnapshot,
  ) async {
    final idList = <String>[];
    var lastDocument = documentSnapshot;
    var hasMore = true;
    var fetchLimit = fetchLimitForDefinitionList;

    // ミュートしていないDefinitionのid取得数の合計が
    // [fetchLimitForDefinitionList]に達するまでループする
    while (fetchLimit > 0) {
      final snapshot = await fetchWordDocSnapshot(lastDocument, fetchLimit);

      final validIdList = snapshot.docs
          .map((doc) {
            final definitionDoc = DefinitionDocument.fromFirestore(doc);
            // ミュートしていないユーザーが投稿したidのみ返す
            if (!mutedUserIdList.contains(definitionDoc.authorId)) {
              return definitionDoc.id;
            }
          })
          .whereType<String>()
          .toList();

      idList.addAll(validIdList);
      fetchLimit -= validIdList.length;

      // muteに限らずこれ以上取得できるドキュメントがない場合、
      // [lastDocument]を更新せずにループを抜ける
      if (snapshot.docs.length < fetchLimit) {
        hasMore = false;
        break;
      }

      lastDocument = snapshot.docs.last;
    }

    return DefinitionIdListState(
      definitionIdList: idList,
      lastReadQueryDocumentSnapshot: lastDocument,
      hasMore: hasMore,
    );
  }

  Future<DefinitionDocument> fetchDefinition(String definitionId) async {
    final snapshot = await firestore
        .collection('Definitions')
        .doc(definitionId)
        .get()
        .then((snapshot) => snapshot);

    return DefinitionDocument.fromFirestore(snapshot);
  }

  Future<void> createDefinitionAndMaybeWord(
    String authorId,
    String? existingWordId,
    DefinitionForWrite definitionForWrite,
  ) async {
    // Wordドキュメントが存在しない場合は新規作成する
    if (existingWordId == null) {
      await firestore.runTransaction((transaction) async {
        // Wordドキュメントを新規作成し、
        // 作成したドキュメントのidをもとにDefinitionドキュメントを作成する
        final newWordId = await _createWord(
          definitionForWrite.word,
          definitionForWrite.wordReading,
        );
        await _createDefinition(authorId, newWordId, definitionForWrite);
      });
      return;
    }

    // Wordドキュメントが存在する場合、Definitionドキュメントのみ作成する
    await _createDefinition(authorId, existingWordId, definitionForWrite);
  }

  Future<void> _createDefinition(
    String authorId,
    String wordId,
    DefinitionForWrite definitionForWrite,
  ) async {
    await firestore.collection('Definitions').add({
      ...definitionForWrite.toFirestoreForCreate(),
      'authorId': authorId,
      'wordId': wordId,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateDefinitionAndMaybeCreateWord(
    String? existingWordId,
    DefinitionForWrite definitionForWrite,
  ) async {
    // Wordドキュメントが存在しない場合は新規作成する
    if (existingWordId == null) {
      await firestore.runTransaction((transaction) async {
        // Wordドキュメントを新規作成し、
        // 作成したドキュメントのidをもとにDefinitionドキュメントを作成する
        final newWordId = await _createWord(
          definitionForWrite.word,
          definitionForWrite.wordReading,
        );
        await _updateDefinition(newWordId, definitionForWrite);
      });
      return;
    }

    // Wordドキュメントが存在する場合、Definitionドキュメントの更新のみ実行する
    await _updateDefinition(existingWordId, definitionForWrite);
  }

  Future<void> _updateDefinition(
    String wordId,
    DefinitionForWrite definitionForWrite,
  ) async {
    await firestore.collection('Definitions').doc(definitionForWrite.id).update(
      {
        ...definitionForWrite.toFirestoreForUpdate(),
        'wordId': wordId,
        'updatedAt': FieldValue.serverTimestamp(),
      },
    );
  }

  // Definitionドキュメントの作成/更新処理とバッチ実行する必要があるため、このクラスに作成している。
  /// Wordドキュメントを作成し、作成したドキュメントのidを返す。
  Future<String> _createWord(String word, String wordReading) async {
    final initialLetter = wordReading.substring(0, 1);
    final docRef = await firestore.collection('Words').add(
      {
        'word': word,
        'reading': wordReading,
        'initialLetter': initialLetter,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
    );

    return docRef.id;
  }

  Future<void> likeDefinition(String definitionId, String userId) async {
    // transactionを使い、複数の処理が全て成功した場合のみ、処理を完了させる
    await firestore.runTransaction((transaction) async {
      // Likesコレクションにドキュメントを登録
      final likesCollection = firestore.collection('Likes');
      transaction.set(likesCollection.doc(), {
        'definitionId': definitionId,
        'userId': userId,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // DefinitionコレクションからドキュメントのlikesCountを+1する
      final definitionDocRef =
          firestore.collection('Definitions').doc(definitionId);
      transaction.update(definitionDocRef, {
        'likesCount': FieldValue.increment(1),
      });
    });
  }

  Future<void> unlikeDefinition(String definitionId, String userId) async {
    await firestore.runTransaction((transaction) async {
      // Likesコレクションからドキュメントを取得して削除
      final likeSnapshot = await firestore
          .collection('Likes')
          .where('definitionId', isEqualTo: definitionId)
          .where('userId', isEqualTo: userId)
          .get()
          .then((snapshot) => snapshot.docs.firstOrNull);

      if (likeSnapshot == null) {
        throw Exception('いいね解除が失敗しました。');
      }

      transaction.delete(likeSnapshot.reference);

      // DefinitionコレクションからドキュメントのlikesCountを-1する
      final definitionDocRef =
          firestore.collection('Definitions').doc(definitionId);
      transaction.update(definitionDocRef, {
        'likesCount': FieldValue.increment(-1),
      });
    });
  }

  Future<bool> isLikedByUser(String userId, String definitionId) async {
    final likeSnapshot = await firestore
        .collection('Likes')
        .where('definitionId', isEqualTo: definitionId)
        .where('userId', isEqualTo: userId)
        .get()
        .then((snapshot) => snapshot.docs.firstOrNull);

    return likeSnapshot != null;
  }
}
