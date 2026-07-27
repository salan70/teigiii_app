// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'frame_stats_accepted_response.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$FrameStatsAcceptedResponseCWProxy {
  FrameStatsAcceptedResponse accepted(int accepted);

  FrameStatsAcceptedResponse disabled(bool disabled);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `FrameStatsAcceptedResponse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// FrameStatsAcceptedResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  FrameStatsAcceptedResponse call({int accepted, bool disabled});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfFrameStatsAcceptedResponse.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfFrameStatsAcceptedResponse.copyWith.fieldName(...)`
class _$FrameStatsAcceptedResponseCWProxyImpl
    implements _$FrameStatsAcceptedResponseCWProxy {
  const _$FrameStatsAcceptedResponseCWProxyImpl(this._value);

  final FrameStatsAcceptedResponse _value;

  @override
  FrameStatsAcceptedResponse accepted(int accepted) => this(accepted: accepted);

  @override
  FrameStatsAcceptedResponse disabled(bool disabled) =>
      this(disabled: disabled);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `FrameStatsAcceptedResponse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// FrameStatsAcceptedResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  FrameStatsAcceptedResponse call({
    Object? accepted = const $CopyWithPlaceholder(),
    Object? disabled = const $CopyWithPlaceholder(),
  }) {
    return FrameStatsAcceptedResponse(
      accepted: accepted == const $CopyWithPlaceholder()
          ? _value.accepted
          // ignore: cast_nullable_to_non_nullable
          : accepted as int,
      disabled: disabled == const $CopyWithPlaceholder()
          ? _value.disabled
          // ignore: cast_nullable_to_non_nullable
          : disabled as bool,
    );
  }
}

extension $FrameStatsAcceptedResponseCopyWith on FrameStatsAcceptedResponse {
  /// Returns a callable class that can be used as follows: `instanceOfFrameStatsAcceptedResponse.copyWith(...)` or like so:`instanceOfFrameStatsAcceptedResponse.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$FrameStatsAcceptedResponseCWProxy get copyWith =>
      _$FrameStatsAcceptedResponseCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FrameStatsAcceptedResponse _$FrameStatsAcceptedResponseFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('FrameStatsAcceptedResponse', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['accepted', 'disabled']);
  final val = FrameStatsAcceptedResponse(
    accepted: $checkedConvert('accepted', (v) => (v as num).toInt()),
    disabled: $checkedConvert('disabled', (v) => v as bool),
  );
  return val;
});

Map<String, dynamic> _$FrameStatsAcceptedResponseToJson(
  FrameStatsAcceptedResponse instance,
) => <String, dynamic>{
  'accepted': instance.accepted,
  'disabled': instance.disabled,
};
