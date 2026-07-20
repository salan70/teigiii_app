// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_word_request.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CreateWordRequestCWProxy {
  CreateWordRequest word(String word);

  CreateWordRequest reading(String reading);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CreateWordRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CreateWordRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  CreateWordRequest call({String word, String reading});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfCreateWordRequest.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfCreateWordRequest.copyWith.fieldName(...)`
class _$CreateWordRequestCWProxyImpl implements _$CreateWordRequestCWProxy {
  const _$CreateWordRequestCWProxyImpl(this._value);

  final CreateWordRequest _value;

  @override
  CreateWordRequest word(String word) => this(word: word);

  @override
  CreateWordRequest reading(String reading) => this(reading: reading);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CreateWordRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CreateWordRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  CreateWordRequest call({
    Object? word = const $CopyWithPlaceholder(),
    Object? reading = const $CopyWithPlaceholder(),
  }) {
    return CreateWordRequest(
      word: word == const $CopyWithPlaceholder()
          ? _value.word
          // ignore: cast_nullable_to_non_nullable
          : word as String,
      reading: reading == const $CopyWithPlaceholder()
          ? _value.reading
          // ignore: cast_nullable_to_non_nullable
          : reading as String,
    );
  }
}

extension $CreateWordRequestCopyWith on CreateWordRequest {
  /// Returns a callable class that can be used as follows: `instanceOfCreateWordRequest.copyWith(...)` or like so:`instanceOfCreateWordRequest.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CreateWordRequestCWProxy get copyWith =>
      _$CreateWordRequestCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateWordRequest _$CreateWordRequestFromJson(Map<String, dynamic> json) =>
    $checkedCreate('CreateWordRequest', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['word', 'reading']);
      final val = CreateWordRequest(
        word: $checkedConvert('word', (v) => v as String),
        reading: $checkedConvert('reading', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$CreateWordRequestToJson(CreateWordRequest instance) =>
    <String, dynamic>{'word': instance.word, 'reading': instance.reading};
