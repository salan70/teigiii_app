// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entered_text_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$enteredTextNotifierHash() =>
    r'752d2bb7116a3c710c89962f81d0e2a624f356ad';

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

abstract class _$EnteredTextNotifier
    extends BuildlessAutoDisposeNotifier<String> {
  late final EnterField enterField;

  String build(
    EnterField enterField,
  );
}

/// See also [EnteredTextNotifier].
@ProviderFor(EnteredTextNotifier)
const enteredTextNotifierProvider = EnteredTextNotifierFamily();

/// See also [EnteredTextNotifier].
class EnteredTextNotifierFamily extends Family<String> {
  /// See also [EnteredTextNotifier].
  const EnteredTextNotifierFamily();

  /// See also [EnteredTextNotifier].
  EnteredTextNotifierProvider call(
    EnterField enterField,
  ) {
    return EnteredTextNotifierProvider(
      enterField,
    );
  }

  @override
  EnteredTextNotifierProvider getProviderOverride(
    covariant EnteredTextNotifierProvider provider,
  ) {
    return call(
      provider.enterField,
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
  String? get name => r'enteredTextNotifierProvider';
}

/// See also [EnteredTextNotifier].
class EnteredTextNotifierProvider
    extends AutoDisposeNotifierProviderImpl<EnteredTextNotifier, String> {
  /// See also [EnteredTextNotifier].
  EnteredTextNotifierProvider(
    EnterField enterField,
  ) : this._internal(
          () => EnteredTextNotifier()..enterField = enterField,
          from: enteredTextNotifierProvider,
          name: r'enteredTextNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$enteredTextNotifierHash,
          dependencies: EnteredTextNotifierFamily._dependencies,
          allTransitiveDependencies:
              EnteredTextNotifierFamily._allTransitiveDependencies,
          enterField: enterField,
        );

  EnteredTextNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.enterField,
  }) : super.internal();

  final EnterField enterField;

  @override
  String runNotifierBuild(
    covariant EnteredTextNotifier notifier,
  ) {
    return notifier.build(
      enterField,
    );
  }

  @override
  Override overrideWith(EnteredTextNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: EnteredTextNotifierProvider._internal(
        () => create()..enterField = enterField,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        enterField: enterField,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<EnteredTextNotifier, String>
      createElement() {
    return _EnteredTextNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is EnteredTextNotifierProvider &&
        other.enterField == enterField;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, enterField.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin EnteredTextNotifierRef on AutoDisposeNotifierProviderRef<String> {
  /// The parameter `enterField` of this provider.
  EnterField get enterField;
}

class _EnteredTextNotifierProviderElement
    extends AutoDisposeNotifierProviderElement<EnteredTextNotifier, String>
    with EnteredTextNotifierRef {
  _EnteredTextNotifierProviderElement(super.provider);

  @override
  EnterField get enterField =>
      (origin as EnteredTextNotifierProvider).enterField;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
