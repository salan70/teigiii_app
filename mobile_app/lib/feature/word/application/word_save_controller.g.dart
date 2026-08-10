// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word_save_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$wordSaveControllerHash() =>
    r'43f2224fd6ab45d20cc706023dea1d142aff4a91';

/// See also [wordSaveController].
@ProviderFor(wordSaveController)
final wordSaveControllerProvider =
    AutoDisposeProvider<WordSaveController>.internal(
      wordSaveController,
      name: r'wordSaveControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$wordSaveControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WordSaveControllerRef = AutoDisposeProviderRef<WordSaveController>;
String _$wordSavedOverrideNotifierHash() =>
    r'6ba9417f4c5c9329b3237cc55ddb842faf232703';

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

abstract class _$WordSavedOverrideNotifier
    extends BuildlessAutoDisposeNotifier<bool?> {
  late final String wordId;

  bool? build(String wordId);
}

/// 楽観的更新用の保存状態オーバーライド（null = API 値を使用）。
///
/// Copied from [WordSavedOverrideNotifier].
@ProviderFor(WordSavedOverrideNotifier)
const wordSavedOverrideNotifierProvider = WordSavedOverrideNotifierFamily();

/// 楽観的更新用の保存状態オーバーライド（null = API 値を使用）。
///
/// Copied from [WordSavedOverrideNotifier].
class WordSavedOverrideNotifierFamily extends Family<bool?> {
  /// 楽観的更新用の保存状態オーバーライド（null = API 値を使用）。
  ///
  /// Copied from [WordSavedOverrideNotifier].
  const WordSavedOverrideNotifierFamily();

  /// 楽観的更新用の保存状態オーバーライド（null = API 値を使用）。
  ///
  /// Copied from [WordSavedOverrideNotifier].
  WordSavedOverrideNotifierProvider call(String wordId) {
    return WordSavedOverrideNotifierProvider(wordId);
  }

  @override
  WordSavedOverrideNotifierProvider getProviderOverride(
    covariant WordSavedOverrideNotifierProvider provider,
  ) {
    return call(provider.wordId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'wordSavedOverrideNotifierProvider';
}

/// 楽観的更新用の保存状態オーバーライド（null = API 値を使用）。
///
/// Copied from [WordSavedOverrideNotifier].
class WordSavedOverrideNotifierProvider
    extends AutoDisposeNotifierProviderImpl<WordSavedOverrideNotifier, bool?> {
  /// 楽観的更新用の保存状態オーバーライド（null = API 値を使用）。
  ///
  /// Copied from [WordSavedOverrideNotifier].
  WordSavedOverrideNotifierProvider(String wordId)
    : this._internal(
        () => WordSavedOverrideNotifier()..wordId = wordId,
        from: wordSavedOverrideNotifierProvider,
        name: r'wordSavedOverrideNotifierProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$wordSavedOverrideNotifierHash,
        dependencies: WordSavedOverrideNotifierFamily._dependencies,
        allTransitiveDependencies:
            WordSavedOverrideNotifierFamily._allTransitiveDependencies,
        wordId: wordId,
      );

  WordSavedOverrideNotifierProvider._internal(
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
  bool? runNotifierBuild(covariant WordSavedOverrideNotifier notifier) {
    return notifier.build(wordId);
  }

  @override
  Override overrideWith(WordSavedOverrideNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: WordSavedOverrideNotifierProvider._internal(
        () => create()..wordId = wordId,
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
  AutoDisposeNotifierProviderElement<WordSavedOverrideNotifier, bool?>
  createElement() {
    return _WordSavedOverrideNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WordSavedOverrideNotifierProvider && other.wordId == wordId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, wordId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin WordSavedOverrideNotifierRef on AutoDisposeNotifierProviderRef<bool?> {
  /// The parameter `wordId` of this provider.
  String get wordId;
}

class _WordSavedOverrideNotifierProviderElement
    extends AutoDisposeNotifierProviderElement<WordSavedOverrideNotifier, bool?>
    with WordSavedOverrideNotifierRef {
  _WordSavedOverrideNotifierProviderElement(super.provider);

  @override
  String get wordId => (origin as WordSavedOverrideNotifierProvider).wordId;
}

String _$wordSaveInProgressNotifierHash() =>
    r'902c3243ed77e19952d2aa1b4aef1f621cf6fc78';

abstract class _$WordSaveInProgressNotifier
    extends BuildlessAutoDisposeNotifier<bool> {
  late final String wordId;

  bool build(String wordId);
}

/// 保存操作の進行中フラグ。
///
/// Copied from [WordSaveInProgressNotifier].
@ProviderFor(WordSaveInProgressNotifier)
const wordSaveInProgressNotifierProvider = WordSaveInProgressNotifierFamily();

/// 保存操作の進行中フラグ。
///
/// Copied from [WordSaveInProgressNotifier].
class WordSaveInProgressNotifierFamily extends Family<bool> {
  /// 保存操作の進行中フラグ。
  ///
  /// Copied from [WordSaveInProgressNotifier].
  const WordSaveInProgressNotifierFamily();

  /// 保存操作の進行中フラグ。
  ///
  /// Copied from [WordSaveInProgressNotifier].
  WordSaveInProgressNotifierProvider call(String wordId) {
    return WordSaveInProgressNotifierProvider(wordId);
  }

  @override
  WordSaveInProgressNotifierProvider getProviderOverride(
    covariant WordSaveInProgressNotifierProvider provider,
  ) {
    return call(provider.wordId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'wordSaveInProgressNotifierProvider';
}

/// 保存操作の進行中フラグ。
///
/// Copied from [WordSaveInProgressNotifier].
class WordSaveInProgressNotifierProvider
    extends AutoDisposeNotifierProviderImpl<WordSaveInProgressNotifier, bool> {
  /// 保存操作の進行中フラグ。
  ///
  /// Copied from [WordSaveInProgressNotifier].
  WordSaveInProgressNotifierProvider(String wordId)
    : this._internal(
        () => WordSaveInProgressNotifier()..wordId = wordId,
        from: wordSaveInProgressNotifierProvider,
        name: r'wordSaveInProgressNotifierProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$wordSaveInProgressNotifierHash,
        dependencies: WordSaveInProgressNotifierFamily._dependencies,
        allTransitiveDependencies:
            WordSaveInProgressNotifierFamily._allTransitiveDependencies,
        wordId: wordId,
      );

  WordSaveInProgressNotifierProvider._internal(
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
  bool runNotifierBuild(covariant WordSaveInProgressNotifier notifier) {
    return notifier.build(wordId);
  }

  @override
  Override overrideWith(WordSaveInProgressNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: WordSaveInProgressNotifierProvider._internal(
        () => create()..wordId = wordId,
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
  AutoDisposeNotifierProviderElement<WordSaveInProgressNotifier, bool>
  createElement() {
    return _WordSaveInProgressNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WordSaveInProgressNotifierProvider &&
        other.wordId == wordId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, wordId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin WordSaveInProgressNotifierRef on AutoDisposeNotifierProviderRef<bool> {
  /// The parameter `wordId` of this provider.
  String get wordId;
}

class _WordSaveInProgressNotifierProviderElement
    extends AutoDisposeNotifierProviderElement<WordSaveInProgressNotifier, bool>
    with WordSaveInProgressNotifierRef {
  _WordSaveInProgressNotifierProviderElement(super.provider);

  @override
  String get wordId => (origin as WordSaveInProgressNotifierProvider).wordId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
