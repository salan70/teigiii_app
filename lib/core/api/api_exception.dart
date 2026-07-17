import 'package:dio/dio.dart';

class ApiException implements Exception {
  ApiException({this.statusCode, this.code, this.message});

  factory ApiException.fromDioException(DioException exception) {
    final response = exception.response;

    String? code;
    String? message;
    final data = response?.data;
    if (data is Map<String, dynamic>) {
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
    );
  }

  final int? statusCode;
  final String? code;
  final String? message;

  @override
  String toString() =>
      'ApiException(statusCode: $statusCode, code: $code, message: $message)';
}
