// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word_lookup_response.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$WordLookupResponseCWProxy {
  WordLookupResponse word(WordSummary? word);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `WordLookupResponse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// WordLookupResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  WordLookupResponse call({WordSummary? word});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfWordLookupResponse.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfWordLookupResponse.copyWith.fieldName(...)`
class _$WordLookupResponseCWProxyImpl implements _$WordLookupResponseCWProxy {
  const _$WordLookupResponseCWProxyImpl(this._value);

  final WordLookupResponse _value;

  @override
  WordLookupResponse word(WordSummary? word) => this(word: word);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `WordLookupResponse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// WordLookupResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  WordLookupResponse call({Object? word = const $CopyWithPlaceholder()}) {
    return WordLookupResponse(
      word: word == const $CopyWithPlaceholder()
          ? _value.word
          // ignore: cast_nullable_to_non_nullable
          : word as WordSummary?,
    );
  }
}

extension $WordLookupResponseCopyWith on WordLookupResponse {
  /// Returns a callable class that can be used as follows: `instanceOfWordLookupResponse.copyWith(...)` or like so:`instanceOfWordLookupResponse.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$WordLookupResponseCWProxy get copyWith =>
      _$WordLookupResponseCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WordLookupResponse _$WordLookupResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate('WordLookupResponse', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['word']);
      final val = WordLookupResponse(
        word: $checkedConvert(
          'word',
          (v) => v == null
              ? null
              : WordSummary.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    });

Map<String, dynamic> _$WordLookupResponseToJson(WordLookupResponse instance) =>
    <String, dynamic>{'word': instance.word?.toJson()};
