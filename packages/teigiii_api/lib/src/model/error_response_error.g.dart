// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error_response_error.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ErrorResponseErrorCWProxy {
  ErrorResponseError code(String code);

  ErrorResponseError message(String message);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ErrorResponseError(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ErrorResponseError(...).copyWith(id: 12, name: "My name")
  /// ````
  ErrorResponseError call({String code, String message});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfErrorResponseError.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfErrorResponseError.copyWith.fieldName(...)`
class _$ErrorResponseErrorCWProxyImpl implements _$ErrorResponseErrorCWProxy {
  const _$ErrorResponseErrorCWProxyImpl(this._value);

  final ErrorResponseError _value;

  @override
  ErrorResponseError code(String code) => this(code: code);

  @override
  ErrorResponseError message(String message) => this(message: message);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ErrorResponseError(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ErrorResponseError(...).copyWith(id: 12, name: "My name")
  /// ````
  ErrorResponseError call({
    Object? code = const $CopyWithPlaceholder(),
    Object? message = const $CopyWithPlaceholder(),
  }) {
    return ErrorResponseError(
      code: code == const $CopyWithPlaceholder()
          ? _value.code
          // ignore: cast_nullable_to_non_nullable
          : code as String,
      message: message == const $CopyWithPlaceholder()
          ? _value.message
          // ignore: cast_nullable_to_non_nullable
          : message as String,
    );
  }
}

extension $ErrorResponseErrorCopyWith on ErrorResponseError {
  /// Returns a callable class that can be used as follows: `instanceOfErrorResponseError.copyWith(...)` or like so:`instanceOfErrorResponseError.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ErrorResponseErrorCWProxy get copyWith =>
      _$ErrorResponseErrorCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ErrorResponseError _$ErrorResponseErrorFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ErrorResponseError', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['code', 'message']);
      final val = ErrorResponseError(
        code: $checkedConvert('code', (v) => v as String),
        message: $checkedConvert('message', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$ErrorResponseErrorToJson(ErrorResponseError instance) =>
    <String, dynamic>{'code': instance.code, 'message': instance.message};
