// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_dictionary_overview.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$MyDictionaryOverviewCWProxy {
  MyDictionaryOverview definedWordCount(int definedWordCount);

  MyDictionaryOverview draftCount(int draftCount);

  MyDictionaryOverview savedWordCount(int savedWordCount);

  MyDictionaryOverview recentDefinitions(
    List<DefinitionResponse> recentDefinitions,
  );

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MyDictionaryOverview(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MyDictionaryOverview(...).copyWith(id: 12, name: "My name")
  /// ````
  MyDictionaryOverview call({
    int definedWordCount,
    int draftCount,
    int savedWordCount,
    List<DefinitionResponse> recentDefinitions,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfMyDictionaryOverview.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfMyDictionaryOverview.copyWith.fieldName(...)`
class _$MyDictionaryOverviewCWProxyImpl
    implements _$MyDictionaryOverviewCWProxy {
  const _$MyDictionaryOverviewCWProxyImpl(this._value);

  final MyDictionaryOverview _value;

  @override
  MyDictionaryOverview definedWordCount(int definedWordCount) =>
      this(definedWordCount: definedWordCount);

  @override
  MyDictionaryOverview draftCount(int draftCount) =>
      this(draftCount: draftCount);

  @override
  MyDictionaryOverview savedWordCount(int savedWordCount) =>
      this(savedWordCount: savedWordCount);

  @override
  MyDictionaryOverview recentDefinitions(
    List<DefinitionResponse> recentDefinitions,
  ) => this(recentDefinitions: recentDefinitions);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MyDictionaryOverview(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MyDictionaryOverview(...).copyWith(id: 12, name: "My name")
  /// ````
  MyDictionaryOverview call({
    Object? definedWordCount = const $CopyWithPlaceholder(),
    Object? draftCount = const $CopyWithPlaceholder(),
    Object? savedWordCount = const $CopyWithPlaceholder(),
    Object? recentDefinitions = const $CopyWithPlaceholder(),
  }) {
    return MyDictionaryOverview(
      definedWordCount: definedWordCount == const $CopyWithPlaceholder()
          ? _value.definedWordCount
          // ignore: cast_nullable_to_non_nullable
          : definedWordCount as int,
      draftCount: draftCount == const $CopyWithPlaceholder()
          ? _value.draftCount
          // ignore: cast_nullable_to_non_nullable
          : draftCount as int,
      savedWordCount: savedWordCount == const $CopyWithPlaceholder()
          ? _value.savedWordCount
          // ignore: cast_nullable_to_non_nullable
          : savedWordCount as int,
      recentDefinitions: recentDefinitions == const $CopyWithPlaceholder()
          ? _value.recentDefinitions
          // ignore: cast_nullable_to_non_nullable
          : recentDefinitions as List<DefinitionResponse>,
    );
  }
}

extension $MyDictionaryOverviewCopyWith on MyDictionaryOverview {
  /// Returns a callable class that can be used as follows: `instanceOfMyDictionaryOverview.copyWith(...)` or like so:`instanceOfMyDictionaryOverview.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$MyDictionaryOverviewCWProxy get copyWith =>
      _$MyDictionaryOverviewCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyDictionaryOverview _$MyDictionaryOverviewFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('MyDictionaryOverview', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const [
      'definedWordCount',
      'draftCount',
      'savedWordCount',
      'recentDefinitions',
    ],
  );
  final val = MyDictionaryOverview(
    definedWordCount: $checkedConvert(
      'definedWordCount',
      (v) => (v as num).toInt(),
    ),
    draftCount: $checkedConvert('draftCount', (v) => (v as num).toInt()),
    savedWordCount: $checkedConvert(
      'savedWordCount',
      (v) => (v as num).toInt(),
    ),
    recentDefinitions: $checkedConvert(
      'recentDefinitions',
      (v) => (v as List<dynamic>)
          .map((e) => DefinitionResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
  );
  return val;
});

Map<String, dynamic> _$MyDictionaryOverviewToJson(
  MyDictionaryOverview instance,
) => <String, dynamic>{
  'definedWordCount': instance.definedWordCount,
  'draftCount': instance.draftCount,
  'savedWordCount': instance.savedWordCount,
  'recentDefinitions': instance.recentDefinitions
      .map((e) => e.toJson())
      .toList(),
};
