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
}
