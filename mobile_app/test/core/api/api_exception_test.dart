import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teigi_app/core/api/api_exception.dart';
import 'package:teigiii_api/teigiii_api.dart';

DioException dioException({Response<dynamic>? response}) {
  final options = RequestOptions(path: '/v1/words');
  return DioException(
    requestOptions: options,
    response: response,
    type: response != null
        ? DioExceptionType.badResponse
        : DioExceptionType.connectionError,
  );
}

void main() {
  test('ErrorResponse ボディからステータス・コード・メッセージを取り出す', () {
    final exception = ApiException.fromDioException(
      dioException(
        response: Response(
          requestOptions: RequestOptions(path: '/v1/words'),
          statusCode: 404,
          data: {
            'error': {'code': 'not_found', 'message': '言葉が見つかりません'},
          },
        ),
      ),
    );

    expect(exception.statusCode, 404);
    expect(exception.code, 'not_found');
    expect(exception.message, '言葉が見つかりません');
  });

  test('ボディが ErrorResponse 形式でない場合はステータスのみ保持する', () {
    final exception = ApiException.fromDioException(
      dioException(
        response: Response(
          requestOptions: RequestOptions(path: '/v1/words'),
          statusCode: 500,
          data: 'Internal Server Error',
        ),
      ),
    );

    expect(exception.statusCode, 500);
    expect(exception.code, isNull);
    expect(exception.message, isNull);
  });

  test('409 の WordConflictResponse ボディを body から復元できる', () {
    final exception = ApiException.fromDioException(
      dioException(
        response: Response(
          requestOptions: RequestOptions(path: '/v1/words'),
          statusCode: 409,
          data: {
            'error': {'code': 'conflict', 'message': '登録済みの言葉です'},
            'existingWord': {'id': 'word-1', 'word': '定義', 'reading': 'ていぎ'},
          },
        ),
      ),
    );

    expect(exception.statusCode, 409);
    expect(exception.code, 'conflict');
    final conflict = WordConflictResponse.fromJson(exception.body!);
    expect(conflict.existingWord.id, 'word-1');
  });

  test('レスポンスがない接続エラーはステータスなしで保持する', () {
    final exception = ApiException.fromDioException(dioException());

    expect(exception.statusCode, isNull);
    expect(exception.code, isNull);
  });

  test('Map<dynamic, dynamic> でも ErrorResponse を取り出せる', () {
    final exception = ApiException.fromDioException(
      dioException(
        response: Response(
          requestOptions: RequestOptions(path: '/v1/me/defined-words'),
          statusCode: 401,
          data: <dynamic, dynamic>{
            'error': <dynamic, dynamic>{
              'code': 'app_check_invalid',
              'message': 'invalid',
            },
          },
        ),
      ),
    );

    expect(exception.statusCode, 401);
    expect(exception.code, 'app_check_invalid');
    expect(exception.message, 'invalid');
  });

  test('HTTP 200 のデシリアライズ失敗は underlying error を message に残す', () {
    final options = RequestOptions(path: '/v1/me/defined-words');
    final exception = ApiException.fromDioException(
      DioException(
        requestOptions: options,
        response: Response(
          requestOptions: options,
          statusCode: 200,
          data: {'items': <Object>[]},
        ),
        error: const FormatException('CheckedFromJsonException: draftCount'),
      ),
    );

    expect(exception.statusCode, 200);
    expect(exception.code, isNull);
    expect(exception.message, contains('CheckedFromJsonException'));
  });
}
