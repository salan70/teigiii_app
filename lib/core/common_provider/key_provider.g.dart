// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'key_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$globalKeyHash() => r'c9b683949cb6cc7d2b9ae4df52a749fb1646b81e';

/// See also [globalKey].
@ProviderFor(globalKey)
final globalKeyProvider =
    AutoDisposeProvider<GlobalKey<State<StatefulWidget>>>.internal(
  globalKey,
  name: r'globalKeyProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$globalKeyHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GlobalKeyRef = AutoDisposeProviderRef<GlobalKey<State<StatefulWidget>>>;
String _$scaffoldMessengerKeyHash() =>
    r'70d707a46145cc33fd390fc8b81001defdec29ed';

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

/// See also [scaffoldMessengerKey].
@ProviderFor(scaffoldMessengerKey)
const scaffoldMessengerKeyProvider = ScaffoldMessengerKeyFamily();

/// See also [scaffoldMessengerKey].
class ScaffoldMessengerKeyFamily
    extends Family<GlobalKey<ScaffoldMessengerState>> {
  /// See also [scaffoldMessengerKey].
  const ScaffoldMessengerKeyFamily();

  /// See also [scaffoldMessengerKey].
  ScaffoldMessengerKeyProvider call(
    ScaffoldMessengerType type,
  ) {
    return ScaffoldMessengerKeyProvider(
      type,
    );
  }

  @override
  ScaffoldMessengerKeyProvider getProviderOverride(
    covariant ScaffoldMessengerKeyProvider provider,
  ) {
    return call(
      provider.type,
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
  String? get name => r'scaffoldMessengerKeyProvider';
}

/// See also [scaffoldMessengerKey].
class ScaffoldMessengerKeyProvider
    extends AutoDisposeProvider<GlobalKey<ScaffoldMessengerState>> {
  /// See also [scaffoldMessengerKey].
  ScaffoldMessengerKeyProvider(
    ScaffoldMessengerType type,
  ) : this._internal(
          (ref) => scaffoldMessengerKey(
            ref as ScaffoldMessengerKeyRef,
            type,
          ),
          from: scaffoldMessengerKeyProvider,
          name: r'scaffoldMessengerKeyProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$scaffoldMessengerKeyHash,
          dependencies: ScaffoldMessengerKeyFamily._dependencies,
          allTransitiveDependencies:
              ScaffoldMessengerKeyFamily._allTransitiveDependencies,
          type: type,
        );

  ScaffoldMessengerKeyProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.type,
  }) : super.internal();

  final ScaffoldMessengerType type;

  @override
  Override overrideWith(
    GlobalKey<ScaffoldMessengerState> Function(ScaffoldMessengerKeyRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ScaffoldMessengerKeyProvider._internal(
        (ref) => create(ref as ScaffoldMessengerKeyRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        type: type,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<GlobalKey<ScaffoldMessengerState>>
      createElement() {
    return _ScaffoldMessengerKeyProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ScaffoldMessengerKeyProvider && other.type == type;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, type.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ScaffoldMessengerKeyRef
    on AutoDisposeProviderRef<GlobalKey<ScaffoldMessengerState>> {
  /// The parameter `type` of this provider.
  ScaffoldMessengerType get type;
}

class _ScaffoldMessengerKeyProviderElement
    extends AutoDisposeProviderElement<GlobalKey<ScaffoldMessengerState>>
    with ScaffoldMessengerKeyRef {
  _ScaffoldMessengerKeyProviderElement(super.provider);

  @override
  ScaffoldMessengerType get type =>
      (origin as ScaffoldMessengerKeyProvider).type;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
