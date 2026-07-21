// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'public_dictionary_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$publicDictionaryNotifierHash() =>
    r'b6c9c414d2af03b35eca7d5bca5deb0666d6466a';

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

abstract class _$PublicDictionaryNotifier
    extends BuildlessAsyncNotifier<PublicDictionaryState> {
  late final String userId;

  FutureOr<PublicDictionaryState> build(
    String userId,
  );
}

/// See also [PublicDictionaryNotifier].
@ProviderFor(PublicDictionaryNotifier)
const publicDictionaryNotifierProvider = PublicDictionaryNotifierFamily();

/// See also [PublicDictionaryNotifier].
class PublicDictionaryNotifierFamily
    extends Family<AsyncValue<PublicDictionaryState>> {
  /// See also [PublicDictionaryNotifier].
  const PublicDictionaryNotifierFamily();

  /// See also [PublicDictionaryNotifier].
  PublicDictionaryNotifierProvider call(
    String userId,
  ) {
    return PublicDictionaryNotifierProvider(
      userId,
    );
  }

  @override
  PublicDictionaryNotifierProvider getProviderOverride(
    covariant PublicDictionaryNotifierProvider provider,
  ) {
    return call(
      provider.userId,
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
  String? get name => r'publicDictionaryNotifierProvider';
}

/// See also [PublicDictionaryNotifier].
class PublicDictionaryNotifierProvider extends AsyncNotifierProviderImpl<
    PublicDictionaryNotifier, PublicDictionaryState> {
  /// See also [PublicDictionaryNotifier].
  PublicDictionaryNotifierProvider(
    String userId,
  ) : this._internal(
          () => PublicDictionaryNotifier()..userId = userId,
          from: publicDictionaryNotifierProvider,
          name: r'publicDictionaryNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$publicDictionaryNotifierHash,
          dependencies: PublicDictionaryNotifierFamily._dependencies,
          allTransitiveDependencies:
              PublicDictionaryNotifierFamily._allTransitiveDependencies,
          userId: userId,
        );

  PublicDictionaryNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final String userId;

  @override
  FutureOr<PublicDictionaryState> runNotifierBuild(
    covariant PublicDictionaryNotifier notifier,
  ) {
    return notifier.build(
      userId,
    );
  }

  @override
  Override overrideWith(PublicDictionaryNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: PublicDictionaryNotifierProvider._internal(
        () => create()..userId = userId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  AsyncNotifierProviderElement<PublicDictionaryNotifier, PublicDictionaryState>
      createElement() {
    return _PublicDictionaryNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PublicDictionaryNotifierProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin PublicDictionaryNotifierRef
    on AsyncNotifierProviderRef<PublicDictionaryState> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _PublicDictionaryNotifierProviderElement
    extends AsyncNotifierProviderElement<PublicDictionaryNotifier,
        PublicDictionaryState> with PublicDictionaryNotifierRef {
  _PublicDictionaryNotifierProviderElement(super.provider);

  @override
  String get userId => (origin as PublicDictionaryNotifierProvider).userId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
