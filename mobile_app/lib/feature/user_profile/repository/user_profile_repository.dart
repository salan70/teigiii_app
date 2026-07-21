import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:teigiii_api/teigiii_api.dart';

import '../../../core/api/api_exception.dart';
import '../../../core/api/api_providers.dart';
import '../../../util/exception/database_exception.dart';
import '../domain/user_profile.dart';

part 'user_profile_repository.g.dart';

@riverpod
UserProfileRepository userProfileRepository(UserProfileRepositoryRef ref) =>
    UserProfileRepository(ref.watch(teigiiiApiProvider).getUsersApi());

class UserProfileRepository {
  UserProfileRepository(this._usersApi);

  final UsersApi _usersApi;

  Future<UserProfile> fetchUserProfile(String userId) async {
    try {
      final response = await _usersApi.v1UsersIdGet(id: userId);
      final user = response.data!;
      return UserProfile(
        id: user.id,
        publicId: user.publicId,
        name: user.name,
        bio: user.bio,
        publicDefinitionCount: user.publicDefinitionCount,
        avatarUrl: user.avatarUrl,
        followingCount: user.followingCount,
        followerCount: user.followerCount,
        isFollowedByMe: user.isFollowedByMe,
        croppedFile: null,
      );
    } on DioException catch (exception) {
      // 削除済みユーザーの表示は 404 由来の notFound 判定に依存しているため、
      // ここで DatabaseException へ変換して既存 UI の挙動を維持する。
      if (exception.response?.statusCode == 404) {
        throw const DatabaseException(DatabaseExceptionCode.notFound);
      }
      throw ApiException.fromDioException(exception);
    }
  }

  Future<void> updateUserProfile(UserProfile userProfileForWrite) async {
    try {
      await _usersApi.v1UsersMePatch(
        updateMeRequest: UpdateMeRequest(
          name: userProfileForWrite.name,
          bio: userProfileForWrite.bio,
        ),
      );
    } on DioException catch (exception) {
      throw ApiException.fromDioException(exception);
    }
  }
}
