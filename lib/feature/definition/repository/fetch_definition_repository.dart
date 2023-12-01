import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/common_provider/firebase_providers.dart';
import '../../../util/constant/firestore_collections.dart';
import 'entity/definition_document.dart';

part 'fetch_definition_repository.g.dart';

@Riverpod(keepAlive: true)
FetchDefinitionRepository fetchDefinitionRepository(
  FetchDefinitionRepositoryRef ref,
) =>
    FetchDefinitionRepository(
      ref.watch(firestoreProvider),
    );

/// 定義の取得に関する処理を記述するRepository
class FetchDefinitionRepository {
  FetchDefinitionRepository(this.firestore);

  final FirebaseFirestore firestore;

  CollectionReference get _definitionsCollectionRef =>
      firestore.collection(DefinitionsCollection.collectionName);

  Future<DefinitionDocument> fetchDefinition(String definitionId) async {
    final snapshot = await _definitionsCollectionRef
        .doc(definitionId)
        .get()
        .then((snapshot) => snapshot);

    return DefinitionDocument.fromFirestore(snapshot);
  }

  /// [userId] が投稿した全てのDefinitionDocリストを取得する
  ///
  /// 取得数にlimitを設定していないため、大量のデータを取得する可能性があることに注意。
  Future<List<DefinitionDocument>> fetchAllPostedDefinitionDocList(
    String userId,
  ) async {
    final snapshot = await _definitionsCollectionRef
        .where(DefinitionsCollection.authorId, isEqualTo: userId)
        .get();

    return snapshot.docs.map(DefinitionDocument.fromFirestore).toList();
  }
}
