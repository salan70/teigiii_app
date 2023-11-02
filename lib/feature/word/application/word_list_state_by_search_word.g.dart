// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word_list_state_by_search_word.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$wordListStateBySearchWordNotifierHash() =>
    r'2271f264ad989481a11b68431ac8e57f52e6961b';

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

abstract class _$WordListStateBySearchWordNotifier
    extends BuildlessAutoDisposeAsyncNotifier<WordListState> {
  late final String searchWord;

  FutureOr<WordListState> build(
    String searchWord,
  );
}

/// See also [WordListStateBySearchWordNotifier].
@ProviderFor(WordListStateBySearchWordNotifier)
const wordListStateBySearchWordNotifierProvider =
    WordListStateBySearchWordNotifierFamily();

/// See also [WordListStateBySearchWordNotifier].
class WordListStateBySearchWordNotifierFamily
    extends Family<AsyncValue<WordListState>> {
  /// See also [WordListStateBySearchWordNotifier].
  const WordListStateBySearchWordNotifierFamily();

  /// See also [WordListStateBySearchWordNotifier].
  WordListStateBySearchWordNotifierProvider call(
    String searchWord,
  ) {
    return WordListStateBySearchWordNotifierProvider(
      searchWord,
    );
  }

  @override
  WordListStateBySearchWordNotifierProvider getProviderOverride(
    covariant WordListStateBySearchWordNotifierProvider provider,
  ) {
    return call(
      provider.searchWord,
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
  String? get name => r'wordListStateBySearchWordNotifierProvider';
}

/// See also [WordListStateBySearchWordNotifier].
class WordListStateBySearchWordNotifierProvider
    extends AutoDisposeAsyncNotifierProviderImpl<
        WordListStateBySearchWordNotifier, WordListState> {
  /// See also [WordListStateBySearchWordNotifier].
  WordListStateBySearchWordNotifierProvider(
    String searchWord,
  ) : this._internal(
          () => WordListStateBySearchWordNotifier()..searchWord = searchWord,
          from: wordListStateBySearchWordNotifierProvider,
          name: r'wordListStateBySearchWordNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$wordListStateBySearchWordNotifierHash,
          dependencies: WordListStateBySearchWordNotifierFamily._dependencies,
          allTransitiveDependencies: WordListStateBySearchWordNotifierFamily
              ._allTransitiveDependencies,
          searchWord: searchWord,
        );

  WordListStateBySearchWordNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.searchWord,
  }) : super.internal();

  final String searchWord;

  @override
  FutureOr<WordListState> runNotifierBuild(
    covariant WordListStateBySearchWordNotifier notifier,
  ) {
    return notifier.build(
      searchWord,
    );
  }

  @override
  Override overrideWith(WordListStateBySearchWordNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: WordListStateBySearchWordNotifierProvider._internal(
        () => create()..searchWord = searchWord,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        searchWord: searchWord,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<WordListStateBySearchWordNotifier,
      WordListState> createElement() {
    return _WordListStateBySearchWordNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WordListStateBySearchWordNotifierProvider &&
        other.searchWord == searchWord;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, searchWord.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin WordListStateBySearchWordNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<WordListState> {
  /// The parameter `searchWord` of this provider.
  String get searchWord;
}

class _WordListStateBySearchWordNotifierProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<
        WordListStateBySearchWordNotifier,
        WordListState> with WordListStateBySearchWordNotifierRef {
  _WordListStateBySearchWordNotifierProviderElement(super.provider);

  @override
  String get searchWord =>
      (origin as WordListStateBySearchWordNotifierProvider).searchWord;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
