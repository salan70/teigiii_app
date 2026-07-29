// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_definition_request.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$UpdateDefinitionRequestCWProxy {
  UpdateDefinitionRequest wordId(String? wordId);

  UpdateDefinitionRequest body(String? body);

  UpdateDefinitionRequest status(DefinitionStatus? status);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UpdateDefinitionRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UpdateDefinitionRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  UpdateDefinitionRequest call({
    String? wordId,
    String? body,
    DefinitionStatus? status,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfUpdateDefinitionRequest.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfUpdateDefinitionRequest.copyWith.fieldName(...)`
class _$UpdateDefinitionRequestCWProxyImpl
    implements _$UpdateDefinitionRequestCWProxy {
  const _$UpdateDefinitionRequestCWProxyImpl(this._value);

  final UpdateDefinitionRequest _value;

  @override
  UpdateDefinitionRequest wordId(String? wordId) => this(wordId: wordId);

  @override
  UpdateDefinitionRequest body(String? body) => this(body: body);

  @override
  UpdateDefinitionRequest status(DefinitionStatus? status) =>
      this(status: status);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UpdateDefinitionRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UpdateDefinitionRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  UpdateDefinitionRequest call({
    Object? wordId = const $CopyWithPlaceholder(),
    Object? body = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
  }) {
    return UpdateDefinitionRequest(
      wordId: wordId == const $CopyWithPlaceholder()
          ? _value.wordId
          // ignore: cast_nullable_to_non_nullable
          : wordId as String?,
      body: body == const $CopyWithPlaceholder()
          ? _value.body
          // ignore: cast_nullable_to_non_nullable
          : body as String?,
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as DefinitionStatus?,
    );
  }
}

extension $UpdateDefinitionRequestCopyWith on UpdateDefinitionRequest {
  /// Returns a callable class that can be used as follows: `instanceOfUpdateDefinitionRequest.copyWith(...)` or like so:`instanceOfUpdateDefinitionRequest.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$UpdateDefinitionRequestCWProxy get copyWith =>
      _$UpdateDefinitionRequestCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateDefinitionRequest _$UpdateDefinitionRequestFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('UpdateDefinitionRequest', json, ($checkedConvert) {
  final val = UpdateDefinitionRequest(
    wordId: $checkedConvert('wordId', (v) => v as String?),
    body: $checkedConvert('body', (v) => v as String?),
    status: $checkedConvert(
      'status',
      (v) => $enumDecodeNullable(_$DefinitionStatusEnumMap, v),
    ),
  );
  return val;
});

Map<String, dynamic> _$UpdateDefinitionRequestToJson(
  UpdateDefinitionRequest instance,
) => <String, dynamic>{
  'wordId': ?instance.wordId,
  'body': ?instance.body,
  'status': ?_$DefinitionStatusEnumMap[instance.status],
};

const _$DefinitionStatusEnumMap = {
  DefinitionStatus.public: 'public',
  DefinitionStatus.private: 'private',
};
