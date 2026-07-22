// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_dictionary_index_list_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userDictionaryIndexListStateNotifierHash() =>
    r'92b9510257a70533ac5e5c6346c69fcce76b48fa';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$UserDictionaryIndexListStateNotifier
    extends BuildlessAsyncNotifier<DictionaryIndexListState> {
  late final String targetUserId;

  FutureOr<DictionaryIndexListState> build(
    String targetUserId,
  );
}

/// See also [UserDictionaryIndexListStateNotifier].
@ProviderFor(UserDictionaryIndexListStateNotifier)
const userDictionaryIndexListStateNotifierProvider =
    UserDictionaryIndexListStateNotifierFamily();

/// See also [UserDictionaryIndexListStateNotifier].
class UserDictionaryIndexListStateNotifierFamily
    extends Family<AsyncValue<DictionaryIndexListState>> {
  /// See also [UserDictionaryIndexListStateNotifier].
  const UserDictionaryIndexListStateNotifierFamily();

  /// See also [UserDictionaryIndexListStateNotifier].
  UserDictionaryIndexListStateNotifierProvider call(
    String targetUserId,
  ) {
    return UserDictionaryIndexListStateNotifierProvider(
      targetUserId,
    );
  }

  @override
  UserDictionaryIndexListStateNotifierProvider getProviderOverride(
    covariant UserDictionaryIndexListStateNotifierProvider provider,
  ) {
    return call(
      provider.targetUserId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'userDictionaryIndexListStateNotifierProvider';
}

/// See also [UserDictionaryIndexListStateNotifier].
class UserDictionaryIndexListStateNotifierProvider
    extends AsyncNotifierProviderImpl<UserDictionaryIndexListStateNotifier,
        DictionaryIndexListState> {
  /// See also [UserDictionaryIndexListStateNotifier].
  UserDictionaryIndexListStateNotifierProvider(
    String targetUserId,
  ) : this._internal(
          () => UserDictionaryIndexListStateNotifier()
            ..targetUserId = targetUserId,
          from: userDictionaryIndexListStateNotifierProvider,
          name: r'userDictionaryIndexListStateNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$userDictionaryIndexListStateNotifierHash,
          dependencies:
              UserDictionaryIndexListStateNotifierFamily._dependencies,
          allTransitiveDependencies: UserDictionaryIndexListStateNotifierFamily
              ._allTransitiveDependencies,
          targetUserId: targetUserId,
        );

  UserDictionaryIndexListStateNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.targetUserId,
  }) : super.internal();

  final String targetUserId;

  @override
  FutureOr<DictionaryIndexListState> runNotifierBuild(
    covariant UserDictionaryIndexListStateNotifier notifier,
  ) {
    return notifier.build(
      targetUserId,
    );
  }

  @override
  Override overrideWith(
      UserDictionaryIndexListStateNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: UserDictionaryIndexListStateNotifierProvider._internal(
        () => create()..targetUserId = targetUserId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        targetUserId: targetUserId,
      ),
    );
  }

  @override
  AsyncNotifierProviderElement<UserDictionaryIndexListStateNotifier,
      DictionaryIndexListState> createElement() {
    return _UserDictionaryIndexListStateNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserDictionaryIndexListStateNotifierProvider &&
        other.targetUserId == targetUserId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, targetUserId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin UserDictionaryIndexListStateNotifierRef
    on AsyncNotifierProviderRef<DictionaryIndexListState> {
  /// The parameter `targetUserId` of this provider.
  String get targetUserId;
}

class _UserDictionaryIndexListStateNotifierProviderElement
    extends AsyncNotifierProviderElement<UserDictionaryIndexListStateNotifier,
        DictionaryIndexListState> with UserDictionaryIndexListStateNotifierRef {
  _UserDictionaryIndexListStateNotifierProviderElement(super.provider);

  @override
  String get targetUserId =>
      (origin as UserDictionaryIndexListStateNotifierProvider).targetUserId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
