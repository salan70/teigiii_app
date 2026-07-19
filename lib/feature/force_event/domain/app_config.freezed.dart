// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$AppConfig {
  String get minAppVersionIos => throw _privateConstructorUsedError;
  String get minAppVersionAndroid => throw _privateConstructorUsedError;
  bool get inMaintenance => throw _privateConstructorUsedError;
  DateTime? get maintenanceScheduledEndTime =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AppConfigCopyWith<AppConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppConfigCopyWith<$Res> {
  factory $AppConfigCopyWith(AppConfig value, $Res Function(AppConfig) then) =
      _$AppConfigCopyWithImpl<$Res, AppConfig>;
  @useResult
  $Res call({
    String minAppVersionIos,
    String minAppVersionAndroid,
    bool inMaintenance,
    DateTime? maintenanceScheduledEndTime,
  });
}

/// @nodoc
class _$AppConfigCopyWithImpl<$Res, $Val extends AppConfig>
    implements $AppConfigCopyWith<$Res> {
  _$AppConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? minAppVersionIos = null,
    Object? minAppVersionAndroid = null,
    Object? inMaintenance = null,
    Object? maintenanceScheduledEndTime = freezed,
  }) {
    return _then(
      _value.copyWith(
            minAppVersionIos: null == minAppVersionIos
                ? _value.minAppVersionIos
                : minAppVersionIos // ignore: cast_nullable_to_non_nullable
                      as String,
            minAppVersionAndroid: null == minAppVersionAndroid
                ? _value.minAppVersionAndroid
                : minAppVersionAndroid // ignore: cast_nullable_to_non_nullable
                      as String,
            inMaintenance: null == inMaintenance
                ? _value.inMaintenance
                : inMaintenance // ignore: cast_nullable_to_non_nullable
                      as bool,
            maintenanceScheduledEndTime: freezed == maintenanceScheduledEndTime
                ? _value.maintenanceScheduledEndTime
                : maintenanceScheduledEndTime // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AppConfigImplCopyWith<$Res>
    implements $AppConfigCopyWith<$Res> {
  factory _$$AppConfigImplCopyWith(
    _$AppConfigImpl value,
    $Res Function(_$AppConfigImpl) then,
  ) = __$$AppConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String minAppVersionIos,
    String minAppVersionAndroid,
    bool inMaintenance,
    DateTime? maintenanceScheduledEndTime,
  });
}

/// @nodoc
class __$$AppConfigImplCopyWithImpl<$Res>
    extends _$AppConfigCopyWithImpl<$Res, _$AppConfigImpl>
    implements _$$AppConfigImplCopyWith<$Res> {
  __$$AppConfigImplCopyWithImpl(
    _$AppConfigImpl _value,
    $Res Function(_$AppConfigImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? minAppVersionIos = null,
    Object? minAppVersionAndroid = null,
    Object? inMaintenance = null,
    Object? maintenanceScheduledEndTime = freezed,
  }) {
    return _then(
      _$AppConfigImpl(
        minAppVersionIos: null == minAppVersionIos
            ? _value.minAppVersionIos
            : minAppVersionIos // ignore: cast_nullable_to_non_nullable
                  as String,
        minAppVersionAndroid: null == minAppVersionAndroid
            ? _value.minAppVersionAndroid
            : minAppVersionAndroid // ignore: cast_nullable_to_non_nullable
                  as String,
        inMaintenance: null == inMaintenance
            ? _value.inMaintenance
            : inMaintenance // ignore: cast_nullable_to_non_nullable
                  as bool,
        maintenanceScheduledEndTime: freezed == maintenanceScheduledEndTime
            ? _value.maintenanceScheduledEndTime
            : maintenanceScheduledEndTime // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc

class _$AppConfigImpl extends _AppConfig {
  const _$AppConfigImpl({
    required this.minAppVersionIos,
    required this.minAppVersionAndroid,
    required this.inMaintenance,
    required this.maintenanceScheduledEndTime,
  }) : super._();

  @override
  final String minAppVersionIos;
  @override
  final String minAppVersionAndroid;
  @override
  final bool inMaintenance;
  @override
  final DateTime? maintenanceScheduledEndTime;

  @override
  String toString() {
    return 'AppConfig(minAppVersionIos: $minAppVersionIos, minAppVersionAndroid: $minAppVersionAndroid, inMaintenance: $inMaintenance, maintenanceScheduledEndTime: $maintenanceScheduledEndTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppConfigImpl &&
            (identical(other.minAppVersionIos, minAppVersionIos) ||
                other.minAppVersionIos == minAppVersionIos) &&
            (identical(other.minAppVersionAndroid, minAppVersionAndroid) ||
                other.minAppVersionAndroid == minAppVersionAndroid) &&
            (identical(other.inMaintenance, inMaintenance) ||
                other.inMaintenance == inMaintenance) &&
            (identical(
                  other.maintenanceScheduledEndTime,
                  maintenanceScheduledEndTime,
                ) ||
                other.maintenanceScheduledEndTime ==
                    maintenanceScheduledEndTime));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    minAppVersionIos,
    minAppVersionAndroid,
    inMaintenance,
    maintenanceScheduledEndTime,
  );

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AppConfigImplCopyWith<_$AppConfigImpl> get copyWith =>
      __$$AppConfigImplCopyWithImpl<_$AppConfigImpl>(this, _$identity);
}

abstract class _AppConfig extends AppConfig {
  const factory _AppConfig({
    required final String minAppVersionIos,
    required final String minAppVersionAndroid,
    required final bool inMaintenance,
    required final DateTime? maintenanceScheduledEndTime,
  }) = _$AppConfigImpl;
  const _AppConfig._() : super._();

  @override
  String get minAppVersionIos;
  @override
  String get minAppVersionAndroid;
  @override
  bool get inMaintenance;
  @override
  DateTime? get maintenanceScheduledEndTime;
  @override
  @JsonKey(ignore: true)
  _$$AppConfigImplCopyWith<_$AppConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
