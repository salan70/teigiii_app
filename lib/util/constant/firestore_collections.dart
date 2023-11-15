// Firestoreのコレクションに対応するclassを定義する
// createdAt, updatedAtは全コレクション共通のため、classには含めない

const updatedAtFieldName = 'updatedAt';
const createdAtFieldName = 'createdAt';

class WordsCollection {
  static const collectionName = 'Words';

  // Field
  static const word = 'word';
  static const reading = 'reading';
  static const initialSubGroupLabel = 'initialSubGroupLabel';
}

class DefinitionsCollection {
  static const collectionName = 'Definitions';

  // Field
  static const wordId = 'wordId';
  static const word = 'word';
  static const wordReading = 'wordReading';
  static const wordReadingInitialSubGroupLabel =
      'wordReadingInitialSubGroupLabel';
  static const authorId = 'authorId';
  static const definition = 'definition';
  static const likesCount = 'likesCount';
  static const isPublic = 'isPublic';
  static const isEdited = 'isEdited';
}

class LikesCollection {
  static const collectionName = 'Likes';

  // Field
  static const userId = 'userId';
  static const definitionId = 'definitionId';
}

class UserProfilesCollection {
  static const collectionName = 'UserProfiles';

  // Field
  static const name = 'name';
  static const bio = 'bio';
  static const profileImageUrl = 'profileImageUrl';
  static const publicId = 'publicId';
}

class UserConfigsCollection {
  static const collectionName = 'UserConfigs';

  // Field
  static const mutedUserIdList = 'mutedUserIdList';
  static const osVersion = 'osVersion';
  static const appVersion = 'appVersion';
}

class UserFollowsCollection {
  static const collectionName = 'UserFollows';

  // Field
  static const followerId = 'followerId';
  static const followingId = 'followingId';
}

class UserFollowCountsCollection {
  static const collectionName = 'UserFollowCounts';

  // Field
  static const followerCount = 'followerCount';
  static const followingCount = 'followingCount';
}

class AppConfigCollection {
  static const collectionName = 'AppConfig';

  // Field
  static const minAppVersionForIos = 'minAppVersionForIos';
  static const minAppVersionForAndroid = 'minAppVersionForAndroid';
  static const maintenanceMap = 'maintenanceMap';

  // [maintenanceMap] のKey
  static const inMaintenance = 'inMaintenance';
  static const scheduledEndTime = 'scheduledEndTime';
}
