import 'package:collection/collection.dart';

import 'base_exception.dart';
import 'exception_code.dart';

class DatabaseException extends BaseException {
  const DatabaseException(
    DatabaseExceptionCode super.exceptionCode, {
    super.info,
  });

  // factoryで [code] から生成する
  factory DatabaseException.fromCode(String code) {
    final errorInfo = DatabaseExceptionCode.fromCode(code);
    // 取得に失敗した場合、一律で [DatabaseErrorCode.unknown] とする
    if (errorInfo == null) {
      throw const DatabaseException(DatabaseExceptionCode.unknown);
    }
    return DatabaseException(errorInfo);
  }
}

/// データベース関連のエラーコード
enum DatabaseExceptionCode implements ExceptionCode {
  // データが見つからない
  notFound(
    'not found',
    'エラーが発生しました。もう一度お試しください。',
  ),
  // 不明
  unknown(
    'unknown',
    'エラーが発生しました。もう一度お試しください。',
  );

  const DatabaseExceptionCode(
    this._code,
    this._message,
  );

  final String _code;
  final String? _message;

  @override
  String get code => _code;

  @override
  String get message => _message ?? 'エラーが発生しました。もう一度お試しください。';

  static DatabaseExceptionCode? fromCode(String code) =>
      values.firstWhereOrNull((element) => element.code == code);
}
