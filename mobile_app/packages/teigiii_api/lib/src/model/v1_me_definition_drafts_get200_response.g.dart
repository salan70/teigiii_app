// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_me_definition_drafts_get200_response.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$V1MeDefinitionDraftsGet200ResponseCWProxy {
  V1MeDefinitionDraftsGet200Response items(List<DefinitionDraftResponse> items);

  V1MeDefinitionDraftsGet200Response nextCursor(String? nextCursor);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `V1MeDefinitionDraftsGet200Response(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// V1MeDefinitionDraftsGet200Response(...).copyWith(id: 12, name: "My name")
  /// ````
  V1MeDefinitionDraftsGet200Response call({
    List<DefinitionDraftResponse> items,
    String? nextCursor,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfV1MeDefinitionDraftsGet200Response.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfV1MeDefinitionDraftsGet200Response.copyWith.fieldName(...)`
class _$V1MeDefinitionDraftsGet200ResponseCWProxyImpl
    implements _$V1MeDefinitionDraftsGet200ResponseCWProxy {
  const _$V1MeDefinitionDraftsGet200ResponseCWProxyImpl(this._value);

  final V1MeDefinitionDraftsGet200Response _value;

  @override
  V1MeDefinitionDraftsGet200Response items(
    List<DefinitionDraftResponse> items,
  ) => this(items: items);

  @override
  V1MeDefinitionDraftsGet200Response nextCursor(String? nextCursor) =>
      this(nextCursor: nextCursor);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `V1MeDefinitionDraftsGet200Response(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// V1MeDefinitionDraftsGet200Response(...).copyWith(id: 12, name: "My name")
  /// ````
  V1MeDefinitionDraftsGet200Response call({
    Object? items = const $CopyWithPlaceholder(),
    Object? nextCursor = const $CopyWithPlaceholder(),
  }) {
    return V1MeDefinitionDraftsGet200Response(
      items: items == const $CopyWithPlaceholder()
          ? _value.items
          // ignore: cast_nullable_to_non_nullable
          : items as List<DefinitionDraftResponse>,
      nextCursor: nextCursor == const $CopyWithPlaceholder()
          ? _value.nextCursor
          // ignore: cast_nullable_to_non_nullable
          : nextCursor as String?,
    );
  }
}

extension $V1MeDefinitionDraftsGet200ResponseCopyWith
    on V1MeDefinitionDraftsGet200Response {
  /// Returns a callable class that can be used as follows: `instanceOfV1MeDefinitionDraftsGet200Response.copyWith(...)` or like so:`instanceOfV1MeDefinitionDraftsGet200Response.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$V1MeDefinitionDraftsGet200ResponseCWProxy get copyWith =>
      _$V1MeDefinitionDraftsGet200ResponseCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

V1MeDefinitionDraftsGet200Response _$V1MeDefinitionDraftsGet200ResponseFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('V1MeDefinitionDraftsGet200Response', json, (
  $checkedConvert,
) {
  $checkKeys(json, requiredKeys: const ['items', 'nextCursor']);
  final val = V1MeDefinitionDraftsGet200Response(
    items: $checkedConvert(
      'items',
      (v) => (v as List<dynamic>)
          .map(
            (e) => DefinitionDraftResponse.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    ),
    nextCursor: $checkedConvert('nextCursor', (v) => v as String?),
  );
  return val;
});

Map<String, dynamic> _$V1MeDefinitionDraftsGet200ResponseToJson(
  V1MeDefinitionDraftsGet200Response instance,
) => <String, dynamic>{
  'items': instance.items.map((e) => e.toJson()).toList(),
  'nextCursor': instance.nextCursor,
};
