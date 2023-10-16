import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../util/firebase_provider.dart';
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
  Future<List<String>> fetchHomeRecommendDefinitionIdList(
    List<String> mutedUserIdList,
  ) async {
    final snapshot = await firestore
        .collection('Definitions')
        .where('authorId', whereNotIn: mutedUserIdList)
        .orderBy('authorId')
        .where('isPublic', isEqualTo: true)
        .orderBy('updatedAt', descending: true)
        .get();

    return snapshot.docs.map((doc) => doc.id).toList();
  }

  /// 「ホーム画面: フォロー中タブ」で表示するDefinitionIDのListを取得する
  Future<List<String>> fetchHomeFollowingDefinitionList(
    List<String> targetUserIdList,
  ) async {
    final snapshot = await firestore
        .collection('Definitions')
        .where('authorId', whereIn: targetUserIdList)
        .where('isPublic', isEqualTo: true)
        .orderBy('updatedAt', descending: true)
        .get();

    return snapshot.docs.map((doc) => doc.id).toList();
  }

  Future<DefinitionDocument> fetchDefinition(String definitionId) async {
    final snapshot = await firestore
        .collection('Definitions')
        .doc(definitionId)
        .get()
        .then((snapshot) => snapshot);

    return DefinitionDocument.fromFirestore(snapshot);
  }

  Future<void> likeDefinition(String definitionId, String userId) async {
    final now = DateTime.now();

    // transactionを使い、複数の処理が全て成功した場合のみ、処理を完了させる
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      // Likesコレクションにドキュメントを登録
      final likesCollection = FirebaseFirestore.instance.collection('Likes');
      transaction.set(likesCollection.doc(), {
        'definitionId': definitionId,
        'userId': userId,
        'createdAt': now,
        'updatedAt': now,
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

extension on List<DocumentSnapshot> {
  DocumentSnapshot? get firstOrNull => isEmpty ? null : first;
}
