import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../util/firebase_provider.dart';
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

  Future<List<DefinitionDocument>> fetchPublicDefinitionListByUserId(
    List<String> userIdList,
  ) async {
    final QuerySnapshot definitionSnapshot = await firestore
        .collection('Definitions')
        .where('authorID', whereIn: userIdList)
        .where('isPublic', isEqualTo: true)
        .orderBy('updatedAt', descending: true)
        .get();

    return definitionSnapshot.docs
        .map(DefinitionDocument.fromFirestore)
        .toList();
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

  // Future<List<DefinitionDocument>> getDefinitionsForUser(
  //   String userId,
  //   List<String> userIdList,
  // ); async {
  // Fetch the list of users that the current user is following
  // final QuerySnapshot followSnapshot = await firestore
  //     .collection('UserFollows')
  //     .where('follower', isEqualTo: userID)
  //     .get();
  // final followingUserIDs =
  //     followSnapshot.docs.map((doc) => doc['following'] as String).toList();

  // final QuerySnapshot definitionSnapshot = await firestore
  //     .collection('Definitions')
  //     .where('authorID', whereIn: userIdList)
  //     .where('isPublic', isEqualTo: true)
  //     .orderBy('updatedAt', descending: true)
  //     .get();

  // return definitionSnapshot.docs
  //     .map(DefinitionDocument.fromFirestore)
  //     .toList();

  // Convert the snapshot to a list of WordDefinition entities
  // final definitions = <WordDefinition>[];
  // for (final doc in definitionSnapshot.docs) {
  // Fetch additional details for each definition (word details and author details)
  // final DocumentSnapshot wordSnapshot = await firestore
  //     .collection('Words')
  //     .doc(doc['wordId'] as String)
  //     .get();
  // final DocumentSnapshot authorSnapshot = await firestore
  //     .collection('Users')
  //     .doc(doc['authorId'] as String)
  //     .get();

  // Future<bool> isLikedByUser(String userId, String definitionId)
  // final likeSnapshot = await firestore
  //     .collection('Likes')
  //     .where('definitionId', isEqualTo: doc.id)
  //     .where('userId', isEqualTo: userId)
  //     .get()
  //     .then((snapshot) => snapshot.docs.firstOrNull);

  // final isLikedByUser = likeSnapshot != null;

  // definitions.add(
  //   WordDefinition(
  //     wordID: wordSnapshot.id,
  //     definitionID: doc.id,
  //     authorID: authorSnapshot.id,
  //     word: wordSnapshot['word'] as String,
  //     definition: doc['meaning'] as String,
  //     updatedAt: (doc['updatedAt'] as Timestamp).toDate(),
  //     authorName: authorSnapshot['username'] as String,
  //     authorIconUrl: authorSnapshot['profilePicture'] as String,
  //     likesCount: doc['likesCount'] as int,
  //     isLikedByUser: isLikedByUser,
  //   ),
  // );
  // }

  // return definitions;
  // }
}

// TODO(me): 適切なファイルに移動させる
// Helper extension to get the first document or null from a query snapshot
extension on List<DocumentSnapshot> {
  DocumentSnapshot? get firstOrNull => isEmpty ? null : first;
}
