// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'put_definition_draft_request.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PutDefinitionDraftRequestCWProxy {
  PutDefinitionDraftRequest wordId(String? wordId);

  PutDefinitionDraftRequest word(String word);

  PutDefinitionDraftRequest reading(String reading);

  PutDefinitionDraftRequest body(String body);

  PutDefinitionDraftRequest visibility(DefinitionVisibility visibility);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PutDefinitionDraftRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PutDefinitionDraftRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  PutDefinitionDraftRequest call({
    String? wordId,
    String word,
    String reading,
    String body,
    DefinitionVisibility visibility,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPutDefinitionDraftRequest.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPutDefinitionDraftRequest.copyWith.fieldName(...)`
class _$PutDefinitionDraftRequestCWProxyImpl
    implements _$PutDefinitionDraftRequestCWProxy {
  const _$PutDefinitionDraftRequestCWProxyImpl(this._value);

  final PutDefinitionDraftRequest _value;

  @override
  PutDefinitionDraftRequest wordId(String? wordId) => this(wordId: wordId);

  @override
  PutDefinitionDraftRequest word(String word) => this(word: word);

  @override
  PutDefinitionDraftRequest reading(String reading) => this(reading: reading);

  @override
  PutDefinitionDraftRequest body(String body) => this(body: body);

  @override
  PutDefinitionDraftRequest visibility(DefinitionVisibility visibility) =>
      this(visibility: visibility);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PutDefinitionDraftRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PutDefinitionDraftRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  PutDefinitionDraftRequest call({
    Object? wordId = const $CopyWithPlaceholder(),
    Object? word = const $CopyWithPlaceholder(),
    Object? reading = const $CopyWithPlaceholder(),
    Object? body = const $CopyWithPlaceholder(),
    Object? visibility = const $CopyWithPlaceholder(),
  }) {
    return PutDefinitionDraftRequest(
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
    );
  }
}

extension $PutDefinitionDraftRequestCopyWith on PutDefinitionDraftRequest {
  /// Returns a callable class that can be used as follows: `instanceOfPutDefinitionDraftRequest.copyWith(...)` or like so:`instanceOfPutDefinitionDraftRequest.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PutDefinitionDraftRequestCWProxy get copyWith =>
      _$PutDefinitionDraftRequestCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PutDefinitionDraftRequest _$PutDefinitionDraftRequestFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('PutDefinitionDraftRequest', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const ['word', 'reading', 'body', 'visibility'],
  );
  final val = PutDefinitionDraftRequest(
    wordId: $checkedConvert('wordId', (v) => v as String?),
    word: $checkedConvert('word', (v) => v as String),
    reading: $checkedConvert('reading', (v) => v as String),
    body: $checkedConvert('body', (v) => v as String),
    visibility: $checkedConvert(
      'visibility',
      (v) => $enumDecode(_$DefinitionVisibilityEnumMap, v),
    ),
  );
  return val;
});

Map<String, dynamic> _$PutDefinitionDraftRequestToJson(
  PutDefinitionDraftRequest instance,
) => <String, dynamic>{
  'wordId': ?instance.wordId,
  'word': instance.word,
  'reading': instance.reading,
  'body': instance.body,
  'visibility': _$DefinitionVisibilityEnumMap[instance.visibility]!,
};

const _$DefinitionVisibilityEnumMap = {
  DefinitionVisibility.public: 'public',
  DefinitionVisibility.private: 'private',
};
