import 'package:teigi_app/feature/definition/domain/definition.dart';
import 'package:teigi_app/feature/user_list/domain/user_id_list_state.dart';
import 'package:teigi_app/feature/user_profile/domain/user_profile.dart';

final nowDateTime = DateTime.now();

/// テスト用のモックデータ
///
/// 他のモックデータとの整合性は取ってない
final mockDefinition = Definition(
  id: 'definitionId',
  wordId: 'wordId',
  word: 'word',
  wordReading: 'wordReading',
  authorId: 'authorId',
  authorName: 'authorName',
  authorImageUrl: 'authorImageUrl',
  definition: 'definition',
  isPublic: true,
  likesCount: 0,
  isLikedByUser: false,
  createdAt: nowDateTime,
);

const mockUserProfile = UserProfile(
  id: 'userId',
  publicId: '123456789',
  name: 'name',
  bio: 'I am a perfect human',
  avatarUrl: 'https://api.example.com/v1/avatars/userId',
  followingCount: 2,
  followerCount: 1,
  isFollowedByMe: false,
  croppedFile: null,
);

const mockMutedUserIdList = ['mutedUserId'];

final mockUserIdListState = UserIdListState(
  list: ['userId1', 'userId2'],
  nextCursor: null,
  hasMore: false,
);
