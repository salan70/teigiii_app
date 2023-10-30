import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mockito/mockito.dart';
import 'package:teigi_app/feature/definition/domain/definition.dart';
import 'package:teigi_app/feature/definition/repository/entity/definition_document.dart';
import 'package:teigi_app/feature/user_config/repository/entity/user_config_document.dart';
import 'package:teigi_app/feature/user_profile/domain/user_id_list_state.dart';
import 'package:teigi_app/feature/user_profile/repository/entity/user_follow_count_document.dart';
import 'package:teigi_app/feature/user_profile/repository/entity/user_profile_document.dart';
import 'package:teigi_app/feature/word/repository/entity/word_document.dart';

final nowDateTime = DateTime.now();

/// テスト用のモックデータ
///
/// 他のモックデータとの整合性は取ってない
final mockDefinition = Definition(
  id: 'definitionId',
  wordId: 'wordId',
  authorId: 'authorId',
  word: 'word',
  definition: 'definition',
  createdAt: nowDateTime,
  updatedAt: nowDateTime,
  authorName: 'authorName',
  authorImageUrl: 'authorImageUrl',
  likesCount: 0,
  isLikedByUser: false,
);

final mockDefinitionDoc = DefinitionDocument(
  id: 'definitionId',
  wordId: mockWordDoc.id,
  authorId: mockUserProfileDoc.id,
  content: 'content',
  likesCount: 0,
  isPublic: true,
  createdAt: nowDateTime,
  updatedAt: nowDateTime,
);

final mockUserProfileDoc = UserProfileDocument(
  id: 'userId',
  name: 'name',
  bio: 'I am a perfect human',
  profileImageUrl: 'profileImageUrl',
  createdAt: nowDateTime,
  updatedAt: nowDateTime,
);

final mockUserFollowCountDoc = UserFollowCountDocument(
  id: mockUserProfileDoc.id,
  followerCount: 1,
  followingCount: 2,
  createdAt: nowDateTime,
  updatedAt: nowDateTime,
);

final mockUserConfigDoc = UserConfigDocument(
  id: 'userId',
  appVersion: '1.0.0',
  osVersion: 'iOS 14.0.0',
  mutedUserIdList: ['mutedUserId'],
  createdAt: nowDateTime,
  updatedAt: nowDateTime,
);

final mockWordDoc = WordDocument(
  id: 'wordId',
  word: 'word',
  reading: 'reading',
  initialLetter: 'i',
  createdAt: nowDateTime,
  updatedAt: nowDateTime,
);

final mockUserIdListState = UserIdListState(
  userIdList: ['userId1', 'userId2'],
  lastReadQueryDocumentSnapshot: mockQueryDocumentSnapshot,
  hasMore: false,
);

// ignore: subtype_of_sealed_class
class MockQueryDocumentSnapshot extends Mock implements QueryDocumentSnapshot {}

final mockQueryDocumentSnapshot = MockQueryDocumentSnapshot();
