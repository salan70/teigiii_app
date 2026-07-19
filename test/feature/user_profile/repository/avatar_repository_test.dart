import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:teigi_app/feature/user_profile/repository/avatar_repository.dart';

import 'avatar_repository_test.mocks.dart';

@GenerateNiceMocks([MockSpec<Dio>(), MockSpec<CacheManager>()])
void main() {
  // evictFromCache が ImageCache（PaintingBinding）へアクセスするため初期化する。
  TestWidgetsFlutterBinding.ensureInitialized();

  final mockDio = MockDio();
  final mockCacheManager = MockCacheManager();
  final repository = AvatarRepository(mockDio, mockCacheManager);

  tearDown(() {
    reset(mockDio);
    reset(mockCacheManager);
  });

  group('uploadAvatar', () {
    test('JPEG bytes を PUT し、返却された avatarUrl のキャッシュを破棄して返す', () async {
      // * Arrange
      final file = File(
        '${Directory.systemTemp.path}/avatar_repository_test.jpg',
      );
      const jpegBytes = [0xFF, 0xD8, 0xFF, 0xE0];
      await file.writeAsBytes(jpegBytes);
      addTearDown(file.deleteSync);

      const avatarUrl = 'https://api.example.com/v1/avatars/user1';
      when(
        mockDio.put<Map<String, dynamic>>(
          '/v1/users/me/avatar',
          data: anyNamed('data'),
          options: anyNamed('options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          data: {'avatarUrl': avatarUrl},
          statusCode: 200,
          requestOptions: RequestOptions(path: '/v1/users/me/avatar'),
        ),
      );

      // * Act
      final result = await repository.uploadAvatar(file);

      // * Assert
      expect(result, avatarUrl);
      // アップロード後に（ディスク側の）古いキャッシュが破棄されること
      verify(mockCacheManager.removeFile(avatarUrl)).called(1);
      // 送信されたバイト列・Content-Type・Content-Length を検証する
      final captured =
          verify(
            mockDio.put<Map<String, dynamic>>(
              '/v1/users/me/avatar',
              data: captureAnyNamed('data'),
              options: captureAnyNamed('options'),
            ),
          ).captured;
      final data = captured[0] as Stream<List<int>>;
      final options = captured[1] as Options;

      expect(await data.expand((chunk) => chunk).toList(), jpegBytes);
      expect(options.contentType, 'image/jpeg');
      expect(options.headers?[Headers.contentLengthHeader], jpegBytes.length);
    });
  });
}
