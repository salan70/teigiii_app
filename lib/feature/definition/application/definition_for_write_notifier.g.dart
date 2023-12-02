// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'definition_for_write_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$definitionForWriteNotifierHash() =>
    r'da69d1930459572636c676efe394f5480f0b6dd0';

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
  late final DefinitionForWrite? definitionForWrite;

  FutureOr<DefinitionForWrite> build(
    DefinitionForWrite? definitionForWrite,
  );
}

/// 更新時などTextField等に初期表示したい値がある場合、
/// [definitionForWrite] として渡す。
///
/// Copied from [DefinitionForWriteNotifier].
@ProviderFor(DefinitionForWriteNotifier)
const definitionForWriteNotifierProvider = DefinitionForWriteNotifierFamily();

/// 更新時などTextField等に初期表示したい値がある場合、
/// [definitionForWrite] として渡す。
///
/// Copied from [DefinitionForWriteNotifier].
class DefinitionForWriteNotifierFamily
    extends Family<AsyncValue<DefinitionForWrite>> {
  /// 更新時などTextField等に初期表示したい値がある場合、
  /// [definitionForWrite] として渡す。
  ///
  /// Copied from [DefinitionForWriteNotifier].
  const DefinitionForWriteNotifierFamily();

  /// 更新時などTextField等に初期表示したい値がある場合、
  /// [definitionForWrite] として渡す。
  ///
  /// Copied from [DefinitionForWriteNotifier].
  DefinitionForWriteNotifierProvider call(
    DefinitionForWrite? definitionForWrite,
  ) {
    return DefinitionForWriteNotifierProvider(
      definitionForWrite,
    );
  }

  @override
  DefinitionForWriteNotifierProvider getProviderOverride(
    covariant DefinitionForWriteNotifierProvider provider,
  ) {
    return call(
      provider.definitionForWrite,
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

/// 更新時などTextField等に初期表示したい値がある場合、
/// [definitionForWrite] として渡す。
///
/// Copied from [DefinitionForWriteNotifier].
class DefinitionForWriteNotifierProvider
    extends AutoDisposeAsyncNotifierProviderImpl<DefinitionForWriteNotifier,
        DefinitionForWrite> {
  /// 更新時などTextField等に初期表示したい値がある場合、
  /// [definitionForWrite] として渡す。
  ///
  /// Copied from [DefinitionForWriteNotifier].
  DefinitionForWriteNotifierProvider(
    DefinitionForWrite? definitionForWrite,
  ) : this._internal(
          () => DefinitionForWriteNotifier()
            ..definitionForWrite = definitionForWrite,
          from: definitionForWriteNotifierProvider,
          name: r'definitionForWriteNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$definitionForWriteNotifierHash,
          dependencies: DefinitionForWriteNotifierFamily._dependencies,
          allTransitiveDependencies:
              DefinitionForWriteNotifierFamily._allTransitiveDependencies,
          definitionForWrite: definitionForWrite,
        );

  DefinitionForWriteNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.definitionForWrite,
  }) : super.internal();

  final DefinitionForWrite? definitionForWrite;

  @override
  FutureOr<DefinitionForWrite> runNotifierBuild(
    covariant DefinitionForWriteNotifier notifier,
  ) {
    return notifier.build(
      definitionForWrite,
    );
  }

  @override
  Override overrideWith(DefinitionForWriteNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: DefinitionForWriteNotifierProvider._internal(
        () => create()..definitionForWrite = definitionForWrite,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        definitionForWrite: definitionForWrite,
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
        other.definitionForWrite == definitionForWrite;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, definitionForWrite.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin DefinitionForWriteNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<DefinitionForWrite> {
  /// The parameter `definitionForWrite` of this provider.
  DefinitionForWrite? get definitionForWrite;
}

class _DefinitionForWriteNotifierProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<DefinitionForWriteNotifier,
        DefinitionForWrite> with DefinitionForWriteNotifierRef {
  _DefinitionForWriteNotifierProviderElement(super.provider);

  @override
  DefinitionForWrite? get definitionForWrite =>
      (origin as DefinitionForWriteNotifierProvider).definitionForWrite;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
