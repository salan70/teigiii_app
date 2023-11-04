// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'definition_for_write_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$definitionForWriteNotifierHash() =>
    r'6177d583796cb7cee3b9ab97f386f9ac2a87e04c';

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

abstract class _$DefinitionForWriteNotifier
    extends BuildlessAutoDisposeAsyncNotifier<DefinitionForWrite> {
  late final String? definitionId;

  FutureOr<DefinitionForWrite> build(
    String? definitionId,
  );
}

/// See also [DefinitionForWriteNotifier].
@ProviderFor(DefinitionForWriteNotifier)
const definitionForWriteNotifierProvider = DefinitionForWriteNotifierFamily();

/// See also [DefinitionForWriteNotifier].
class DefinitionForWriteNotifierFamily
    extends Family<AsyncValue<DefinitionForWrite>> {
  /// See also [DefinitionForWriteNotifier].
  const DefinitionForWriteNotifierFamily();

  /// See also [DefinitionForWriteNotifier].
  DefinitionForWriteNotifierProvider call(
    String? definitionId,
  ) {
    return DefinitionForWriteNotifierProvider(
      definitionId,
    );
  }

  @override
  DefinitionForWriteNotifierProvider getProviderOverride(
    covariant DefinitionForWriteNotifierProvider provider,
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
  String? get name => r'definitionForWriteNotifierProvider';
}

/// See also [DefinitionForWriteNotifier].
class DefinitionForWriteNotifierProvider
    extends AutoDisposeAsyncNotifierProviderImpl<DefinitionForWriteNotifier,
        DefinitionForWrite> {
  /// See also [DefinitionForWriteNotifier].
  DefinitionForWriteNotifierProvider(
    String? definitionId,
  ) : this._internal(
          () => DefinitionForWriteNotifier()..definitionId = definitionId,
          from: definitionForWriteNotifierProvider,
          name: r'definitionForWriteNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$definitionForWriteNotifierHash,
          dependencies: DefinitionForWriteNotifierFamily._dependencies,
          allTransitiveDependencies:
              DefinitionForWriteNotifierFamily._allTransitiveDependencies,
          definitionId: definitionId,
        );

  DefinitionForWriteNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.definitionId,
  }) : super.internal();

  final String? definitionId;

  @override
  FutureOr<DefinitionForWrite> runNotifierBuild(
    covariant DefinitionForWriteNotifier notifier,
  ) {
    return notifier.build(
      definitionId,
    );
  }

  @override
  Override overrideWith(DefinitionForWriteNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: DefinitionForWriteNotifierProvider._internal(
        () => create()..definitionId = definitionId,
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
  AutoDisposeAsyncNotifierProviderElement<DefinitionForWriteNotifier,
      DefinitionForWrite> createElement() {
    return _DefinitionForWriteNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DefinitionForWriteNotifierProvider &&
        other.definitionId == definitionId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, definitionId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin DefinitionForWriteNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<DefinitionForWrite> {
  /// The parameter `definitionId` of this provider.
  String? get definitionId;
}

class _DefinitionForWriteNotifierProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<DefinitionForWriteNotifier,
        DefinitionForWrite> with DefinitionForWriteNotifierRef {
  _DefinitionForWriteNotifierProviderElement(super.provider);

  @override
  String? get definitionId =>
      (origin as DefinitionForWriteNotifierProvider).definitionId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
