// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'definition_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$definitionHash() => r'b3c57adef88b13219686d07044f725900fa8d7dd';

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

/// See also [definition].
@ProviderFor(definition)
const definitionProvider = DefinitionFamily();

/// See also [definition].
class DefinitionFamily extends Family<AsyncValue<Definition>> {
  /// See also [definition].
  const DefinitionFamily();

  /// See also [definition].
  DefinitionProvider call(
    String definitionId,
  ) {
    return DefinitionProvider(
      definitionId,
    );
  }

  @override
  DefinitionProvider getProviderOverride(
    covariant DefinitionProvider provider,
  ) {
    return call(
      provider.definitionId,
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
  String? get name => r'definitionProvider';
}

/// See also [definition].
class DefinitionProvider extends FutureProvider<Definition> {
  /// See also [definition].
  DefinitionProvider(
    String definitionId,
  ) : this._internal(
          (ref) => definition(
            ref as DefinitionRef,
            definitionId,
          ),
          from: definitionProvider,
          name: r'definitionProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$definitionHash,
          dependencies: DefinitionFamily._dependencies,
          allTransitiveDependencies:
              DefinitionFamily._allTransitiveDependencies,
          definitionId: definitionId,
        );

  DefinitionProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.definitionId,
  }) : super.internal();

  final String definitionId;

  @override
  Override overrideWith(
    FutureOr<Definition> Function(DefinitionRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DefinitionProvider._internal(
        (ref) => create(ref as DefinitionRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        definitionId: definitionId,
      ),
    );
  }

  @override
  FutureProviderElement<Definition> createElement() {
    return _DefinitionProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DefinitionProvider && other.definitionId == definitionId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, definitionId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin DefinitionRef on FutureProviderRef<Definition> {
  /// The parameter `definitionId` of this provider.
  String get definitionId;
}

class _DefinitionProviderElement extends FutureProviderElement<Definition>
    with DefinitionRef {
  _DefinitionProviderElement(super.provider);

  @override
  String get definitionId => (origin as DefinitionProvider).definitionId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
