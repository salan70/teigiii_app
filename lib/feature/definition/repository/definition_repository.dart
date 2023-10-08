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
