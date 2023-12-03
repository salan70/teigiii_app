import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/common_provider/firebase_providers.dart';
import '../../../util/constant/config_constant.dart';
import '../../../util/constant/firestore_collections.dart';
import '../../../util/constant/initial_main_group.dart';
import '../../../util/extension/firestore_extension.dart';
import '../../definition/repository/entity/definition_document.dart';
import '../domain/definition_id_list_state.dart';
import '../util/definition_feed_type.dart';

part 'definition_id_list_repository.g.dart';

@Riverpod(keepAlive: true)
DefinitionIdListRepository definitionIdListRepository(
  DefinitionIdListRepositoryRef ref,
) =>
    DefinitionIdListRepository(ref.watch(firestoreProvider));

/// [DefinitionIdListState] に関する処理を記述する Repository。
class DefinitionIdListRepository {
  DefinitionIdListRepository(this.firestore);

  final FirebaseFirestore firestore;

  CollectionReference get _definitionsCollectionRef =>
      firestore.collection(DefinitionsCollection.collectionName);

  CollectionReference get _likesCollectionRef =>
      firestore.collection(LikesCollection.collectionName);

  /// 「ホーム画面: おすすめタブ」で表示するDefinitionIDのListを取得する。
  ///
  /// [lastDocument] がnullの場合、最初のdocumentから取得する。
  Future<DefinitionIdListState> fetchForHomeRecommend(
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
    return _definitionsCollectionRef
        .where(
          Filter.or(
            Filter(
              DefinitionsCollection.authorId,
              isEqualTo: currentUserId,
            ),
            Filter(DefinitionsCollection.isPublic, isEqualTo: true),
          ),
        )
        .orderBy(createdAtFieldName, descending: true)
        .limit(fetchLimit)
        .maybeStartAfterDocument(lastDocument)
        .get();
  }

  /// 「ホーム画面: フォロー中タブ」で表示するDefinitionIDのListを取得する。
  ///
  /// [lastDocument] がnullの場合、最初のdocumentから取得する。
  Future<DefinitionIdListState> fetchForHomeFollowing(
    String currentUserId,
    List<String> targetUserIdList,
    QueryDocumentSnapshot? lastDocument,
  ) async {
    // targetUserIdList をチャンクに分割
    final chunks = _splitListIntoChunks(targetUserIdList, 10);

    final combinedDocuments = <DocumentSnapshot>[];
    for (final chunk in chunks) {
      final snapshot = await _fetchHomeFollowingSnapshotByChunk(
        currentUserId,
        chunk,
        lastDocument,
      );
      combinedDocuments.addAll(snapshot.docs);
    }

    // 結果を createdAt でソートして最初の
    // fetchLimitForDefinitionList 件を取得する。
    final sortedDocumentList = _sortAndLimitDocumentsByCreatedAt(
      combinedDocuments,
      fetchLimitForDefinitionList,
    );

    return _toDefinitionIdListState(sortedDocumentList);
  }

  /// [list] を [chunkSize] ごとに分割する。
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

  /// 「ホーム画面: フォロー中タブ」表示対象の Snapshot を取得する。
  Future<QuerySnapshot> _fetchHomeFollowingSnapshotByChunk(
    String currentUserId,
    List<String> targetUserIdChunk,
    QueryDocumentSnapshot? lastDocument,
  ) async {
    return _definitionsCollectionRef
        .where(DefinitionsCollection.authorId, whereIn: targetUserIdChunk)
        .where(
          Filter.or(
            Filter(
              DefinitionsCollection.authorId,
              isEqualTo: currentUserId,
            ),
            Filter(DefinitionsCollection.isPublic, isEqualTo: true),
          ),
        )
        .orderBy(createdAtFieldName, descending: true)
        .limit(fetchLimitForDefinitionList)
        .maybeStartAfterDocument(lastDocument)
        .get();
  }

  /// [documentList] を createdAt でソートし、
  /// [limit] 件のドキュメントを取得する。
  List<QueryDocumentSnapshot> _sortAndLimitDocumentsByCreatedAt(
    List<DocumentSnapshot> documentList,
    int limit,
  ) {
    // ソート処理
    documentList.sort((a, b) {
      final timestampA = a.get(createdAtFieldName) as Timestamp;
      final timestampB = b.get(createdAtFieldName) as Timestamp;
      return timestampB.toDate().compareTo(timestampA.toDate());
    });
    // 最初の limit 件のドキュメントを取得
    return documentList.take(limit).cast<QueryDocumentSnapshot>().toList();
  }

  /// List<DocumentSnapshot> から [DefinitionIdListState] を生成する。
  DefinitionIdListState _toDefinitionIdListState(
    List<QueryDocumentSnapshot> documentList,
  ) {
    final idList = documentList.map((doc) => doc.id).toList();

    // documentListが空でなければ最後のドキュメントを取得、空ならnull
    final lastDoc = documentList.isNotEmpty ? documentList.last : null;

    return DefinitionIdListState(
      list: idList,
      lastReadQueryDocumentSnapshot: lastDoc,
      hasMore: idList.length == fetchLimitForDefinitionList,
    );
  }

  /// 「語句トップ画面」で表示する DefinitionIDのListを取得する。
  ///
  /// [lastDocument] がnullの場合、最初のdocumentから取得する。
  Future<DefinitionIdListState> fetchForWordTop(
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
        orderByField = createdAtFieldName;
        break;
      case WordTopOrderByType.likesCount:
        orderByField = DefinitionsCollection.likesCount;
        break;
    }

    return _definitionsCollectionRef
        .where(DefinitionsCollection.wordId, isEqualTo: wordId)
        .where(
          Filter.or(
            Filter(
              DefinitionsCollection.authorId,
              isEqualTo: currentUserId,
            ),
            Filter(DefinitionsCollection.isPublic, isEqualTo: true),
          ),
        )
        .orderBy(orderByField, descending: true)
        .limit(fetchLimit)
        .maybeStartAfterDocument(lastDocument)
        .get();
  }

  /// 「プロフィール画面: 投稿順タブ」で表示するDefinitionIDのListを取得する。
  ///
  /// [lastDocument] がnullの場合、最初のdocumentから取得する。
  Future<DefinitionIdListState> fetchForProfileCreatedAt(
    String currentUserId,
    String targetUserId,
    QueryDocumentSnapshot? lastDocument,
  ) async {
    final snapshot = await _definitionsCollectionRef
        .where(DefinitionsCollection.authorId, isEqualTo: targetUserId)
        .where(
          Filter.or(
            Filter(
              DefinitionsCollection.authorId,
              isEqualTo: currentUserId,
            ),
            Filter(DefinitionsCollection.isPublic, isEqualTo: true),
          ),
        )
        .orderBy(createdAtFieldName, descending: true)
        .limit(fetchLimitForDefinitionList)
        .maybeStartAfterDocument(lastDocument)
        .get();

    return _toDefinitionIdListState(snapshot.docs);
  }

  Future<QuerySnapshot> _fetchLikeSnapshotByLikedUser(
    String likedUserId,
    QueryDocumentSnapshot? lastDocument,
    int fetchLimit,
  ) async {
    return _likesCollectionRef
        .where(LikesCollection.userId, isEqualTo: likedUserId)
        .orderBy(createdAtFieldName, descending: true)
        .limit(fetchLimit)
        .maybeStartAfterDocument(lastDocument)
        .get();
  }

  /// [targetUserId] がいいねしたDefinitionIDのListを取得する。
  ///
  /// [initialLastDocument] がnullの場合、最初のdocumentから取得する。
  Future<DefinitionIdListState> fetchForLikedByUser(
    String currentUserId,
    String targetUserId,
    List<String> mutedUserIdList,
    QueryDocumentSnapshot? initialLastDocument,
  ) async {
    final idList = <String>[];
    var lastDocument = initialLastDocument;
    var hasMore = true;
    var fetchLimit = fetchLimitForDefinitionList;

    while (fetchLimit > 0) {
      final snapshot = await _fetchLikeSnapshotByLikedUser(
        targetUserId,
        lastDocument,
        fetchLimit,
      );

      for (final likeDoc in snapshot.docs) {
        final definitionId = likeDoc[LikesCollection.definitionId] as String;
        late final DefinitionDocument definitionDoc;
        try {
          definitionDoc = await _fetchDefinition(definitionId);
        } on FirebaseException catch (e) {
          if (e.code == 'permission-denied') {
            // 取得しようとした Definition ドキュメントの isPublic が false の場合、
            // permission-denied エラーが発生するため、ここでキャッチし、
            // idListに加えないようにする。
            continue;
          }
          rethrow;
        }

        final isValid = _isValidDefinitionId(
          definitionDoc,
          currentUserId,
          mutedUserIdList,
        );
        if (isValid) {
          idList.add(definitionId);
          fetchLimit--;
        }
      }

      // 条件合う合わないに限らずこれ以上取得できるドキュメントがない場合、
      // [lastDocument]を更新せずにループを抜ける
      if (snapshot.docs.length < fetchLimit) {
        hasMore = false;
        break;
      }

      lastDocument = snapshot.docs.last;
    }

    return DefinitionIdListState(
      list: idList,
      lastReadQueryDocumentSnapshot: lastDocument,
      hasMore: hasMore,
    );
  }

  /// [definitionDoc] が表示可能かどうかを返す。
  bool _isValidDefinitionId(
    DefinitionDocument definitionDoc,
    String currentUserId,
    List<String> mutedUserIdList,
  ) {
    // 条件に合うdefinitionのidのみ返す
    // 条件: 自分の投稿
    if (definitionDoc.authorId == currentUserId) {
      return true;
    }

    // 条件: ミュートしていないユーザーの投稿
    final isPostedByMutedUser =
        mutedUserIdList.contains(definitionDoc.authorId);
    if (!isPostedByMutedUser) {
      return true;
    }

    return false;
  }

  /// ミュートしていないDefinitionIdのリストを
  /// [fetchLimitForDefinitionList] に達するまで取得する。
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

    // ミュートしていない Definition のId取得数の合計が
    // fetchLimitForDefinitionList に達するまでループする。
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
      // lastDocument を更新せずにループを抜ける。
      if (snapshot.docs.length < fetchLimit) {
        hasMore = false;
        break;
      }

      lastDocument = snapshot.docs.last;
    }

    return DefinitionIdListState(
      list: idList,
      lastReadQueryDocumentSnapshot: lastDocument,
      hasMore: hasMore,
    );
  }

  /// 「ユーザー毎の辞書 -> InitialSubGroup毎の定義一覧 画面」
  /// で表示するDefinitionIDのListを取得する。
  ///
  /// [lastDocument] がnullの場合、最初のdocumentから取得する。
  Future<DefinitionIdListState> fetchForIndividualDictionary(
    String currentUserId,
    String targetUserId,
    InitialSubGroup initialSubGroup,
    QueryDocumentSnapshot? lastDocument,
  ) async {
    final snapshot = await _definitionsCollectionRef
        .where(DefinitionsCollection.authorId, isEqualTo: targetUserId)
        .where(
          DefinitionsCollection.wordReadingInitialSubGroupLabel,
          isEqualTo: initialSubGroup.label,
        )
        .where(
          Filter.or(
            Filter(
              DefinitionsCollection.authorId,
              isEqualTo: currentUserId,
            ),
            Filter(DefinitionsCollection.isPublic, isEqualTo: true),
          ),
        )
        .orderBy(DefinitionsCollection.wordReading)
        .limit(fetchLimitForDefinitionList)
        .maybeStartAfterDocument(lastDocument)
        .get();

    return _toDefinitionIdListState(snapshot.docs);
  }

  Future<DefinitionDocument> _fetchDefinition(String definitionId) async {
    final snapshot = await _definitionsCollectionRef
        .doc(definitionId)
        .get()
        .then((snapshot) => snapshot);

    return DefinitionDocument.fromFirestore(snapshot);
  }
}
