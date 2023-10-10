import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../util/firebase_provider.dart';
import '../util/definition_feed_type.dart';
import 'entity/definition_document.dart';

part 'definition_repository.g.dart';

@riverpod
DefinitionRepository definitionRepository(DefinitionRepositoryRef ref) =>
    DefinitionRepository(
      ref.watch(firestoreProvider),
    );

class DefinitionRepository {
  DefinitionRepository(this.firestore);

  final FirebaseFirestore firestore;

  Future<List<DefinitionDocument>> fetchHomeRecommendDefinitionList(
    DefinitionFeedType feedType,
    List<String> mutedUserIdList,
  ) async {
    final snapshot = await firestore
        .collection('Definitions')
        .where('authorId', whereNotIn: mutedUserIdList)
        .orderBy('authorId')
        .where('isPublic', isEqualTo: true)
        .orderBy('updatedAt', descending: true)
        .get();

    return snapshot.docs.map(DefinitionDocument.fromFirestore).toList();
  }

  Future<List<DefinitionDocument>> fetchHomeFollowingDefinitionList(
    DefinitionFeedType feedType,
    List<String> userIdList,
  ) async {
    final snapshot = await firestore
        .collection('Definitions')
        .where('authorId', whereIn: userIdList)
        .where('isPublic', isEqualTo: true)
        .orderBy('updatedAt', descending: true)
        .get();

    return snapshot.docs.map(DefinitionDocument.fromFirestore).toList();
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
        throw Exception('対象のいいねが見つかりませんでした。');
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
