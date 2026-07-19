import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:teigi_app/core/api/dio_file_service.dart';

import 'dio_file_service_test.mocks.dart';

@GenerateNiceMocks([MockSpec<Dio>()])
void main() {
  final mockDio = MockDio();
  final fileService = DioFileService(mockDio);

  tearDown(() => reset(mockDio));

  const url = 'https://api.example.com/v1/avatars/user1';

  Response<ResponseBody> buildResponse({Map<String, List<String>>? headers}) {
    return Response(
      data: ResponseBody.fromBytes([1, 2, 3], 200, headers: headers),
      statusCode: 200,
      requestOptions: RequestOptions(path: url),
    );
  }

  void setupMock(Response<ResponseBody> response) {
    when(
      mockDio.get<ResponseBody>(url, options: anyNamed('options')),
    ).thenAnswer((_) async => response);
  }

  group('get', () {
    test('レスポンスの bytes を content として返す', () async {
      // * Arrange
      setupMock(buildResponse());

      // * Act
      final response = await fileService.get(url);
      final bytes = await response.content
          .expand<int>((chunk) => chunk)
          .toList();

      // * Assert
      expect(bytes, [1, 2, 3]);
      expect(response.statusCode, 200);
    });

    test('Cache-Control の max-age を validTill に反映する', () async {
      // * Arrange
      setupMock(
        buildResponse(
          headers: {
            'cache-control': ['private, max-age=300'],
          },
        ),
      );

      // * Act
      final before = DateTime.now();
      final response = await fileService.get(url);
      final after = DateTime.now();

      // * Assert
      expect(
        response.validTill.isAfter(before.add(const Duration(seconds: 299))),
        isTrue,
      );
      expect(
        response.validTill.isBefore(after.add(const Duration(seconds: 301))),
        isTrue,
      );
    });

    test('max-age=0 は即時失効として validTill に反映する', () async {
      // * Arrange
      setupMock(
        buildResponse(
          headers: {
            'cache-control': ['max-age=0'],
          },
        ),
      );

      // * Act
      final response = await fileService.get(url);
      final after = DateTime.now();

      // * Assert
      // max-age=0 は 7 日デフォルトにフォールバックせず、受信時刻付近で失効する
      expect(
        response.validTill.isBefore(after.add(const Duration(seconds: 1))),
        isTrue,
      );
    });

    test('認証ヘッダーと stream responseType を Dio に渡す', () async {
      // * Arrange
      setupMock(buildResponse());
      const headers = {'Authorization': 'Bearer token'};

      // * Act
      await fileService.get(url, headers: headers);

      // * Assert
      final options =
          verify(
                mockDio.get<ResponseBody>(
                  url,
                  options: captureAnyNamed('options'),
                ),
              ).captured.single
              as Options;
      expect(options.headers, headers);
      expect(options.responseType, ResponseType.stream);
    });

    test('content-type から拡張子を導出する', () async {
      // * Arrange
      setupMock(
        buildResponse(
          headers: {
            'content-type': ['image/jpeg'],
          },
        ),
      );

      // * Act
      final response = await fileService.get(url);

      // * Assert
      expect(response.fileExtension, '.jpg');
    });
  });
}
