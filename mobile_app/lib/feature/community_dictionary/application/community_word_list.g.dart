// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'community_word_list.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$communityWordListHash() => r'4e782709b0f30ac44bb1560bdb3a2b5df028e419';

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

abstract class _$CommunityWordList
    extends BuildlessAutoDisposeAsyncNotifier<WordListState> {
  late final CommunityWordFilter filter;
  late final String query;

  FutureOr<WordListState> build(CommunityWordFilter filter, String query);
}

/// See also [CommunityWordList].
@ProviderFor(CommunityWordList)
const communityWordListProvider = CommunityWordListFamily();

/// See also [CommunityWordList].
class CommunityWordListFamily extends Family<AsyncValue<WordListState>> {
  /// See also [CommunityWordList].
  const CommunityWordListFamily();

  /// See also [CommunityWordList].
  CommunityWordListProvider call(CommunityWordFilter filter, String query) {
    return CommunityWordListProvider(filter, query);
  }

  @override
  CommunityWordListProvider getProviderOverride(
    covariant CommunityWordListProvider provider,
  ) {
    return call(provider.filter, provider.query);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'communityWordListProvider';
}

/// See also [CommunityWordList].
class CommunityWordListProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<CommunityWordList, WordListState> {
  /// See also [CommunityWordList].
  CommunityWordListProvider(CommunityWordFilter filter, String query)
    : this._internal(
        () => CommunityWordList()
          ..filter = filter
          ..query = query,
        from: communityWordListProvider,
        name: r'communityWordListProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$communityWordListHash,
        dependencies: CommunityWordListFamily._dependencies,
        allTransitiveDependencies:
            CommunityWordListFamily._allTransitiveDependencies,
        filter: filter,
        query: query,
      );

  CommunityWordListProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.filter,
    required this.query,
  }) : super.internal();

  final CommunityWordFilter filter;
  final String query;

  @override
  FutureOr<WordListState> runNotifierBuild(
    covariant CommunityWordList notifier,
  ) {
    return notifier.build(filter, query);
  }

  @override
  Override overrideWith(CommunityWordList Function() create) {
    return ProviderOverride(
      origin: this,
      override: CommunityWordListProvider._internal(
        () => create()
          ..filter = filter
          ..query = query,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        filter: filter,
        query: query,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<CommunityWordList, WordListState>
  createElement() {
    return _CommunityWordListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CommunityWordListProvider &&
        other.filter == filter &&
        other.query == query;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, filter.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin CommunityWordListRef
    on AutoDisposeAsyncNotifierProviderRef<WordListState> {
  /// The parameter `filter` of this provider.
  CommunityWordFilter get filter;

  /// The parameter `query` of this provider.
  String get query;
}

class _CommunityWordListProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          CommunityWordList,
          WordListState
        >
    with CommunityWordListRef {
  _CommunityWordListProviderElement(super.provider);

  @override
  CommunityWordFilter get filter =>
      (origin as CommunityWordListProvider).filter;
  @override
  String get query => (origin as CommunityWordListProvider).query;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
