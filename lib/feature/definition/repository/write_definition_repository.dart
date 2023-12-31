import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/common_provider/firebase_providers.dart';
import '../../../util/constant/firestore_collections.dart';
import '../../../util/constant/initial_main_group.dart';
import '../../../util/logger.dart';
import '../domain/definition_for_write.dart';

part 'write_definition_repository.g.dart';

// TODO(me): 処理が長い関数多いのでなんとかしたい
// transaction実行している関係で難しいかも。。

// TODO(me): transactionで実行している処理をbatchに変更できないか（したほうがいいか）検討する

@riverpod
WriteDefinitionRepository writeDefinitionRepository(
  WriteDefinitionRepositoryRef ref,
) =>
    WriteDefinitionRepository(ref.watch(firestoreProvider));

/// 定義の書き込み（新規作成、更新、削除）に関する処理を記述するRepository
class WriteDefinitionRepository {
  WriteDefinitionRepository(this.firestore);

  final FirebaseFirestore firestore;

  CollectionReference get _definitionsCollectionRef =>
      firestore.collection(DefinitionsCollection.collectionName);

  CollectionReference get _wordsCollectionRef =>
      firestore.collection(WordsCollection.collectionName);

  CollectionReference get _wordDefinitionRelationsCollectionRef =>
      firestore.collection(WordDefinitionRelationsCollection.collectionName);

  /// Definitionドキュメントと
  /// WordDefinitionRelationドキュメントの作成をtransaction実行する。
  /// 
  /// 完了後、作成したDefinitionドキュメントのidを返す。
  ///
  /// Definition作成時、「紐づくWordドキュメントが既にある」場合に使用する
  Future<String> createDefinition(
    DefinitionForWrite definitionForWrite,
    String wordId,
  ) async {
    final batch = firestore.batch();

    // Definitionドキュメントを作成
    final definitionDocRef = _definitionsCollectionRef.doc();
    batch
      ..set(
        definitionDocRef,
        {
          ...definitionForWrite.toFirestoreForCreate(),
          DefinitionsCollection.wordId: wordId,
          createdAtFieldName: FieldValue.serverTimestamp(),
          updatedAtFieldName: FieldValue.serverTimestamp(),
        },
      )
      // 新しいwordIdに紐づくWordDefinitionRelationドキュメントを作成
      ..set(
        _wordDefinitionRelationsCollectionRef.doc(),
        {
          WordDefinitionRelationsCollection.wordId: wordId,
          WordDefinitionRelationsCollection.definitionId: definitionDocRef.id,
          createdAtFieldName: FieldValue.serverTimestamp(),
          updatedAtFieldName: FieldValue.serverTimestamp(),
        },
      );

    await batch.commit();
    return definitionDocRef.id;
  }

  /// Definitionドキュメントの作成とWordドキュメントの作成、
  /// WordDefinitionRelationドキュメントの作成をtransaction実行する。
  /// 
  /// 完了後、作成したDefinitionドキュメントのidを返す。
  ///
  /// Definition作成時、「wordIdに紐づくWordドキュメントがない」場合に使用する
  Future<String> createDefinitionAndWord(
    DefinitionForWrite definitionForWrite,
  ) async {
    final batch = firestore.batch();

    // Wordドキュメントを作成
    final wordDocRef = _wordsCollectionRef.doc();
    batch.set(
      wordDocRef,
      {
        WordsCollection.word: definitionForWrite.word,
        WordsCollection.reading: definitionForWrite.wordReading,
        WordsCollection.initialSubGroupLabel:
            InitialSubGroup.fromString(definitionForWrite.wordReading).label,
        createdAtFieldName: FieldValue.serverTimestamp(),
        updatedAtFieldName: FieldValue.serverTimestamp(),
      },
    );

    // Definitionドキュメントを作成
    final definitionDocRef = _definitionsCollectionRef.doc();
    batch
      ..set(
        definitionDocRef,
        {
          ...definitionForWrite.toFirestoreForCreate(),
          DefinitionsCollection.wordId: wordDocRef.id,
          createdAtFieldName: FieldValue.serverTimestamp(),
          updatedAtFieldName: FieldValue.serverTimestamp(),
        },
      )
      // 新しいwordIdに紐づくWordDefinitionRelationドキュメントを作成
      ..set(
        _wordDefinitionRelationsCollectionRef.doc(),
        {
          WordDefinitionRelationsCollection.wordId: wordDocRef.id,
          WordDefinitionRelationsCollection.definitionId: definitionDocRef.id,
          createdAtFieldName: FieldValue.serverTimestamp(),
          updatedAtFieldName: FieldValue.serverTimestamp(),
        },
      );

    await batch.commit();
    return definitionDocRef.id;
  }

  /// Definitionドキュメントの更新を行う
  ///
  /// Definition更新時、更新前後で紐づくwordIdに変更がない場合に使用する
  Future<void> updateDefinition(DefinitionForWrite definitionForWrite) async {
    await _definitionsCollectionRef.doc(definitionForWrite.id).update(
      {
        ...definitionForWrite.toFirestoreForUpdate(),
        updatedAtFieldName: FieldValue.serverTimestamp(),
      },
    );
  }

  /// Definitionドキュメントの更新と
  /// WordDefinitionRelationドキュメントの削除と作成をtransaction実行する。
  ///
  /// Definition更新時、「更新前後で紐づくwordIdに変更がある」かつ
  /// 「更新後のwordIdに紐づくWordドキュメントが既にある」場合に使用する
  Future<void> updateWordChangedDefinition(
    String previousWordId,
    String newWordId,
    DefinitionForWrite definitionForWrite,
  ) async {
    await firestore.runTransaction((transaction) async {
      // * Definition
      // 更新
      transaction.update(
        _definitionsCollectionRef.doc(definitionForWrite.id),
        {
          ...definitionForWrite.toFirestoreForUpdate(),
          DefinitionsCollection.wordId: newWordId,
          updatedAtFieldName: FieldValue.serverTimestamp(),
        },
      )
        // * WordDefinitionRelation
        // 既存のwordIdに紐づくドキュメントを削除
        ..delete(
          await _wordDefinitionRelationsCollectionRef
              .where(
                WordDefinitionRelationsCollection.wordId,
                isEqualTo: previousWordId,
              )
              .where(
                WordDefinitionRelationsCollection.definitionId,
                isEqualTo: definitionForWrite.id,
              )
              .limit(1)
              .get()
              .then((snapshot) => snapshot.docs.first.reference),
        )
        // 新しいwordIdに紐づくドキュメントを作成
        ..set(
          _wordDefinitionRelationsCollectionRef.doc(),
          {
            WordDefinitionRelationsCollection.wordId: newWordId,
            WordDefinitionRelationsCollection.definitionId:
                definitionForWrite.id,
            createdAtFieldName: FieldValue.serverTimestamp(),
            updatedAtFieldName: FieldValue.serverTimestamp(),
          },
        );

      // * Word
      // 必要であればWordドキュメントを削除する
      final needDeleteWord = await _needDeleteWord(previousWordId);
      if (needDeleteWord) {
        transaction.delete(_wordsCollectionRef.doc(previousWordId));
      }
    });
  }

  /// Definitionドキュメントの更新とWordドキュメントの作成、
  /// WordDefinitionRelationドキュメントの削除と作成をtransaction実行する。
  ///
  /// 「新たにWordの作成が必要なDefinition」の更新を行う場合に使用する。
  Future<void> updateDefinitionAndCreateWord(
    DefinitionForWrite definitionForWrite,
    String previousWordId,
  ) async {
    await firestore.runTransaction((transaction) async {
      // Wordドキュメントを新規作成し、
      // 作成したドキュメントのidをもとにDefinitionドキュメントを更新する
      final newWordRef = _wordsCollectionRef.doc();
      // Word
      transaction.set(
        newWordRef,
        {
          WordsCollection.word: definitionForWrite.word,
          WordsCollection.reading: definitionForWrite.wordReading,
          WordsCollection.initialSubGroupLabel:
              InitialSubGroup.fromString(definitionForWrite.wordReading).label,
          createdAtFieldName: FieldValue.serverTimestamp(),
          updatedAtFieldName: FieldValue.serverTimestamp(),
        },
      )
          // Definition
          .update(
        _definitionsCollectionRef.doc(definitionForWrite.id),
        {
          ...definitionForWrite.toFirestoreForUpdate(),
          DefinitionsCollection.wordId: newWordRef.id,
          updatedAtFieldName: FieldValue.serverTimestamp(),
        },
      )
          // WordDefinitionRelation
          // 更新後のwordIdに紐づくWordDefinitionRelationドキュメントを作成する
          .set(
        _wordDefinitionRelationsCollectionRef.doc(),
        {
          WordDefinitionRelationsCollection.wordId: newWordRef.id,
          WordDefinitionRelationsCollection.definitionId: definitionForWrite.id,
          createdAtFieldName: FieldValue.serverTimestamp(),
          updatedAtFieldName: FieldValue.serverTimestamp(),
        },
      );

      // 更新前のwordIdに紐づくWordDefinitionRelationドキュメントを削除する
      final snapshot = await _searchWordDefinitionRelationDoc(
        previousWordId,
        definitionForWrite.id!,
      );
      // 念のため、ドキュメントが存在しているかチェック
      if (snapshot.docs.isEmpty) {
        logger.i('WordDefinitionRelationドキュメントが見つからないという想定外の事態が発生しました。'
            'wordId: ${newWordRef.id}, definitionId: ${definitionForWrite.id}');
        return;
      }
      transaction.delete(snapshot.docs.first.reference);

      // 必要であればWordドキュメントを削除する
      final needDeleteWord = await _needDeleteWord(previousWordId);
      if (needDeleteWord) {
        transaction.delete(_wordsCollectionRef.doc(previousWordId));
      }
    });
  }

  Future<void> deleteDefinition(
    String definitionId,
    String wordId,
  ) async {
    await firestore.runTransaction((transaction) async {
      // Definitionドキュメントを削除
      transaction.delete(_definitionsCollectionRef.doc(definitionId));

      // WordDefinitionRelationドキュメントを削除
      final snapshot = await _searchWordDefinitionRelationDoc(
        wordId,
        definitionId,
      );
      // 念のため、ドキュメントが存在しているかチェック
      if (snapshot.docs.isEmpty) {
        logger.i('WordDefinitionRelationドキュメントが見つからないという想定外の事態が発生しました。'
            'wordId: $wordId, definitionId: $definitionId');
        return;
      }
      transaction.delete(snapshot.docs.first.reference);

      // 必要であればWordドキュメントを削除する
      final needDeleteWord = await _needDeleteWord(wordId);
      if (needDeleteWord) {
        transaction.delete(_wordsCollectionRef.doc(wordId));
      }
    });
  }

  /// [wordId]に紐づくWordドキュメントを削除する必要があるかどうかを返す
  Future<bool> _needDeleteWord(String wordId) async {
    // 本来、WordDefinitionRelationドキュメントの数が0かどうかで判定すべきだが、
    // transactionやbatch実行前のデータしか取れない？ぽいので2未満かどうかで判定する
    final snapshot = await _wordDefinitionRelationsCollectionRef
        .where(
          WordDefinitionRelationsCollection.wordId,
          isEqualTo: wordId,
        )
        .limit(2)
        .get();
    return snapshot.docs.length < 2;
  }

  /// [previousWordId], [definitionId] に一致する
  /// WordDefinitionRelationドキュメントを返す
  Future<QuerySnapshot<Object?>> _searchWordDefinitionRelationDoc(
    String previousWordId,
    String definitionId,
  ) async {
    return _wordDefinitionRelationsCollectionRef
        .where(
          WordDefinitionRelationsCollection.wordId,
          isEqualTo: previousWordId,
        )
        .where(
          WordDefinitionRelationsCollection.definitionId,
          isEqualTo: definitionId,
        )
        .limit(1)
        .get();
  }

  Future<void> updatePostType({
    required String definitionId,
    required bool isPublic,
  }) async {
    await _definitionsCollectionRef.doc(definitionId).update({
      DefinitionsCollection.isPublic: isPublic,
      updatedAtFieldName: FieldValue.serverTimestamp(),
    });
  }
}
