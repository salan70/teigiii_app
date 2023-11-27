// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_config_document.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$AppConfigDocument {
  String get minAppVersionForIos => throw _privateConstructorUsedError;
  String get minAppVersionForAndroid => throw _privateConstructorUsedError;
  Map<String, Map<String, Object>> get maintenanceMap =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AppConfigDocumentCopyWith<AppConfigDocument> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppConfigDocumentCopyWith<$Res> {
  factory $AppConfigDocumentCopyWith(
          AppConfigDocument value, $Res Function(AppConfigDocument) then) =
      _$AppConfigDocumentCopyWithImpl<$Res, AppConfigDocument>;
  @useResult
  $Res call(
      {String minAppVersionForIos,
      String minAppVersionForAndroid,
      Map<String, Map<String, Object>> maintenanceMap});
}

/// @nodoc
class _$AppConfigDocumentCopyWithImpl<$Res, $Val extends AppConfigDocument>
    implements $AppConfigDocumentCopyWith<$Res> {
  _$AppConfigDocumentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? minAppVersionForIos = null,
    Object? minAppVersionForAndroid = null,
    Object? maintenanceMap = null,
  }) {
    return _then(_value.copyWith(
      minAppVersionForIos: null == minAppVersionForIos
          ? _value.minAppVersionForIos
          : minAppVersionForIos // ignore: cast_nullable_to_non_nullable
              as String,
      minAppVersionForAndroid: null == minAppVersionForAndroid
          ? _value.minAppVersionForAndroid
          : minAppVersionForAndroid // ignore: cast_nullable_to_non_nullable
              as String,
      maintenanceMap: null == maintenanceMap
          ? _value.maintenanceMap
          : maintenanceMap // ignore: cast_nullable_to_non_nullable
              as Map<String, Map<String, Object>>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_AppConfigDocumentCopyWith<$Res>
    implements $AppConfigDocumentCopyWith<$Res> {
  factory _$$_AppConfigDocumentCopyWith(_$_AppConfigDocument value,
          $Res Function(_$_AppConfigDocument) then) =
      __$$_AppConfigDocumentCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String minAppVersionForIos,
      String minAppVersionForAndroid,
      Map<String, Map<String, Object>> maintenanceMap});
}

/// @nodoc
class __$$_AppConfigDocumentCopyWithImpl<$Res>
    extends _$AppConfigDocumentCopyWithImpl<$Res, _$_AppConfigDocument>
    implements _$$_AppConfigDocumentCopyWith<$Res> {
  __$$_AppConfigDocumentCopyWithImpl(
      _$_AppConfigDocument _value, $Res Function(_$_AppConfigDocument) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? minAppVersionForIos = null,
    Object? minAppVersionForAndroid = null,
    Object? maintenanceMap = null,
  }) {
    return _then(_$_AppConfigDocument(
      minAppVersionForIos: null == minAppVersionForIos
          ? _value.minAppVersionForIos
          : minAppVersionForIos // ignore: cast_nullable_to_non_nullable
              as String,
      minAppVersionForAndroid: null == minAppVersionForAndroid
          ? _value.minAppVersionForAndroid
          : minAppVersionForAndroid // ignore: cast_nullable_to_non_nullable
              as String,
      maintenanceMap: null == maintenanceMap
          ? _value._maintenanceMap
          : maintenanceMap // ignore: cast_nullable_to_non_nullable
              as Map<String, Map<String, Object>>,
    ));
  }
}

/// @nodoc

class _$_AppConfigDocument extends _AppConfigDocument {
  const _$_AppConfigDocument(
      {required this.minAppVersionForIos,
      required this.minAppVersionForAndroid,
      required final Map<String, Map<String, Object>> maintenanceMap})
      : _maintenanceMap = maintenanceMap,
        super._();

  @override
  final String minAppVersionForIos;
  @override
  final String minAppVersionForAndroid;
  final Map<String, Map<String, Object>> _maintenanceMap;
  @override
  Map<String, Map<String, Object>> get maintenanceMap {
    if (_maintenanceMap is EqualUnmodifiableMapView) return _maintenanceMap;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_maintenanceMap);
  }

  @override
  String toString() {
    return 'AppConfigDocument(minAppVersionForIos: $minAppVersionForIos, minAppVersionForAndroid: $minAppVersionForAndroid, maintenanceMap: $maintenanceMap)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_AppConfigDocument &&
            (identical(other.minAppVersionForIos, minAppVersionForIos) ||
                other.minAppVersionForIos == minAppVersionForIos) &&
            (identical(
                    other.minAppVersionForAndroid, minAppVersionForAndroid) ||
                other.minAppVersionForAndroid == minAppVersionForAndroid) &&
            const DeepCollectionEquality()
                .equals(other._maintenanceMap, _maintenanceMap));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      minAppVersionForIos,
      minAppVersionForAndroid,
      const DeepCollectionEquality().hash(_maintenanceMap));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_AppConfigDocumentCopyWith<_$_AppConfigDocument> get copyWith =>
      __$$_AppConfigDocumentCopyWithImpl<_$_AppConfigDocument>(
          this, _$identity);
}

abstract class _AppConfigDocument extends AppConfigDocument {
  const factory _AppConfigDocument(
          {required final String minAppVersionForIos,
          required final String minAppVersionForAndroid,
          required final Map<String, Map<String, Object>> maintenanceMap}) =
      _$_AppConfigDocument;
  const _AppConfigDocument._() : super._();

  @override
  String get minAppVersionForIos;
  @override
  String get minAppVersionForAndroid;
  @override
  Map<String, Map<String, Object>> get maintenanceMap;
  @override
  @JsonKey(ignore: true)
  _$$_AppConfigDocumentCopyWith<_$_AppConfigDocument> get copyWith =>
      throw _privateConstructorUsedError;
}
