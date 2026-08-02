// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'existing_public_word_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$existingPublicWordIdHash() =>
    r'0bc11278e39bbd3639072dccbb18c8e0fb6df05d';

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

/// 登録前の既存語チェック。
///
/// (表記, よみ) が完全一致する公開済みの言葉があればその ID を、
/// なければ null を返す。判定キーが (表記, よみ) であるため、
/// どちらかが空のときは問い合わせない。
///
/// Copied from [existingPublicWordId].
@ProviderFor(existingPublicWordId)
const existingPublicWordIdProvider = ExistingPublicWordIdFamily();

/// 登録前の既存語チェック。
///
/// (表記, よみ) が完全一致する公開済みの言葉があればその ID を、
/// なければ null を返す。判定キーが (表記, よみ) であるため、
/// どちらかが空のときは問い合わせない。
///
/// Copied from [existingPublicWordId].
class ExistingPublicWordIdFamily extends Family<AsyncValue<String?>> {
  /// 登録前の既存語チェック。
  ///
  /// (表記, よみ) が完全一致する公開済みの言葉があればその ID を、
  /// なければ null を返す。判定キーが (表記, よみ) であるため、
  /// どちらかが空のときは問い合わせない。
  ///
  /// Copied from [existingPublicWordId].
  const ExistingPublicWordIdFamily();

  /// 登録前の既存語チェック。
  ///
  /// (表記, よみ) が完全一致する公開済みの言葉があればその ID を、
  /// なければ null を返す。判定キーが (表記, よみ) であるため、
  /// どちらかが空のときは問い合わせない。
  ///
  /// Copied from [existingPublicWordId].
  ExistingPublicWordIdProvider call({
    required String word,
    required String reading,
  }) {
    return ExistingPublicWordIdProvider(word: word, reading: reading);
  }

  @override
  ExistingPublicWordIdProvider getProviderOverride(
    covariant ExistingPublicWordIdProvider provider,
  ) {
    return call(word: provider.word, reading: provider.reading);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'existingPublicWordIdProvider';
}

/// 登録前の既存語チェック。
///
/// (表記, よみ) が完全一致する公開済みの言葉があればその ID を、
/// なければ null を返す。判定キーが (表記, よみ) であるため、
/// どちらかが空のときは問い合わせない。
///
/// Copied from [existingPublicWordId].
class ExistingPublicWordIdProvider extends AutoDisposeFutureProvider<String?> {
  /// 登録前の既存語チェック。
  ///
  /// (表記, よみ) が完全一致する公開済みの言葉があればその ID を、
  /// なければ null を返す。判定キーが (表記, よみ) であるため、
  /// どちらかが空のときは問い合わせない。
  ///
  /// Copied from [existingPublicWordId].
  ExistingPublicWordIdProvider({required String word, required String reading})
    : this._internal(
        (ref) => existingPublicWordId(
          ref as ExistingPublicWordIdRef,
          word: word,
          reading: reading,
        ),
        from: existingPublicWordIdProvider,
        name: r'existingPublicWordIdProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$existingPublicWordIdHash,
        dependencies: ExistingPublicWordIdFamily._dependencies,
        allTransitiveDependencies:
            ExistingPublicWordIdFamily._allTransitiveDependencies,
        word: word,
        reading: reading,
      );

  ExistingPublicWordIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.word,
    required this.reading,
  }) : super.internal();

  final String word;
  final String reading;

  @override
  Override overrideWith(
    FutureOr<String?> Function(ExistingPublicWordIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ExistingPublicWordIdProvider._internal(
        (ref) => create(ref as ExistingPublicWordIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        word: word,
        reading: reading,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<String?> createElement() {
    return _ExistingPublicWordIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ExistingPublicWordIdProvider &&
        other.word == word &&
        other.reading == reading;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, word.hashCode);
    hash = _SystemHash.combine(hash, reading.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ExistingPublicWordIdRef on AutoDisposeFutureProviderRef<String?> {
  /// The parameter `word` of this provider.
  String get word;

  /// The parameter `reading` of this provider.
  String get reading;
}

class _ExistingPublicWordIdProviderElement
    extends AutoDisposeFutureProviderElement<String?>
    with ExistingPublicWordIdRef {
  _ExistingPublicWordIdProviderElement(super.provider);

  @override
  String get word => (origin as ExistingPublicWordIdProvider).word;
  @override
  String get reading => (origin as ExistingPublicWordIdProvider).reading;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
