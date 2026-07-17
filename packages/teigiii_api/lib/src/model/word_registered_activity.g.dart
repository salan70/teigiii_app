// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word_registered_activity.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$WordRegisteredActivityCWProxy {
  WordRegisteredActivity type(WordRegisteredActivityTypeEnum type);

  WordRegisteredActivity occurredAt(DateTime occurredAt);

  WordRegisteredActivity word(WordSummary word);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `WordRegisteredActivity(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// WordRegisteredActivity(...).copyWith(id: 12, name: "My name")
  /// ````
  WordRegisteredActivity call({
    WordRegisteredActivityTypeEnum type,
    DateTime occurredAt,
    WordSummary word,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfWordRegisteredActivity.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfWordRegisteredActivity.copyWith.fieldName(...)`
class _$WordRegisteredActivityCWProxyImpl
    implements _$WordRegisteredActivityCWProxy {
  const _$WordRegisteredActivityCWProxyImpl(this._value);

  final WordRegisteredActivity _value;

  @override
  WordRegisteredActivity type(WordRegisteredActivityTypeEnum type) =>
      this(type: type);

  @override
  WordRegisteredActivity occurredAt(DateTime occurredAt) =>
      this(occurredAt: occurredAt);

  @override
  WordRegisteredActivity word(WordSummary word) => this(word: word);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `WordRegisteredActivity(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// WordRegisteredActivity(...).copyWith(id: 12, name: "My name")
  /// ````
  WordRegisteredActivity call({
    Object? type = const $CopyWithPlaceholder(),
    Object? occurredAt = const $CopyWithPlaceholder(),
    Object? word = const $CopyWithPlaceholder(),
  }) {
    return WordRegisteredActivity(
      type: type == const $CopyWithPlaceholder()
          ? _value.type
          // ignore: cast_nullable_to_non_nullable
          : type as WordRegisteredActivityTypeEnum,
      occurredAt: occurredAt == const $CopyWithPlaceholder()
          ? _value.occurredAt
          // ignore: cast_nullable_to_non_nullable
          : occurredAt as DateTime,
      word: word == const $CopyWithPlaceholder()
          ? _value.word
          // ignore: cast_nullable_to_non_nullable
          : word as WordSummary,
    );
  }
}

extension $WordRegisteredActivityCopyWith on WordRegisteredActivity {
  /// Returns a callable class that can be used as follows: `instanceOfWordRegisteredActivity.copyWith(...)` or like so:`instanceOfWordRegisteredActivity.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$WordRegisteredActivityCWProxy get copyWith =>
      _$WordRegisteredActivityCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WordRegisteredActivity _$WordRegisteredActivityFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('WordRegisteredActivity', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['type', 'occurredAt', 'word']);
  final val = WordRegisteredActivity(
    type: $checkedConvert(
      'type',
      (v) => $enumDecode(_$WordRegisteredActivityTypeEnumEnumMap, v),
    ),
    occurredAt: $checkedConvert(
      'occurredAt',
      (v) => DateTime.parse(v as String),
    ),
    word: $checkedConvert(
      'word',
      (v) => WordSummary.fromJson(v as Map<String, dynamic>),
    ),
  );
  return val;
});

Map<String, dynamic> _$WordRegisteredActivityToJson(
  WordRegisteredActivity instance,
) => <String, dynamic>{
  'type': _$WordRegisteredActivityTypeEnumEnumMap[instance.type]!,
  'occurredAt': instance.occurredAt.toIso8601String(),
  'word': instance.word.toJson(),
};

const _$WordRegisteredActivityTypeEnumEnumMap = {
  WordRegisteredActivityTypeEnum.wordRegistered: 'wordRegistered',
};
