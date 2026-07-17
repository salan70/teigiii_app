// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_definition_request.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CreateDefinitionRequestCWProxy {
  CreateDefinitionRequest wordId(String wordId);

  CreateDefinitionRequest body(String body);

  CreateDefinitionRequest status(DefinitionStatus status);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CreateDefinitionRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CreateDefinitionRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  CreateDefinitionRequest call({
    String wordId,
    String body,
    DefinitionStatus status,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfCreateDefinitionRequest.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfCreateDefinitionRequest.copyWith.fieldName(...)`
class _$CreateDefinitionRequestCWProxyImpl
    implements _$CreateDefinitionRequestCWProxy {
  const _$CreateDefinitionRequestCWProxyImpl(this._value);

  final CreateDefinitionRequest _value;

  @override
  CreateDefinitionRequest wordId(String wordId) => this(wordId: wordId);

  @override
  CreateDefinitionRequest body(String body) => this(body: body);

  @override
  CreateDefinitionRequest status(DefinitionStatus status) =>
      this(status: status);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CreateDefinitionRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CreateDefinitionRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  CreateDefinitionRequest call({
    Object? wordId = const $CopyWithPlaceholder(),
    Object? body = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
  }) {
    return CreateDefinitionRequest(
      wordId: wordId == const $CopyWithPlaceholder()
          ? _value.wordId
          // ignore: cast_nullable_to_non_nullable
          : wordId as String,
      body: body == const $CopyWithPlaceholder()
          ? _value.body
          // ignore: cast_nullable_to_non_nullable
          : body as String,
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as DefinitionStatus,
    );
  }
}

extension $CreateDefinitionRequestCopyWith on CreateDefinitionRequest {
  /// Returns a callable class that can be used as follows: `instanceOfCreateDefinitionRequest.copyWith(...)` or like so:`instanceOfCreateDefinitionRequest.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CreateDefinitionRequestCWProxy get copyWith =>
      _$CreateDefinitionRequestCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateDefinitionRequest _$CreateDefinitionRequestFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('CreateDefinitionRequest', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['wordId', 'body', 'status']);
  final val = CreateDefinitionRequest(
    wordId: $checkedConvert('wordId', (v) => v as String),
    body: $checkedConvert('body', (v) => v as String),
    status: $checkedConvert(
      'status',
      (v) => $enumDecode(_$DefinitionStatusEnumMap, v),
    ),
  );
  return val;
});

Map<String, dynamic> _$CreateDefinitionRequestToJson(
  CreateDefinitionRequest instance,
) => <String, dynamic>{
  'wordId': instance.wordId,
  'body': instance.body,
  'status': _$DefinitionStatusEnumMap[instance.status]!,
};

const _$DefinitionStatusEnumMap = {
  DefinitionStatus.draft: 'draft',
  DefinitionStatus.public: 'public',
  DefinitionStatus.private: 'private',
};
