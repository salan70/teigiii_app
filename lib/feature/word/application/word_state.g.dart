// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$wordHash() => r'c1da987087d1c757d9c7f9dd91bec61de24cc5cf';

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

/// See also [word].
@ProviderFor(word)
const wordProvider = WordFamily();

/// See also [word].
class WordFamily extends Family<AsyncValue<Word>> {
  /// See also [word].
  const WordFamily();

  /// See also [word].
  WordProvider call(
    String wordId,
  ) {
    return WordProvider(
      wordId,
    );
  }

  @override
  WordProvider getProviderOverride(
    covariant WordProvider provider,
  ) {
    return call(
      provider.wordId,
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
  String? get name => r'wordProvider';
}

/// See also [word].
class WordProvider extends FutureProvider<Word> {
  /// See also [word].
  WordProvider(
    String wordId,
  ) : this._internal(
          (ref) => word(
            ref as WordRef,
            wordId,
          ),
          from: wordProvider,
          name: r'wordProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product') ? null : _$wordHash,
          dependencies: WordFamily._dependencies,
          allTransitiveDependencies: WordFamily._allTransitiveDependencies,
          wordId: wordId,
        );

  WordProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.wordId,
  }) : super.internal();

  final String wordId;

  @override
  Override overrideWith(
    FutureOr<Word> Function(WordRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: WordProvider._internal(
        (ref) => create(ref as WordRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        wordId: wordId,
      ),
    );
  }

  @override
  FutureProviderElement<Word> createElement() {
    return _WordProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WordProvider && other.wordId == wordId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, wordId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin WordRef on FutureProviderRef<Word> {
  /// The parameter `wordId` of this provider.
  String get wordId;
}

class _WordProviderElement extends FutureProviderElement<Word> with WordRef {
  _WordProviderElement(super.provider);

  @override
  String get wordId => (origin as WordProvider).wordId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
