import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/api_exception.dart';
import '../../../core/api/api_providers.dart';

part 'avatar_repository.g.dart';

@riverpod
AvatarRepository avatarRepository(AvatarRepositoryRef ref) => AvatarRepository(
  ref.watch(apiDioProvider),
  ref.watch(avatarCacheManagerProvider),
);

class AvatarRepository {
  AvatarRepository(this._dio, this._cacheManager);

  final Dio _dio;
  final CacheManager _cacheManager;

  /// 512 x 512 JPEG に正規化済みのアバター画像をアップロードし、
  /// アバター画像の URL を返す。
  ///
  /// アバターの URL はユーザーごとに固定のため、アップロード成功後に
  /// 古い画像のキャッシュを破棄する。
  ///
  /// 生成クライアントの `v1UsersMeAvatarPut` はバイナリボディを
  /// JSON エンコードしてしまうため、このエンドポイントのみ dio で直接送信する。
  Future<String> uploadAvatar(File file) async {
    try {
      final bytes = await file.readAsBytes();
      final response = await _dio.put<Map<String, dynamic>>(
        '/v1/users/me/avatar',
        data: Stream.fromIterable([bytes]),
        options: Options(
          contentType: 'image/jpeg',
          headers: {Headers.contentLengthHeader: bytes.length},
        ),
      );

      final avatarUrl = response.data!['avatarUrl'] as String;
      await _cacheManager.removeFile(avatarUrl);
      return avatarUrl;
    } on DioException catch (exception) {
      throw ApiException.fromDioException(exception);
    }
  }
}
