// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word_list_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$wordListStateNotifierHash() =>
    r'62337eeaea9e7ec5c05188a87a3b913133093857';

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

abstract class _$WordListStateNotifier
    extends BuildlessAutoDisposeAsyncNotifier<WordListState> {
  late final String initial;

  FutureOr<WordListState> build(
    String initial,
  );
}

/// See also [WordListStateNotifier].
@ProviderFor(WordListStateNotifier)
const wordListStateNotifierProvider = WordListStateNotifierFamily();

/// See also [WordListStateNotifier].
class WordListStateNotifierFamily extends Family<AsyncValue<WordListState>> {
  /// See also [WordListStateNotifier].
  const WordListStateNotifierFamily();

  /// See also [WordListStateNotifier].
  WordListStateNotifierProvider call(
    String initial,
  ) {
    return WordListStateNotifierProvider(
      initial,
    );
  }

  @override
  WordListStateNotifierProvider getProviderOverride(
    covariant WordListStateNotifierProvider provider,
  ) {
    return call(
      provider.initial,
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
  String? get name => r'wordListStateNotifierProvider';
}

/// See also [WordListStateNotifier].
class WordListStateNotifierProvider
    extends AutoDisposeAsyncNotifierProviderImpl<WordListStateNotifier,
        WordListState> {
  /// See also [WordListStateNotifier].
  WordListStateNotifierProvider(
    String initial,
  ) : this._internal(
          () => WordListStateNotifier()..initial = initial,
          from: wordListStateNotifierProvider,
          name: r'wordListStateNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$wordListStateNotifierHash,
          dependencies: WordListStateNotifierFamily._dependencies,
          allTransitiveDependencies:
              WordListStateNotifierFamily._allTransitiveDependencies,
          initial: initial,
        );

  WordListStateNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.initial,
  }) : super.internal();

  final String initial;

  @override
  FutureOr<WordListState> runNotifierBuild(
    covariant WordListStateNotifier notifier,
  ) {
    return notifier.build(
      initial,
    );
  }

  @override
  Override overrideWith(WordListStateNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: WordListStateNotifierProvider._internal(
        () => create()..initial = initial,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        initial: initial,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<WordListStateNotifier, WordListState>
      createElement() {
    return _WordListStateNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WordListStateNotifierProvider && other.initial == initial;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, initial.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin WordListStateNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<WordListState> {
  /// The parameter `initial` of this provider.
  String get initial;
}

class _WordListStateNotifierProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<WordListStateNotifier,
        WordListState> with WordListStateNotifierRef {
  _WordListStateNotifierProviderElement(super.provider);

  @override
  String get initial => (origin as WordListStateNotifierProvider).initial;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
