import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/common_provider/firebase_providers.dart';
import '../../../util/constant/firestore_collections.dart';
import '../../../util/constant/initial_main_group.dart';
import '../../../util/extension/firestore_extension.dart';
import '../domain/definition_for_write.dart';

part 'write_definition_repository.g.dart';

@Riverpod(keepAlive: true)
WriteDefinitionRepository writeDefinitionRepository(
  WriteDefinitionRepositoryRef ref,
) =>
    WriteDefinitionRepository(
      ref.watch(firestoreProvider),
    );

/// 定義の書き込み（新規作成、更新、削除）に関する処理を記述するRepository
class WriteDefinitionRepository {
  WriteDefinitionRepository(this.firestore);

  final FirebaseFirestore firestore;

  CollectionReference get _definitionsCollectionRef =>
      firestore.collection(DefinitionsCollection.collectionName);

  CollectionReference get _wordsCollectionRef =>
      firestore.collection(WordsCollection.collectionName);

  CollectionReference get _likesCollectionRef =>
      firestore.collection(LikesCollection.collectionName);

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
    await _definitionsCollectionRef.add({
      ...definitionForWrite.toFirestoreForCreate(),
      DefinitionsCollection.authorId: authorId,
      DefinitionsCollection.wordId: wordId,
      createdAtFieldName: FieldValue.serverTimestamp(),
      updatedAtFieldName: FieldValue.serverTimestamp(),
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
    await _definitionsCollectionRef.doc(definitionForWrite.id).update(
      {
        ...definitionForWrite.toFirestoreForUpdate(),
        DefinitionsCollection.wordId: wordId,
        updatedAtFieldName: FieldValue.serverTimestamp(),
      },
    );
  }

  // Definitionドキュメントの作成/更新処理とバッチ実行する必要があるため、このクラスに作成している。
  /// Wordドキュメントを作成し、作成したドキュメントのidを返す。
  Future<String> _createWord(String word, String wordReading) async {
    final docRef = await _wordsCollectionRef.add(
      {
        WordsCollection.word: word,
        WordsCollection.reading: wordReading,
        WordsCollection.initialSubGroupLabel:
            InitialSubGroup.labelFromString(wordReading),
        createdAtFieldName: FieldValue.serverTimestamp(),
        updatedAtFieldName: FieldValue.serverTimestamp(),
      },
    );

    return docRef.id;
  }

  Future<void> likeDefinition(String definitionId, String userId) async {
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
