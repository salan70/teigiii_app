import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/common_provider/firebase_providers.dart';
import '../../../util/constant/firestore_collections.dart';
import '../../../util/extension/firestore_extension.dart';

part 'like_definition_repository.g.dart';

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
    final batch = firestore.batch()

      // Likesコレクションにドキュメントを登録
      ..set(_likesCollectionRef.doc(), {
        LikesCollection.definitionId: definitionId,
        LikesCollection.userId: userId,
        createdAtFieldName: FieldValue.serverTimestamp(),
        updatedAtFieldName: FieldValue.serverTimestamp(),
      })

      // DefinitionドキュメントのlikesCountを+1する
      ..update(_definitionsCollectionRef.doc(definitionId), {
        DefinitionsCollection.likesCount: FieldValue.increment(1),
      });

    await batch.commit();
  }

  Future<void> unlikeDefinition(String definitionId, String userId) async {
    // Likesコレクションからドキュメントを取得して削除
    final likeSnapshot = await _likesCollectionRef
        .where(LikesCollection.definitionId, isEqualTo: definitionId)
        .where(LikesCollection.userId, isEqualTo: userId)
        .get()
        .then((snapshot) => snapshot.docs.firstOrNull);

    // 念のためnullチェック
    if (likeSnapshot == null) {
      throw Exception('いいね解除が失敗しました。');
    }

    final batch = firestore.batch()
      ..delete(likeSnapshot.reference)

      // DefinitionドキュメントのlikesCountを-1する
      ..update(_definitionsCollectionRef.doc(definitionId), {
        DefinitionsCollection.likesCount: FieldValue.increment(-1),
      });

    await batch.commit();
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
