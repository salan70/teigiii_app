import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:teigiii_api/teigiii_api.dart';

import '../../../core/api/api_exception.dart';
import '../../../core/api/api_providers.dart';

part 'register_user_repository.g.dart';

@riverpod
RegisterUserRepository registerUserRepository(RegisterUserRepositoryRef ref) =>
    RegisterUserRepository(ref.watch(teigiiiApiProvider).getUsersApi());

class RegisterUserRepository {
  RegisterUserRepository(this._usersApi);

  final UsersApi _usersApi;

  /// 初回登録時に必要なユーザー情報を登録する
  ///
  /// publicId の採番・重複確認はサーバー側で行われる
  Future<void> initUser({
    required String name,
    required String osVersion,
    required String appVersion,
  }) async {
    try {
      await _usersApi.v1UsersPost(
        createUserRequest: CreateUserRequest(
          name: name,
          osVersion: osVersion,
          appVersion: appVersion,
        ),
      );
    } on DioException catch (exception) {
      throw ApiException.fromDioException(exception);
    }
  }

  /// ユーザーが使用しているos, appのバージョン情報を更新する
  Future<void> updateVersionInfo({
    required String osVersion,
    required String appVersion,
  }) async {
    try {
      await _usersApi.v1UsersMePatch(
        updateMeRequest: UpdateMeRequest(
          osVersion: osVersion,
          appVersion: appVersion,
        ),
      );
    } on DioException catch (exception) {
      throw ApiException.fromDioException(exception);
    }
  }

  /// アカウントを削除する（サーバー側で論理削除・30 日保持）
  Future<void> deleteUser() async {
    try {
      await _usersApi.v1UsersMeDelete();
    } on DioException catch (exception) {
      throw ApiException.fromDioException(exception);
    }
  }
}
