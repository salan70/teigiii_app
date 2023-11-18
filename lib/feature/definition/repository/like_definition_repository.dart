import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/common_provider/firebase_providers.dart';
import '../../../util/constant/firestore_collections.dart';
import '../../../util/extension/firestore_extension.dart';

part 'like_definition_repository.g.dart';

// TODO(me): transactionで実行している処理をbatchに変更できないか（したほうがいいか）検討する

@Riverpod(keepAlive: true)
LikeDefinitionRepository likeDefinitionRepository(
  LikeDefinitionRepositoryRef ref,
) =>
    LikeDefinitionRepository(ref.watch(firestoreProvider));

/// 定義の書き込み（新規作成、更新、削除）に関する処理を記述するRepository
class LikeDefinitionRepository {
  LikeDefinitionRepository(this.firestore);

  final FirebaseFirestore firestore;

  CollectionReference get _definitionsCollectionRef =>
      firestore.collection(DefinitionsCollection.collectionName);

  CollectionReference get _likesCollectionRef =>
      firestore.collection(LikesCollection.collectionName);

  Future<void> likeDefinition(String definitionId, String userId) async {
    // TODO(me): transactionよりbatchのほうが良さそう
    // transactionを使い、複数の処理が全て成功した場合のみ、処理を完了させる
    await firestore.runTransaction((transaction) async {
      // Likesコレクションにドキュメントを登録
      final likesCollection = _likesCollectionRef;
      transaction.set(likesCollection.doc(), {
        LikesCollection.definitionId: definitionId,
        LikesCollection.userId: userId,
        createdAtFieldName: FieldValue.serverTimestamp(),
        updatedAtFieldName: FieldValue.serverTimestamp(),
      });

      // DefinitionコレクションからドキュメントのlikesCountを+1する
      final definitionDocRef = _definitionsCollectionRef.doc(definitionId);
      transaction.update(definitionDocRef, {
        DefinitionsCollection.likesCount: FieldValue.increment(1),
      });
    });
  }

  Future<void> unlikeDefinition(String definitionId, String userId) async {
    // TODO(me): transactionよりbatchのほうが良さそう
    await firestore.runTransaction((transaction) async {
      // Likesコレクションからドキュメントを取得して削除
      final likeSnapshot = await _likesCollectionRef
          .where(LikesCollection.definitionId, isEqualTo: definitionId)
          .where(LikesCollection.userId, isEqualTo: userId)
          .get()
          .then((snapshot) => snapshot.docs.firstOrNull);

      if (likeSnapshot == null) {
        throw Exception('いいね解除が失敗しました。');
      }

      transaction.delete(likeSnapshot.reference);

      // DefinitionコレクションからドキュメントのlikesCountを-1する
      final definitionDocRef = _definitionsCollectionRef.doc(definitionId);
      transaction.update(definitionDocRef, {
        DefinitionsCollection.likesCount: FieldValue.increment(-1),
      });
    });
  }

  Future<bool> isLikedByUser(String userId, String definitionId) async {
    final likeSnapshot = await _likesCollectionRef
        .where(LikesCollection.definitionId, isEqualTo: definitionId)
        .where(LikesCollection.userId, isEqualTo: userId)
        .get()
        .then((snapshot) => snapshot.docs.firstOrNull);

    return likeSnapshot != null;
  }
}
