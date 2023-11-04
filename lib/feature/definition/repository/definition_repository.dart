import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/common_provider/firebase_providers.dart';
import '../../../util/constant/config_constant.dart';
import '../../../util/extension/firestore_extension.dart';
import '../../../util/extension/string_list_extension.dart';
import '../domain/definition_for_write.dart';
import '../domain/definition_id_list_state.dart';
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

  /// 「ホーム画面: おすすめタブ」で表示するDefinitionIDのListを取得する（初回）
  Future<DefinitionIdListState> fetchHomeRecommendDefinitionIdListFirst(
    List<String> mutedUserIdList,
  ) async {
    final snapshot = await firestore
        .collection('Definitions')
        .where('authorId', whereNotIn: mutedUserIdList.orSingleEmptyStringList)
        .orderBy('authorId')
        .where('isPublic', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .limit(fetchLimitForDefinitionList)
        .get();

    return _toDefinitionIdListState(snapshot);
  }

  /// 「ホーム画面: おすすめタブ」で表示するDefinitionIDのListを取得する（2回目以降）
  Future<DefinitionIdListState> fetchHomeRecommendDefinitionIdListMore(
    List<String> mutedUserIdList,
    QueryDocumentSnapshot lastReadQueryDocumentSnapshot,
  ) async {
    final snapshot = await firestore
        .collection('Definitions')
        .where('authorId', whereNotIn: mutedUserIdList.orSingleEmptyStringList)
        .orderBy('authorId')
        .where('isPublic', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .startAfterDocument(lastReadQueryDocumentSnapshot)
        .limit(fetchLimitForDefinitionList)
        .get();

    // 1/2の確率でエラーを発生させる
    if (Random().nextInt(2) == 0) {
      throw Exception('やばいで！！！！！');
    }

    return _toDefinitionIdListState(snapshot);
  }

  /// 「ホーム画面: フォロー中タブ」で表示するDefinitionIDのListを取得する（初回）
  Future<DefinitionIdListState> fetchHomeFollowingDefinitionIdListFirst(
    List<String> targetUserIdList,
  ) async {
    final snapshot = await firestore
        .collection('Definitions')
        .where('authorId', whereIn: targetUserIdList)
        .where('isPublic', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .limit(fetchLimitForDefinitionList)
        .get();

    return _toDefinitionIdListState(snapshot);
  }

  /// 「ホーム画面: フォロー中タブ」で表示するDefinitionIDのListを取得する（2回目以降）
  Future<DefinitionIdListState> fetchHomeFollowingDefinitionIdListMore(
    List<String> targetUserIdList,
    QueryDocumentSnapshot lastReadQueryDocumentSnapshot,
  ) async {
    final snapshot = await firestore
        .collection('Definitions')
        .where('authorId', whereIn: targetUserIdList)
        .where('isPublic', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .startAfterDocument(lastReadQueryDocumentSnapshot)
        .limit(fetchLimitForDefinitionList)
        .get();

    return _toDefinitionIdListState(snapshot);
  }

  /// DocumentSnapshotからDefinitionIdListStateを生成する
  DefinitionIdListState _toDefinitionIdListState(
    QuerySnapshot snapshot,
  ) {
    final idList = snapshot.docs.map((doc) => doc.id).toList();

    return DefinitionIdListState(
      definitionIdList: idList,
      lastReadQueryDocumentSnapshot: snapshot.docs.lastOrNull,
      hasMore: idList.length == fetchLimitForDefinitionList,
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
    DefinitionForWrite definitionForWrite,
  ) async {
    // Wordドキュメントが存在しない場合は新規作成する
    if (definitionForWrite.wordId == null) {
      await firestore.runTransaction((transaction) async {
        // Wordドキュメントを新規作成し、
        // 作成したドキュメントのidをもとにDefinitionドキュメントを作成する
        final wordId = await _createWord(
          definitionForWrite.word,
          definitionForWrite.wordReading,
        );
        final finallyDefinitionForWrite =
            definitionForWrite.copyWith(wordId: wordId);
        await _createDefinition(finallyDefinitionForWrite);
      });
      return;
    }

    // Wordドキュメントが存在する場合はDefinitionドキュメントのみ作成する
    await _createDefinition(definitionForWrite);
  }

  Future<void> _createDefinition(DefinitionForWrite definitionForWrite) async {
    await firestore.collection('Definitions').add({
      ...definitionForWrite.toFirestore(),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // [createDefinition]とバッチ実行する必要があるため、このクラスに作成している
  /// Wordドキュメントを作成し、作成したドキュメントのidを返す
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
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      // Likesコレクションにドキュメントを登録
      final likesCollection = FirebaseFirestore.instance.collection('Likes');
      transaction.set(likesCollection.doc(), {
        'definitionId': definitionId,
        'userId': userId,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // DefinitionコレクションからドキュメントのlikesCountを+1する
      final definitionDocRef = FirebaseFirestore.instance
          .collection('Definitions')
          .doc(definitionId);
      transaction.update(definitionDocRef, {
        'likesCount': FieldValue.increment(1),
      });
    });
  }

  Future<void> unlikeDefinition(String definitionId, String userId) async {
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      // Likesコレクションからドキュメントを取得して削除
      final likeSnapshot = await FirebaseFirestore.instance
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
      final definitionDocRef = FirebaseFirestore.instance
          .collection('Definitions')
          .doc(definitionId);
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
