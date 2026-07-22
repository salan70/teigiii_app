import 'package:dio/dio.dart';

class ApiException implements Exception {
  ApiException({this.statusCode, this.code, this.message, this.body});

  factory ApiException.fromDioException(DioException exception) {
    final response = exception.response;

    String? code;
    String? message;
    Map<String, dynamic>? body;
    final data = response?.data;
    if (data is Map) {
      body = Map<String, dynamic>.from(data);
      final error = body['error'];
      if (error is Map) {
        final errorMap = Map<String, dynamic>.from(error);
        code = errorMap['code'] as String?;
        message = errorMap['message'] as String?;
      }
    }

    // デシリアライズ失敗など、HTTP エラーボディ以外の原因をメッセージに残す。
    message ??= exception.error?.toString() ?? exception.message;

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
