import 'package:dio/dio.dart';

class ApiException implements Exception {
  ApiException({this.statusCode, this.code, this.message, this.body});

  factory ApiException.fromDioException(DioException exception) {
    final response = exception.response;

    String? code;
    String? message;
    Map<String, dynamic>? body;
    final data = response?.data;
    if (data is Map<String, dynamic>) {
      body = data;
      final error = data['error'];
      if (error is Map<String, dynamic>) {
        code = error['code'] as String?;
        message = error['message'] as String?;
      }
    }

    return ApiException(
      statusCode: response?.statusCode,
      code: code,
      message: message,
      body: body,
    );
  }

  final int? statusCode;
  final String? code;
  final String? message;

  /// エラーレスポンスの生ボディ。409 の `WordConflictResponse` など、
  /// `error` 以外のフィールドを持つレスポンスの復元に使う。
  final Map<String, dynamic>? body;

  @override
  String toString() =>
      'ApiException(statusCode: $statusCode, code: $code, message: $message)';
}
