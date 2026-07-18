// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word_response.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$WordResponseCWProxy {
  WordResponse id(String id);

  WordResponse word(String word);

  WordResponse reading(String reading);

  WordResponse readingSubGroup(String readingSubGroup);

  WordResponse publicDefinitionCount(int publicDefinitionCount);

  WordResponse isSavedByMe(bool isSavedByMe);

  WordResponse isEditableByMe(bool isEditableByMe);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `WordResponse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// WordResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  WordResponse call({
    String id,
    String word,
    String reading,
    String readingSubGroup,
    int publicDefinitionCount,
    bool isSavedByMe,
    bool isEditableByMe,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfWordResponse.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfWordResponse.copyWith.fieldName(...)`
class _$WordResponseCWProxyImpl implements _$WordResponseCWProxy {
  const _$WordResponseCWProxyImpl(this._value);

  final WordResponse _value;

  @override
  WordResponse id(String id) => this(id: id);

  @override
  WordResponse word(String word) => this(word: word);

  @override
  WordResponse reading(String reading) => this(reading: reading);

  @override
  WordResponse readingSubGroup(String readingSubGroup) =>
      this(readingSubGroup: readingSubGroup);

  @override
  WordResponse publicDefinitionCount(int publicDefinitionCount) =>
      this(publicDefinitionCount: publicDefinitionCount);

  @override
  WordResponse isSavedByMe(bool isSavedByMe) => this(isSavedByMe: isSavedByMe);

  @override
  WordResponse isEditableByMe(bool isEditableByMe) =>
      this(isEditableByMe: isEditableByMe);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `WordResponse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// WordResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  WordResponse call({
    Object? id = const $CopyWithPlaceholder(),
    Object? word = const $CopyWithPlaceholder(),
    Object? reading = const $CopyWithPlaceholder(),
    Object? readingSubGroup = const $CopyWithPlaceholder(),
    Object? publicDefinitionCount = const $CopyWithPlaceholder(),
    Object? isSavedByMe = const $CopyWithPlaceholder(),
    Object? isEditableByMe = const $CopyWithPlaceholder(),
  }) {
    return WordResponse(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      word: word == const $CopyWithPlaceholder()
          ? _value.word
          // ignore: cast_nullable_to_non_nullable
          : word as String,
      reading: reading == const $CopyWithPlaceholder()
          ? _value.reading
          // ignore: cast_nullable_to_non_nullable
          : reading as String,
      readingSubGroup: readingSubGroup == const $CopyWithPlaceholder()
          ? _value.readingSubGroup
          // ignore: cast_nullable_to_non_nullable
          : readingSubGroup as String,
      publicDefinitionCount:
          publicDefinitionCount == const $CopyWithPlaceholder()
          ? _value.publicDefinitionCount
          // ignore: cast_nullable_to_non_nullable
          : publicDefinitionCount as int,
      isSavedByMe: isSavedByMe == const $CopyWithPlaceholder()
          ? _value.isSavedByMe
          // ignore: cast_nullable_to_non_nullable
          : isSavedByMe as bool,
      isEditableByMe: isEditableByMe == const $CopyWithPlaceholder()
          ? _value.isEditableByMe
          // ignore: cast_nullable_to_non_nullable
          : isEditableByMe as bool,
    );
  }
}

extension $WordResponseCopyWith on WordResponse {
  /// Returns a callable class that can be used as follows: `instanceOfWordResponse.copyWith(...)` or like so:`instanceOfWordResponse.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$WordResponseCWProxy get copyWith => _$WordResponseCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WordResponse _$WordResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate('WordResponse', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'id',
          'word',
          'reading',
          'readingSubGroup',
          'publicDefinitionCount',
          'isSavedByMe',
          'isEditableByMe',
        ],
      );
      final val = WordResponse(
        id: $checkedConvert('id', (v) => v as String),
        word: $checkedConvert('word', (v) => v as String),
        reading: $checkedConvert('reading', (v) => v as String),
        readingSubGroup: $checkedConvert('readingSubGroup', (v) => v as String),
        publicDefinitionCount: $checkedConvert(
          'publicDefinitionCount',
          (v) => (v as num).toInt(),
        ),
        isSavedByMe: $checkedConvert('isSavedByMe', (v) => v as bool),
        isEditableByMe: $checkedConvert('isEditableByMe', (v) => v as bool),
      );
      return val;
    });

Map<String, dynamic> _$WordResponseToJson(WordResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'word': instance.word,
      'reading': instance.reading,
      'readingSubGroup': instance.readingSubGroup,
      'publicDefinitionCount': instance.publicDefinitionCount,
      'isSavedByMe': instance.isSavedByMe,
      'isEditableByMe': instance.isEditableByMe,
    };
