import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:teigiii_api/teigiii_api.dart';

import '../../../core/api/api_exception.dart';
import '../../../core/api/api_providers.dart';
import '../../../util/logger.dart';

part 'user_config_repository.g.dart';

@riverpod
UserConfigRepository userConfigRepository(UserConfigRepositoryRef ref) =>
    UserConfigRepository(
      ref.watch(teigiiiApiProvider).getMeApi(),
      ref.watch(teigiiiApiProvider).getUsersApi(),
    );

class UserConfigRepository {
  UserConfigRepository(this._meApi, this._usersApi);

  final MeApi _meApi;
  final UsersApi _usersApi;

  /// ログイン中のユーザーがミュートしているユーザーのIDリストを全て取得する。
  Future<List<String>> fetchMutedUserIdList() async {
    logger.i('ミュート中のユーザーIDリストを取得します。');
    try {
      final idList = <String>[];
      String? cursor;
      do {
        final response = await _meApi.v1MeMutesGet(cursor: cursor, limit: 50);
        final page = response.data!;
        idList.addAll(page.items.map((item) => item.id));
        cursor = page.nextCursor;
      } while (cursor != null);
      return idList;
    } on DioException catch (exception) {
      throw ApiException.fromDioException(exception);
    }
  }

  /// [mutedUserId] をミュートする。
  Future<void> appendMutedUserIdList(String mutedUserId) async {
    try {
      await _usersApi.v1UsersIdMutePut(id: mutedUserId);
    } on DioException catch (exception) {
      throw ApiException.fromDioException(exception);
    }
  }

  /// [mutedUserId] のミュートを解除する。
  Future<void> removeMutedUserIdList(String mutedUserId) async {
    try {
      await _usersApi.v1UsersIdMuteDelete(id: mutedUserId);
    } on DioException catch (exception) {
      throw ApiException.fromDioException(exception);
    }
  }
}
