// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word_list_state_by_initial.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$wordListStateByInitialNotifierHash() =>
    r'e1f46a928ff06f6276dcdc2d44a12786d45891ab';

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

abstract class _$WordListStateByInitialNotifier
    extends BuildlessAsyncNotifier<WordListState> {
  late final String initial;

  FutureOr<WordListState> build(
    String initial,
  );
}

/// See also [WordListStateByInitialNotifier].
@ProviderFor(WordListStateByInitialNotifier)
const wordListStateByInitialNotifierProvider =
    WordListStateByInitialNotifierFamily();

/// See also [WordListStateByInitialNotifier].
class WordListStateByInitialNotifierFamily
    extends Family<AsyncValue<WordListState>> {
  /// See also [WordListStateByInitialNotifier].
  const WordListStateByInitialNotifierFamily();

  /// See also [WordListStateByInitialNotifier].
  WordListStateByInitialNotifierProvider call(
    String initial,
  ) {
    return WordListStateByInitialNotifierProvider(
      initial,
    );
  }

  @override
  WordListStateByInitialNotifierProvider getProviderOverride(
    covariant WordListStateByInitialNotifierProvider provider,
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
  String? get name => r'wordListStateByInitialNotifierProvider';
}

/// See also [WordListStateByInitialNotifier].
class WordListStateByInitialNotifierProvider extends AsyncNotifierProviderImpl<
    WordListStateByInitialNotifier, WordListState> {
  /// See also [WordListStateByInitialNotifier].
  WordListStateByInitialNotifierProvider(
    String initial,
  ) : this._internal(
          () => WordListStateByInitialNotifier()..initial = initial,
          from: wordListStateByInitialNotifierProvider,
          name: r'wordListStateByInitialNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$wordListStateByInitialNotifierHash,
          dependencies: WordListStateByInitialNotifierFamily._dependencies,
          allTransitiveDependencies:
              WordListStateByInitialNotifierFamily._allTransitiveDependencies,
          initial: initial,
        );

  WordListStateByInitialNotifierProvider._internal(
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
    covariant WordListStateByInitialNotifier notifier,
  ) {
    return notifier.build(
      initial,
    );
  }

  @override
  Override overrideWith(WordListStateByInitialNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: WordListStateByInitialNotifierProvider._internal(
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
  AsyncNotifierProviderElement<WordListStateByInitialNotifier, WordListState>
      createElement() {
    return _WordListStateByInitialNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WordListStateByInitialNotifierProvider &&
        other.initial == initial;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, initial.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin WordListStateByInitialNotifierRef
    on AsyncNotifierProviderRef<WordListState> {
  /// The parameter `initial` of this provider.
  String get initial;
}

class _WordListStateByInitialNotifierProviderElement
    extends AsyncNotifierProviderElement<WordListStateByInitialNotifier,
        WordListState> with WordListStateByInitialNotifierRef {
  _WordListStateByInitialNotifierProviderElement(super.provider);

  @override
  String get initial =>
      (origin as WordListStateByInitialNotifierProvider).initial;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
