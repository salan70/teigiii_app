// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word_conflict_response.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$WordConflictResponseCWProxy {
  WordConflictResponse error(ErrorResponseError error);

  WordConflictResponse existingWord(WordSummary existingWord);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `WordConflictResponse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// WordConflictResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  WordConflictResponse call({
    ErrorResponseError error,
    WordSummary existingWord,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfWordConflictResponse.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfWordConflictResponse.copyWith.fieldName(...)`
class _$WordConflictResponseCWProxyImpl
    implements _$WordConflictResponseCWProxy {
  const _$WordConflictResponseCWProxyImpl(this._value);

  final WordConflictResponse _value;

  @override
  WordConflictResponse error(ErrorResponseError error) => this(error: error);

  @override
  WordConflictResponse existingWord(WordSummary existingWord) =>
      this(existingWord: existingWord);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `WordConflictResponse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// WordConflictResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  WordConflictResponse call({
    Object? error = const $CopyWithPlaceholder(),
    Object? existingWord = const $CopyWithPlaceholder(),
  }) {
    return WordConflictResponse(
      error: error == const $CopyWithPlaceholder()
          ? _value.error
          // ignore: cast_nullable_to_non_nullable
          : error as ErrorResponseError,
      existingWord: existingWord == const $CopyWithPlaceholder()
          ? _value.existingWord
          // ignore: cast_nullable_to_non_nullable
          : existingWord as WordSummary,
    );
  }
}

extension $WordConflictResponseCopyWith on WordConflictResponse {
  /// Returns a callable class that can be used as follows: `instanceOfWordConflictResponse.copyWith(...)` or like so:`instanceOfWordConflictResponse.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$WordConflictResponseCWProxy get copyWith =>
      _$WordConflictResponseCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WordConflictResponse _$WordConflictResponseFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('WordConflictResponse', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['error', 'existingWord']);
  final val = WordConflictResponse(
    error: $checkedConvert(
      'error',
      (v) => ErrorResponseError.fromJson(v as Map<String, dynamic>),
    ),
    existingWord: $checkedConvert(
      'existingWord',
      (v) => WordSummary.fromJson(v as Map<String, dynamic>),
    ),
  );
  return val;
});

Map<String, dynamic> _$WordConflictResponseToJson(
  WordConflictResponse instance,
) => <String, dynamic>{
  'error': instance.error.toJson(),
  'existingWord': instance.existingWord.toJson(),
};
