// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'discover_feed_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$DiscoverFeedEntry {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Definition definition) definition,
    required TResult Function(RegisteredWordActivity activity) wordRegistered,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Definition definition)? definition,
    TResult? Function(RegisteredWordActivity activity)? wordRegistered,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Definition definition)? definition,
    TResult Function(RegisteredWordActivity activity)? wordRegistered,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DiscoverFeedDefinitionEntry value) definition,
    required TResult Function(DiscoverFeedWordRegisteredEntry value)
    wordRegistered,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DiscoverFeedDefinitionEntry value)? definition,
    TResult? Function(DiscoverFeedWordRegisteredEntry value)? wordRegistered,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DiscoverFeedDefinitionEntry value)? definition,
    TResult Function(DiscoverFeedWordRegisteredEntry value)? wordRegistered,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DiscoverFeedEntryCopyWith<$Res> {
  factory $DiscoverFeedEntryCopyWith(
    DiscoverFeedEntry value,
    $Res Function(DiscoverFeedEntry) then,
  ) = _$DiscoverFeedEntryCopyWithImpl<$Res, DiscoverFeedEntry>;
}

/// @nodoc
class _$DiscoverFeedEntryCopyWithImpl<$Res, $Val extends DiscoverFeedEntry>
    implements $DiscoverFeedEntryCopyWith<$Res> {
  _$DiscoverFeedEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DiscoverFeedEntry
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$DiscoverFeedDefinitionEntryImplCopyWith<$Res> {
  factory _$$DiscoverFeedDefinitionEntryImplCopyWith(
    _$DiscoverFeedDefinitionEntryImpl value,
    $Res Function(_$DiscoverFeedDefinitionEntryImpl) then,
  ) = __$$DiscoverFeedDefinitionEntryImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Definition definition});

  $DefinitionCopyWith<$Res> get definition;
}

/// @nodoc
class __$$DiscoverFeedDefinitionEntryImplCopyWithImpl<$Res>
    extends
        _$DiscoverFeedEntryCopyWithImpl<$Res, _$DiscoverFeedDefinitionEntryImpl>
    implements _$$DiscoverFeedDefinitionEntryImplCopyWith<$Res> {
  __$$DiscoverFeedDefinitionEntryImplCopyWithImpl(
    _$DiscoverFeedDefinitionEntryImpl _value,
    $Res Function(_$DiscoverFeedDefinitionEntryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DiscoverFeedEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? definition = null}) {
    return _then(
      _$DiscoverFeedDefinitionEntryImpl(
        null == definition
            ? _value.definition
            : definition // ignore: cast_nullable_to_non_nullable
                  as Definition,
      ),
    );
  }

  /// Create a copy of DiscoverFeedEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DefinitionCopyWith<$Res> get definition {
    return $DefinitionCopyWith<$Res>(_value.definition, (value) {
      return _then(_value.copyWith(definition: value));
    });
  }
}

/// @nodoc

class _$DiscoverFeedDefinitionEntryImpl implements DiscoverFeedDefinitionEntry {
  const _$DiscoverFeedDefinitionEntryImpl(this.definition);

  @override
  final Definition definition;

  @override
  String toString() {
    return 'DiscoverFeedEntry.definition(definition: $definition)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DiscoverFeedDefinitionEntryImpl &&
            (identical(other.definition, definition) ||
                other.definition == definition));
  }

  @override
  int get hashCode => Object.hash(runtimeType, definition);

  /// Create a copy of DiscoverFeedEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DiscoverFeedDefinitionEntryImplCopyWith<_$DiscoverFeedDefinitionEntryImpl>
  get copyWith =>
      __$$DiscoverFeedDefinitionEntryImplCopyWithImpl<
        _$DiscoverFeedDefinitionEntryImpl
      >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Definition definition) definition,
    required TResult Function(RegisteredWordActivity activity) wordRegistered,
  }) {
    return definition(this.definition);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Definition definition)? definition,
    TResult? Function(RegisteredWordActivity activity)? wordRegistered,
  }) {
    return definition?.call(this.definition);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Definition definition)? definition,
    TResult Function(RegisteredWordActivity activity)? wordRegistered,
    required TResult orElse(),
  }) {
    if (definition != null) {
      return definition(this.definition);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DiscoverFeedDefinitionEntry value) definition,
    required TResult Function(DiscoverFeedWordRegisteredEntry value)
    wordRegistered,
  }) {
    return definition(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DiscoverFeedDefinitionEntry value)? definition,
    TResult? Function(DiscoverFeedWordRegisteredEntry value)? wordRegistered,
  }) {
    return definition?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DiscoverFeedDefinitionEntry value)? definition,
    TResult Function(DiscoverFeedWordRegisteredEntry value)? wordRegistered,
    required TResult orElse(),
  }) {
    if (definition != null) {
      return definition(this);
    }
    return orElse();
  }
}

abstract class DiscoverFeedDefinitionEntry implements DiscoverFeedEntry {
  const factory DiscoverFeedDefinitionEntry(final Definition definition) =
      _$DiscoverFeedDefinitionEntryImpl;

  Definition get definition;

  /// Create a copy of DiscoverFeedEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DiscoverFeedDefinitionEntryImplCopyWith<_$DiscoverFeedDefinitionEntryImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DiscoverFeedWordRegisteredEntryImplCopyWith<$Res> {
  factory _$$DiscoverFeedWordRegisteredEntryImplCopyWith(
    _$DiscoverFeedWordRegisteredEntryImpl value,
    $Res Function(_$DiscoverFeedWordRegisteredEntryImpl) then,
  ) = __$$DiscoverFeedWordRegisteredEntryImplCopyWithImpl<$Res>;
  @useResult
  $Res call({RegisteredWordActivity activity});

  $RegisteredWordActivityCopyWith<$Res> get activity;
}

/// @nodoc
class __$$DiscoverFeedWordRegisteredEntryImplCopyWithImpl<$Res>
    extends
        _$DiscoverFeedEntryCopyWithImpl<
          $Res,
          _$DiscoverFeedWordRegisteredEntryImpl
        >
    implements _$$DiscoverFeedWordRegisteredEntryImplCopyWith<$Res> {
  __$$DiscoverFeedWordRegisteredEntryImplCopyWithImpl(
    _$DiscoverFeedWordRegisteredEntryImpl _value,
    $Res Function(_$DiscoverFeedWordRegisteredEntryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DiscoverFeedEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? activity = null}) {
    return _then(
      _$DiscoverFeedWordRegisteredEntryImpl(
        null == activity
            ? _value.activity
            : activity // ignore: cast_nullable_to_non_nullable
                  as RegisteredWordActivity,
      ),
    );
  }

  /// Create a copy of DiscoverFeedEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RegisteredWordActivityCopyWith<$Res> get activity {
    return $RegisteredWordActivityCopyWith<$Res>(_value.activity, (value) {
      return _then(_value.copyWith(activity: value));
    });
  }
}

/// @nodoc

class _$DiscoverFeedWordRegisteredEntryImpl
    implements DiscoverFeedWordRegisteredEntry {
  const _$DiscoverFeedWordRegisteredEntryImpl(this.activity);

  @override
  final RegisteredWordActivity activity;

  @override
  String toString() {
    return 'DiscoverFeedEntry.wordRegistered(activity: $activity)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DiscoverFeedWordRegisteredEntryImpl &&
            (identical(other.activity, activity) ||
                other.activity == activity));
  }

  @override
  int get hashCode => Object.hash(runtimeType, activity);

  /// Create a copy of DiscoverFeedEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DiscoverFeedWordRegisteredEntryImplCopyWith<
    _$DiscoverFeedWordRegisteredEntryImpl
  >
  get copyWith =>
      __$$DiscoverFeedWordRegisteredEntryImplCopyWithImpl<
        _$DiscoverFeedWordRegisteredEntryImpl
      >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Definition definition) definition,
    required TResult Function(RegisteredWordActivity activity) wordRegistered,
  }) {
    return wordRegistered(activity);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Definition definition)? definition,
    TResult? Function(RegisteredWordActivity activity)? wordRegistered,
  }) {
    return wordRegistered?.call(activity);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Definition definition)? definition,
    TResult Function(RegisteredWordActivity activity)? wordRegistered,
    required TResult orElse(),
  }) {
    if (wordRegistered != null) {
      return wordRegistered(activity);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DiscoverFeedDefinitionEntry value) definition,
    required TResult Function(DiscoverFeedWordRegisteredEntry value)
    wordRegistered,
  }) {
    return wordRegistered(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DiscoverFeedDefinitionEntry value)? definition,
    TResult? Function(DiscoverFeedWordRegisteredEntry value)? wordRegistered,
  }) {
    return wordRegistered?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DiscoverFeedDefinitionEntry value)? definition,
    TResult Function(DiscoverFeedWordRegisteredEntry value)? wordRegistered,
    required TResult orElse(),
  }) {
    if (wordRegistered != null) {
      return wordRegistered(this);
    }
    return orElse();
  }
}

abstract class DiscoverFeedWordRegisteredEntry implements DiscoverFeedEntry {
  const factory DiscoverFeedWordRegisteredEntry(
    final RegisteredWordActivity activity,
  ) = _$DiscoverFeedWordRegisteredEntryImpl;

  RegisteredWordActivity get activity;

  /// Create a copy of DiscoverFeedEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DiscoverFeedWordRegisteredEntryImplCopyWith<
    _$DiscoverFeedWordRegisteredEntryImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}
