// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_word_request.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$UpdateWordRequestCWProxy {
  UpdateWordRequest word(String? word);

  UpdateWordRequest reading(String? reading);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UpdateWordRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UpdateWordRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  UpdateWordRequest call({String? word, String? reading});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfUpdateWordRequest.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfUpdateWordRequest.copyWith.fieldName(...)`
class _$UpdateWordRequestCWProxyImpl implements _$UpdateWordRequestCWProxy {
  const _$UpdateWordRequestCWProxyImpl(this._value);

  final UpdateWordRequest _value;

  @override
  UpdateWordRequest word(String? word) => this(word: word);

  @override
  UpdateWordRequest reading(String? reading) => this(reading: reading);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UpdateWordRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UpdateWordRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  UpdateWordRequest call({
    Object? word = const $CopyWithPlaceholder(),
    Object? reading = const $CopyWithPlaceholder(),
  }) {
    return UpdateWordRequest(
      word: word == const $CopyWithPlaceholder()
          ? _value.word
          // ignore: cast_nullable_to_non_nullable
          : word as String?,
      reading: reading == const $CopyWithPlaceholder()
          ? _value.reading
          // ignore: cast_nullable_to_non_nullable
          : reading as String?,
    );
  }
}

extension $UpdateWordRequestCopyWith on UpdateWordRequest {
  /// Returns a callable class that can be used as follows: `instanceOfUpdateWordRequest.copyWith(...)` or like so:`instanceOfUpdateWordRequest.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$UpdateWordRequestCWProxy get copyWith =>
      _$UpdateWordRequestCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateWordRequest _$UpdateWordRequestFromJson(Map<String, dynamic> json) =>
    $checkedCreate('UpdateWordRequest', json, ($checkedConvert) {
      final val = UpdateWordRequest(
        word: $checkedConvert('word', (v) => v as String?),
        reading: $checkedConvert('reading', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$UpdateWordRequestToJson(UpdateWordRequest instance) =>
    <String, dynamic>{'word': ?instance.word, 'reading': ?instance.reading};
