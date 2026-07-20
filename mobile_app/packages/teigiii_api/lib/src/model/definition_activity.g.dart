// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'definition_activity.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DefinitionActivityCWProxy {
  DefinitionActivity type(DefinitionActivityTypeEnum type);

  DefinitionActivity occurredAt(DateTime occurredAt);

  DefinitionActivity definition(DefinitionResponse definition);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DefinitionActivity(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DefinitionActivity(...).copyWith(id: 12, name: "My name")
  /// ````
  DefinitionActivity call({
    DefinitionActivityTypeEnum type,
    DateTime occurredAt,
    DefinitionResponse definition,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfDefinitionActivity.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfDefinitionActivity.copyWith.fieldName(...)`
class _$DefinitionActivityCWProxyImpl implements _$DefinitionActivityCWProxy {
  const _$DefinitionActivityCWProxyImpl(this._value);

  final DefinitionActivity _value;

  @override
  DefinitionActivity type(DefinitionActivityTypeEnum type) => this(type: type);

  @override
  DefinitionActivity occurredAt(DateTime occurredAt) =>
      this(occurredAt: occurredAt);

  @override
  DefinitionActivity definition(DefinitionResponse definition) =>
      this(definition: definition);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DefinitionActivity(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DefinitionActivity(...).copyWith(id: 12, name: "My name")
  /// ````
  DefinitionActivity call({
    Object? type = const $CopyWithPlaceholder(),
    Object? occurredAt = const $CopyWithPlaceholder(),
    Object? definition = const $CopyWithPlaceholder(),
  }) {
    return DefinitionActivity(
      type: type == const $CopyWithPlaceholder()
          ? _value.type
          // ignore: cast_nullable_to_non_nullable
          : type as DefinitionActivityTypeEnum,
      occurredAt: occurredAt == const $CopyWithPlaceholder()
          ? _value.occurredAt
          // ignore: cast_nullable_to_non_nullable
          : occurredAt as DateTime,
      definition: definition == const $CopyWithPlaceholder()
          ? _value.definition
          // ignore: cast_nullable_to_non_nullable
          : definition as DefinitionResponse,
    );
  }
}

extension $DefinitionActivityCopyWith on DefinitionActivity {
  /// Returns a callable class that can be used as follows: `instanceOfDefinitionActivity.copyWith(...)` or like so:`instanceOfDefinitionActivity.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DefinitionActivityCWProxy get copyWith =>
      _$DefinitionActivityCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DefinitionActivity _$DefinitionActivityFromJson(Map<String, dynamic> json) =>
    $checkedCreate('DefinitionActivity', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['type', 'occurredAt', 'definition'],
      );
      final val = DefinitionActivity(
        type: $checkedConvert(
          'type',
          (v) => $enumDecode(_$DefinitionActivityTypeEnumEnumMap, v),
        ),
        occurredAt: $checkedConvert(
          'occurredAt',
          (v) => DateTime.parse(v as String),
        ),
        definition: $checkedConvert(
          'definition',
          (v) => DefinitionResponse.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    });

Map<String, dynamic> _$DefinitionActivityToJson(DefinitionActivity instance) =>
    <String, dynamic>{
      'type': _$DefinitionActivityTypeEnumEnumMap[instance.type]!,
      'occurredAt': instance.occurredAt.toIso8601String(),
      'definition': instance.definition.toJson(),
    };

const _$DefinitionActivityTypeEnumEnumMap = {
  DefinitionActivityTypeEnum.definition: 'definition',
};
