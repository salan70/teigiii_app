// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word_reading_mismatch_response.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$WordReadingMismatchResponseCWProxy {
  WordReadingMismatchResponse error(WordReadingMismatchResponseError error);

  WordReadingMismatchResponse existingWord(WordSummary existingWord);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `WordReadingMismatchResponse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// WordReadingMismatchResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  WordReadingMismatchResponse call({
    WordReadingMismatchResponseError error,
    WordSummary existingWord,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfWordReadingMismatchResponse.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfWordReadingMismatchResponse.copyWith.fieldName(...)`
class _$WordReadingMismatchResponseCWProxyImpl
    implements _$WordReadingMismatchResponseCWProxy {
  const _$WordReadingMismatchResponseCWProxyImpl(this._value);

  final WordReadingMismatchResponse _value;

  @override
  WordReadingMismatchResponse error(WordReadingMismatchResponseError error) =>
      this(error: error);

  @override
  WordReadingMismatchResponse existingWord(WordSummary existingWord) =>
      this(existingWord: existingWord);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `WordReadingMismatchResponse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// WordReadingMismatchResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  WordReadingMismatchResponse call({
    Object? error = const $CopyWithPlaceholder(),
    Object? existingWord = const $CopyWithPlaceholder(),
  }) {
    return WordReadingMismatchResponse(
      error: error == const $CopyWithPlaceholder()
          ? _value.error
          // ignore: cast_nullable_to_non_nullable
          : error as WordReadingMismatchResponseError,
      existingWord: existingWord == const $CopyWithPlaceholder()
          ? _value.existingWord
          // ignore: cast_nullable_to_non_nullable
          : existingWord as WordSummary,
    );
  }
}

extension $WordReadingMismatchResponseCopyWith on WordReadingMismatchResponse {
  /// Returns a callable class that can be used as follows: `instanceOfWordReadingMismatchResponse.copyWith(...)` or like so:`instanceOfWordReadingMismatchResponse.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$WordReadingMismatchResponseCWProxy get copyWith =>
      _$WordReadingMismatchResponseCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WordReadingMismatchResponse _$WordReadingMismatchResponseFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('WordReadingMismatchResponse', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['error', 'existingWord']);
  final val = WordReadingMismatchResponse(
    error: $checkedConvert(
      'error',
      (v) =>
          WordReadingMismatchResponseError.fromJson(v as Map<String, dynamic>),
    ),
    existingWord: $checkedConvert(
      'existingWord',
      (v) => WordSummary.fromJson(v as Map<String, dynamic>),
    ),
  );
  return val;
});

Map<String, dynamic> _$WordReadingMismatchResponseToJson(
  WordReadingMismatchResponse instance,
) => <String, dynamic>{
  'error': instance.error.toJson(),
  'existingWord': instance.existingWord.toJson(),
};
