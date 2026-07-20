// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'definition_draft_response.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DefinitionDraftResponseCWProxy {
  DefinitionDraftResponse id(String id);

  DefinitionDraftResponse wordId(String? wordId);

  DefinitionDraftResponse word(String word);

  DefinitionDraftResponse reading(String reading);

  DefinitionDraftResponse body(String body);

  DefinitionDraftResponse visibility(DefinitionVisibility visibility);

  DefinitionDraftResponse finalizedDefinitionId(String? finalizedDefinitionId);

  DefinitionDraftResponse createdAt(DateTime createdAt);

  DefinitionDraftResponse updatedAt(DateTime updatedAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DefinitionDraftResponse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DefinitionDraftResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  DefinitionDraftResponse call({
    String id,
    String? wordId,
    String word,
    String reading,
    String body,
    DefinitionVisibility visibility,
    String? finalizedDefinitionId,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfDefinitionDraftResponse.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfDefinitionDraftResponse.copyWith.fieldName(...)`
class _$DefinitionDraftResponseCWProxyImpl
    implements _$DefinitionDraftResponseCWProxy {
  const _$DefinitionDraftResponseCWProxyImpl(this._value);

  final DefinitionDraftResponse _value;

  @override
  DefinitionDraftResponse id(String id) => this(id: id);

  @override
  DefinitionDraftResponse wordId(String? wordId) => this(wordId: wordId);

  @override
  DefinitionDraftResponse word(String word) => this(word: word);

  @override
  DefinitionDraftResponse reading(String reading) => this(reading: reading);

  @override
  DefinitionDraftResponse body(String body) => this(body: body);

  @override
  DefinitionDraftResponse visibility(DefinitionVisibility visibility) =>
      this(visibility: visibility);

  @override
  DefinitionDraftResponse finalizedDefinitionId(
    String? finalizedDefinitionId,
  ) => this(finalizedDefinitionId: finalizedDefinitionId);

  @override
  DefinitionDraftResponse createdAt(DateTime createdAt) =>
      this(createdAt: createdAt);

  @override
  DefinitionDraftResponse updatedAt(DateTime updatedAt) =>
      this(updatedAt: updatedAt);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DefinitionDraftResponse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DefinitionDraftResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  DefinitionDraftResponse call({
    Object? id = const $CopyWithPlaceholder(),
    Object? wordId = const $CopyWithPlaceholder(),
    Object? word = const $CopyWithPlaceholder(),
    Object? reading = const $CopyWithPlaceholder(),
    Object? body = const $CopyWithPlaceholder(),
    Object? visibility = const $CopyWithPlaceholder(),
    Object? finalizedDefinitionId = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
    Object? updatedAt = const $CopyWithPlaceholder(),
  }) {
    return DefinitionDraftResponse(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      wordId: wordId == const $CopyWithPlaceholder()
          ? _value.wordId
          // ignore: cast_nullable_to_non_nullable
          : wordId as String?,
      word: word == const $CopyWithPlaceholder()
          ? _value.word
          // ignore: cast_nullable_to_non_nullable
          : word as String,
      reading: reading == const $CopyWithPlaceholder()
          ? _value.reading
          // ignore: cast_nullable_to_non_nullable
          : reading as String,
      body: body == const $CopyWithPlaceholder()
          ? _value.body
          // ignore: cast_nullable_to_non_nullable
          : body as String,
      visibility: visibility == const $CopyWithPlaceholder()
          ? _value.visibility
          // ignore: cast_nullable_to_non_nullable
          : visibility as DefinitionVisibility,
      finalizedDefinitionId:
          finalizedDefinitionId == const $CopyWithPlaceholder()
          ? _value.finalizedDefinitionId
          // ignore: cast_nullable_to_non_nullable
          : finalizedDefinitionId as String?,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime,
      updatedAt: updatedAt == const $CopyWithPlaceholder()
          ? _value.updatedAt
          // ignore: cast_nullable_to_non_nullable
          : updatedAt as DateTime,
    );
  }
}

extension $DefinitionDraftResponseCopyWith on DefinitionDraftResponse {
  /// Returns a callable class that can be used as follows: `instanceOfDefinitionDraftResponse.copyWith(...)` or like so:`instanceOfDefinitionDraftResponse.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DefinitionDraftResponseCWProxy get copyWith =>
      _$DefinitionDraftResponseCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DefinitionDraftResponse _$DefinitionDraftResponseFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('DefinitionDraftResponse', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const [
      'id',
      'wordId',
      'word',
      'reading',
      'body',
      'visibility',
      'finalizedDefinitionId',
      'createdAt',
      'updatedAt',
    ],
  );
  final val = DefinitionDraftResponse(
    id: $checkedConvert('id', (v) => v as String),
    wordId: $checkedConvert('wordId', (v) => v as String?),
    word: $checkedConvert('word', (v) => v as String),
    reading: $checkedConvert('reading', (v) => v as String),
    body: $checkedConvert('body', (v) => v as String),
    visibility: $checkedConvert(
      'visibility',
      (v) => $enumDecode(_$DefinitionVisibilityEnumMap, v),
    ),
    finalizedDefinitionId: $checkedConvert(
      'finalizedDefinitionId',
      (v) => v as String?,
    ),
    createdAt: $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
    updatedAt: $checkedConvert('updatedAt', (v) => DateTime.parse(v as String)),
  );
  return val;
});

Map<String, dynamic> _$DefinitionDraftResponseToJson(
  DefinitionDraftResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'wordId': instance.wordId,
  'word': instance.word,
  'reading': instance.reading,
  'body': instance.body,
  'visibility': _$DefinitionVisibilityEnumMap[instance.visibility]!,
  'finalizedDefinitionId': instance.finalizedDefinitionId,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};

const _$DefinitionVisibilityEnumMap = {
  DefinitionVisibility.public: 'public',
  DefinitionVisibility.private: 'private',
};
