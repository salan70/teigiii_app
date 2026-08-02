// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_word_response.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CreateWordResponseCWProxy {
  CreateWordResponse id(String id);

  CreateWordResponse word(String word);

  CreateWordResponse reading(String reading);

  CreateWordResponse readingSubGroup(String readingSubGroup);

  CreateWordResponse publicDefinitionCount(int publicDefinitionCount);

  CreateWordResponse isSavedByMe(bool isSavedByMe);

  CreateWordResponse isEditableByMe(bool isEditableByMe);

  CreateWordResponse registrationResult(
    WordRegistrationResult registrationResult,
  );

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CreateWordResponse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CreateWordResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  CreateWordResponse call({
    String id,
    String word,
    String reading,
    String readingSubGroup,
    int publicDefinitionCount,
    bool isSavedByMe,
    bool isEditableByMe,
    WordRegistrationResult registrationResult,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfCreateWordResponse.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfCreateWordResponse.copyWith.fieldName(...)`
class _$CreateWordResponseCWProxyImpl implements _$CreateWordResponseCWProxy {
  const _$CreateWordResponseCWProxyImpl(this._value);

  final CreateWordResponse _value;

  @override
  CreateWordResponse id(String id) => this(id: id);

  @override
  CreateWordResponse word(String word) => this(word: word);

  @override
  CreateWordResponse reading(String reading) => this(reading: reading);

  @override
  CreateWordResponse readingSubGroup(String readingSubGroup) =>
      this(readingSubGroup: readingSubGroup);

  @override
  CreateWordResponse publicDefinitionCount(int publicDefinitionCount) =>
      this(publicDefinitionCount: publicDefinitionCount);

  @override
  CreateWordResponse isSavedByMe(bool isSavedByMe) =>
      this(isSavedByMe: isSavedByMe);

  @override
  CreateWordResponse isEditableByMe(bool isEditableByMe) =>
      this(isEditableByMe: isEditableByMe);

  @override
  CreateWordResponse registrationResult(
    WordRegistrationResult registrationResult,
  ) => this(registrationResult: registrationResult);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CreateWordResponse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CreateWordResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  CreateWordResponse call({
    Object? id = const $CopyWithPlaceholder(),
    Object? word = const $CopyWithPlaceholder(),
    Object? reading = const $CopyWithPlaceholder(),
    Object? readingSubGroup = const $CopyWithPlaceholder(),
    Object? publicDefinitionCount = const $CopyWithPlaceholder(),
    Object? isSavedByMe = const $CopyWithPlaceholder(),
    Object? isEditableByMe = const $CopyWithPlaceholder(),
    Object? registrationResult = const $CopyWithPlaceholder(),
  }) {
    return CreateWordResponse(
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
      registrationResult: registrationResult == const $CopyWithPlaceholder()
          ? _value.registrationResult
          // ignore: cast_nullable_to_non_nullable
          : registrationResult as WordRegistrationResult,
    );
  }
}

extension $CreateWordResponseCopyWith on CreateWordResponse {
  /// Returns a callable class that can be used as follows: `instanceOfCreateWordResponse.copyWith(...)` or like so:`instanceOfCreateWordResponse.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CreateWordResponseCWProxy get copyWith =>
      _$CreateWordResponseCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateWordResponse _$CreateWordResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate('CreateWordResponse', json, ($checkedConvert) {
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
          'registrationResult',
        ],
      );
      final val = CreateWordResponse(
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
        registrationResult: $checkedConvert(
          'registrationResult',
          (v) => $enumDecode(_$WordRegistrationResultEnumMap, v),
        ),
      );
      return val;
    });

Map<String, dynamic> _$CreateWordResponseToJson(CreateWordResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'word': instance.word,
      'reading': instance.reading,
      'readingSubGroup': instance.readingSubGroup,
      'publicDefinitionCount': instance.publicDefinitionCount,
      'isSavedByMe': instance.isSavedByMe,
      'isEditableByMe': instance.isEditableByMe,
      'registrationResult':
          _$WordRegistrationResultEnumMap[instance.registrationResult]!,
    };

const _$WordRegistrationResultEnumMap = {
  WordRegistrationResult.created: 'created',
  WordRegistrationResult.promoted: 'promoted',
  WordRegistrationResult.alreadyPublic: 'alreadyPublic',
};
