// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word_reading_mismatch_response_error.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$WordReadingMismatchResponseErrorCWProxy {
  WordReadingMismatchResponseError code(
    WordReadingMismatchResponseErrorCodeEnum code,
  );

  WordReadingMismatchResponseError message(String message);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `WordReadingMismatchResponseError(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// WordReadingMismatchResponseError(...).copyWith(id: 12, name: "My name")
  /// ````
  WordReadingMismatchResponseError call({
    WordReadingMismatchResponseErrorCodeEnum code,
    String message,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfWordReadingMismatchResponseError.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfWordReadingMismatchResponseError.copyWith.fieldName(...)`
class _$WordReadingMismatchResponseErrorCWProxyImpl
    implements _$WordReadingMismatchResponseErrorCWProxy {
  const _$WordReadingMismatchResponseErrorCWProxyImpl(this._value);

  final WordReadingMismatchResponseError _value;

  @override
  WordReadingMismatchResponseError code(
    WordReadingMismatchResponseErrorCodeEnum code,
  ) => this(code: code);

  @override
  WordReadingMismatchResponseError message(String message) =>
      this(message: message);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `WordReadingMismatchResponseError(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// WordReadingMismatchResponseError(...).copyWith(id: 12, name: "My name")
  /// ````
  WordReadingMismatchResponseError call({
    Object? code = const $CopyWithPlaceholder(),
    Object? message = const $CopyWithPlaceholder(),
  }) {
    return WordReadingMismatchResponseError(
      code: code == const $CopyWithPlaceholder()
          ? _value.code
          // ignore: cast_nullable_to_non_nullable
          : code as WordReadingMismatchResponseErrorCodeEnum,
      message: message == const $CopyWithPlaceholder()
          ? _value.message
          // ignore: cast_nullable_to_non_nullable
          : message as String,
    );
  }
}

extension $WordReadingMismatchResponseErrorCopyWith
    on WordReadingMismatchResponseError {
  /// Returns a callable class that can be used as follows: `instanceOfWordReadingMismatchResponseError.copyWith(...)` or like so:`instanceOfWordReadingMismatchResponseError.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$WordReadingMismatchResponseErrorCWProxy get copyWith =>
      _$WordReadingMismatchResponseErrorCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WordReadingMismatchResponseError _$WordReadingMismatchResponseErrorFromJson(
  Map<String, dynamic> json,
) =>
    $checkedCreate('WordReadingMismatchResponseError', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['code', 'message']);
      final val = WordReadingMismatchResponseError(
        code: $checkedConvert(
          'code',
          (v) =>
              $enumDecode(_$WordReadingMismatchResponseErrorCodeEnumEnumMap, v),
        ),
        message: $checkedConvert('message', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$WordReadingMismatchResponseErrorToJson(
  WordReadingMismatchResponseError instance,
) => <String, dynamic>{
  'code': _$WordReadingMismatchResponseErrorCodeEnumEnumMap[instance.code]!,
  'message': instance.message,
};

const _$WordReadingMismatchResponseErrorCodeEnumEnumMap = {
  WordReadingMismatchResponseErrorCodeEnum.wordReadingMismatch:
      'word_reading_mismatch',
};
