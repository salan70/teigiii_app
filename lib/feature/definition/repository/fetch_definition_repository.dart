import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/common_provider/firebase_providers.dart';
import '../../../util/constant/config_constant.dart';
import '../../../util/constant/firestore_collections.dart';
import '../../../util/constant/initial_main_group.dart';
import '../../../util/extension/firestore_extension.dart';
import '../../user_profile/domain/user_id_list_state.dart';
import '../domain/definition_id_list_state.dart';
import '../util/definition_feed_type.dart';
import 'entity/definition_document.dart';

part 'fetch_definition_repository.g.dart';

@Riverpod(keepAlive: true)
FetchDefinitionRepository fetchDefinitionRepository(
  FetchDefinitionRepositoryRef ref,
) =>
    FetchDefinitionRepository(
      ref.watch(firestoreProvider),
    );

// TODO(me): DefinitionIdListStateの取得に絞ってもいいかも
// TODO(me): 全体的に関数名に納得がいってないのでなんとかする

/// 定義の取得に関する処理を記述するRepository
class FetchDefinitionRepository {
  FetchDefinitionRepository(this.firestore);

  final FirebaseFirestore firestore;

  CollectionReference get _definitionsCollectionRef =>
      firestore.collection(DefinitionsCollection.collectionName);

  CollectionReference get _likesCollectionRef =>
      firestore.collection(LikesCollection.collectionName);

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
    var query = _definitionsCollectionRef
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
        .limit(fetchLimit);

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }

    return query.get();
  }

  /// 「ホーム画面: フォロー中タブ」で表示するDefinitionIDのListを取得する
  ///
  /// [lastDocument]がnullの場合、最初のdocumentから取得する。
  /// 無限スクロールなどで、2回目以降の取得の場合、
  /// [lastDocument]に前回取得した最後のdocumentを指定すること。
  Future<DefinitionIdListState> fetchHomeFollowingDefinitionIdListState(
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

    // 結果をcreatedAtでソートして最初の [fetchLimitForDefinitionList] 件を取得
    final sortedDocumentList = _sortAndLimitDocumentsByCreatedAt(
      combinedDocuments,
      fetchLimitForDefinitionList,
    );

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
    var query = _definitionsCollectionRef
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
      final timestampA = a.get(createdAtFieldName) as Timestamp;
      final timestampB = b.get(createdAtFieldName) as Timestamp;
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
      list: idList,
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
        orderByField = createdAtFieldName;
        break;
      case WordTopOrderByType.likesCount:
        orderByField = DefinitionsCollection.likesCount;
        break;
    }

    var query = _definitionsCollectionRef
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
        .limit(fetchLimit);

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }

    return query.get();
  }

  /// 「プロフィール画面: 投稿順タブ」で表示するDefinitionIDのListを取得する
  ///
  /// [lastDocument]がnullの場合、最初のdocumentから取得する。
  /// 無限スクロールなどで、2回目以降の取得の場合、
  /// [lastDocument]に前回取得した最後のdocumentを指定すること。
  Future<DefinitionIdListState> fetchProfileCreatedAtDefinitionIdListState(
    String currentUserId,
    String targetUserId,
    QueryDocumentSnapshot? lastDocument,
  ) async {
    var query = _definitionsCollectionRef
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
        .limit(fetchLimitForDefinitionList);

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }

    final snapshot = await query.get();

    return _toDefinitionIdListState(snapshot.docs);
  }

  Future<QuerySnapshot> _fetchLikeSnapshotByLikedUser(
    String likedUserId,
    QueryDocumentSnapshot? lastDocument,
    int fetchLimit,
  ) async {
    var query = _likesCollectionRef
        .where(LikesCollection.userId, isEqualTo: likedUserId)
        .orderBy(createdAtFieldName, descending: true)
        .limit(fetchLimit);

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }
    return query.get();
  }

  /// [targetUserId]がいいねしたDefinitionIDのListを取得する
  ///
  /// [initialLastDocument]がnullの場合、最初のdocumentから取得する。
  /// 無限スクロールなどで、2回目以降の取得の場合、
  /// [initialLastDocument]に前回取得した最後のdocumentを指定すること。
  Future<DefinitionIdListState> fetchLikedByUserDefinitionIdListState(
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
          definitionDoc = await fetchDefinition(definitionId);
        } on FirebaseException catch (e) {
          if (e.code == 'permission-denied') {
            // 取得しようとしたDefinitionドキュメントのisPublicがfalseの場合、
            // permission-deniedエラーが発生するため、ここでキャッチし、
            // idListに加えないようにする
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

  /// [definitionDoc]が表示可能かどうかを返す
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
    // isPublicについては、rulesに設定すれば、permissionエラーを出せる気がする
    // その場合、エラーが発生した場合は、そのdefinitionを表示しないようにする

    // 条件: ミュートしていないユーザーの投稿
    final isPostedByMutedUser =
        mutedUserIdList.contains(definitionDoc.authorId);
    if (!isPostedByMutedUser) {
      return true;
    }

    return false;
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
      list: idList,
      lastReadQueryDocumentSnapshot: lastDocument,
      hasMore: hasMore,
    );
  }

  Future<DefinitionDocument> fetchDefinition(String definitionId) async {
    final snapshot = await _definitionsCollectionRef
        .doc(definitionId)
        .get()
        .then((snapshot) => snapshot);

    return DefinitionDocument.fromFirestore(snapshot);
  }

  /// 「ユーザー毎の辞書 -> InitialSubGroup毎の定義一覧 画面」
  /// で表示するDefinitionIDのListを取得する
  ///
  /// [lastDocument]がnullの場合、最初のdocumentから取得する。
  /// 無限スクロールなどで、2回目以降の取得の場合、
  /// [lastDocument]に前回取得した最後のdocumentを指定すること。
  Future<DefinitionIdListState> fetchIndividualDictionaryDefinitionIdListState(
    String currentUserId,
    String targetUserId,
    InitialSubGroup initialSubGroup,
    QueryDocumentSnapshot? lastDocument,
  ) async {
    var query = _definitionsCollectionRef
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
        .orderBy(DefinitionsCollection.wordReading, descending: true)
        .limit(fetchLimitForDefinitionList);

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }

    final snapshot = await query.get();

    return _toDefinitionIdListState(snapshot.docs);
  }

  /// [definitionId]をいいねしたユーザーのIDリストを[fetchLimitForUserIdList]件取得
  ///
  /// [lastDocument]がnullの場合、最初のdocumentから取得する。
  /// 無限スクロールなどで、2回目以降の取得の場合、
  /// [lastDocument]に前回取得した最後のdocumentを指定すること。
  Future<UserIdListState> fetchLikedUserIdList(
    String definitionId,
    QueryDocumentSnapshot? lastDocument,
  ) async {
    var query = _likesCollectionRef
        .where(LikesCollection.definitionId, isEqualTo: definitionId)
        .orderBy(createdAtFieldName, descending: true)
        .limit(fetchLimitForUserIdList);

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }

    final snapshot = await query.get();
    final favoriteUserIdList = snapshot.docs
        .map((doc) => doc[LikesCollection.userId] as String)
        .toList();

    return UserIdListState(
      list: favoriteUserIdList,
      lastReadQueryDocumentSnapshot: snapshot.docs.lastOrNull,
      hasMore: favoriteUserIdList.length == fetchLimitForUserIdList,
    );
  }
}
