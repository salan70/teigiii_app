// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'finalize_definition_draft_request.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$FinalizeDefinitionDraftRequestCWProxy {
  FinalizeDefinitionDraftRequest confirmReadingMismatch(
    bool? confirmReadingMismatch,
  );

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `FinalizeDefinitionDraftRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// FinalizeDefinitionDraftRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  FinalizeDefinitionDraftRequest call({bool? confirmReadingMismatch});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfFinalizeDefinitionDraftRequest.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfFinalizeDefinitionDraftRequest.copyWith.fieldName(...)`
class _$FinalizeDefinitionDraftRequestCWProxyImpl
    implements _$FinalizeDefinitionDraftRequestCWProxy {
  const _$FinalizeDefinitionDraftRequestCWProxyImpl(this._value);

  final FinalizeDefinitionDraftRequest _value;

  @override
  FinalizeDefinitionDraftRequest confirmReadingMismatch(
    bool? confirmReadingMismatch,
  ) => this(confirmReadingMismatch: confirmReadingMismatch);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `FinalizeDefinitionDraftRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// FinalizeDefinitionDraftRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  FinalizeDefinitionDraftRequest call({
    Object? confirmReadingMismatch = const $CopyWithPlaceholder(),
  }) {
    return FinalizeDefinitionDraftRequest(
      confirmReadingMismatch:
          confirmReadingMismatch == const $CopyWithPlaceholder()
          ? _value.confirmReadingMismatch
          // ignore: cast_nullable_to_non_nullable
          : confirmReadingMismatch as bool?,
    );
  }
}

extension $FinalizeDefinitionDraftRequestCopyWith
    on FinalizeDefinitionDraftRequest {
  /// Returns a callable class that can be used as follows: `instanceOfFinalizeDefinitionDraftRequest.copyWith(...)` or like so:`instanceOfFinalizeDefinitionDraftRequest.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$FinalizeDefinitionDraftRequestCWProxy get copyWith =>
      _$FinalizeDefinitionDraftRequestCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FinalizeDefinitionDraftRequest _$FinalizeDefinitionDraftRequestFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('FinalizeDefinitionDraftRequest', json, ($checkedConvert) {
  final val = FinalizeDefinitionDraftRequest(
    confirmReadingMismatch: $checkedConvert(
      'confirmReadingMismatch',
      (v) => v as bool? ?? false,
    ),
  );
  return val;
});

Map<String, dynamic> _$FinalizeDefinitionDraftRequestToJson(
  FinalizeDefinitionDraftRequest instance,
) => <String, dynamic>{
  'confirmReadingMismatch': ?instance.confirmReadingMismatch,
};
