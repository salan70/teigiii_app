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

/// 定義のいいねに関する処理を記述するRepository
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

  /// [userId]がいいねしたdefinitionIdのリストを取得する
  Future<List<String>> fetchAllLikedDefinitionIdList(String userId) async {
    final likeSnapshots = await _likesCollectionRef
        .where(LikesCollection.userId, isEqualTo: userId)
        .get()
        .then((snapshot) => snapshot.docs);

    return likeSnapshots.map((snapshot) {
      final data = snapshot.data()! as Map<String, dynamic>;
      return data[LikesCollection.definitionId] as String;
    }).toList();
  }

  /// [definitionId]に紐づくいいねを全て削除する
  Future<void> deleteLikeByDefinitionId(String definitionId) async {
    // Likesコレクションからドキュメントを取得して削除
    final likeSnapshots = await _likesCollectionRef
        .where(LikesCollection.definitionId, isEqualTo: definitionId)
        .get()
        .then((snapshot) => snapshot.docs);

    for (final likeSnapshot in likeSnapshots) {
      await likeSnapshot.reference.delete();
    }
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
