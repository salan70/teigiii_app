import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image_picker/image_picker.dart';
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
  /// アバターの URL はユーザーごとに固定で、差し替えても
  /// `CachedNetworkImageProvider` のキーは変わらない。ディスクキャッシュだけ
  /// 消しても `ImageCache` に残ったデコード済み画像が返り続けるため、
  /// アップロード成功後にディスク・メモリ両方のキャッシュを破棄する。
  ///
  /// 生成クライアントの `v1UsersMeAvatarPut` はバイナリボディを
  /// JSON エンコードしてしまうため、このエンドポイントのみ dio で直接送信する。
  Future<String> uploadAvatar(XFile file) async {
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
      // ディスク（CacheManager）とメモリ（ImageCache）の両方を破棄する。
      await CachedNetworkImage.evictFromCache(
        avatarUrl,
        cacheManager: _cacheManager,
      );
      return avatarUrl;
    } on DioException catch (exception) {
      throw ApiException.fromDioException(exception);
    }
  }
}
