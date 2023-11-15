// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'launch_url.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$launchURLHash() => r'5bb5ab81d6ef3c799c2e18651b9f99d2bd2dae1f';

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

/// See also [launchURL].
@ProviderFor(launchURL)
const launchURLProvider = LaunchURLFamily();

/// See also [launchURL].
class LaunchURLFamily extends Family<AsyncValue<void>> {
  /// See also [launchURL].
  const LaunchURLFamily();

  /// See also [launchURL].
  LaunchURLProvider call(
    String url,
  ) {
    return LaunchURLProvider(
      url,
    );
  }

  @override
  LaunchURLProvider getProviderOverride(
    covariant LaunchURLProvider provider,
  ) {
    return call(
      provider.url,
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
  String? get name => r'launchURLProvider';
}

/// See also [launchURL].
class LaunchURLProvider extends AutoDisposeFutureProvider<void> {
  /// See also [launchURL].
  LaunchURLProvider(
    String url,
  ) : this._internal(
          (ref) => launchURL(
            ref as LaunchURLRef,
            url,
          ),
          from: launchURLProvider,
          name: r'launchURLProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$launchURLHash,
          dependencies: LaunchURLFamily._dependencies,
          allTransitiveDependencies: LaunchURLFamily._allTransitiveDependencies,
          url: url,
        );

  LaunchURLProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.url,
  }) : super.internal();

  final String url;

  @override
  Override overrideWith(
    FutureOr<void> Function(LaunchURLRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: LaunchURLProvider._internal(
        (ref) => create(ref as LaunchURLRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        url: url,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _LaunchURLProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LaunchURLProvider && other.url == url;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, url.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin LaunchURLRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `url` of this provider.
  String get url;
}

class _LaunchURLProviderElement extends AutoDisposeFutureProviderElement<void>
    with LaunchURLRef {
  _LaunchURLProviderElement(super.provider);

  @override
  String get url => (origin as LaunchURLProvider).url;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
