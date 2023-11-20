import 'exception_code.dart';

class BaseException implements Exception {
  const BaseException(
    this.exceptionCode, {
    this.info,
  });

  final ExceptionCode exceptionCode;
  final dynamic info;

  @override
  String toString() {
    return 'CustomException{errorCode: ${exceptionCode.code}, message: ${exceptionCode.message}, info: $info}';
  }
}
