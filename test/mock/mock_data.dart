import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mockito/mockito.dart';
import 'package:teigi_app/feature/auth/repository/entity/user_config_document.dart';
import 'package:teigi_app/feature/definition/domain/definition.dart';
import 'package:teigi_app/feature/definition/repository/entity/definition_document.dart';
import 'package:teigi_app/feature/user/repository/entity/user_profile_document.dart';
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

final mockUserConfigDoc = UserConfigDocument(
  id: 'userId',
  appVersion: '1.0.0',
  deviceOs: 'iOS 14.0.0',
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

// ignore: subtype_of_sealed_class
class MockQueryDocumentSnapshot extends Mock implements QueryDocumentSnapshot {}

final mockQueryDocumentSnapshot = MockQueryDocumentSnapshot();
