// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'definition_draft_editor.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$definitionDraftIdHash() => r'e44ba1d4982046fc393dd60d0bfeedd2b0865ec4';

/// See also [definitionDraftId].
@ProviderFor(definitionDraftId)
final definitionDraftIdProvider = AutoDisposeProvider<String>.internal(
  definitionDraftId,
  name: r'definitionDraftIdProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$definitionDraftIdHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef DefinitionDraftIdRef = AutoDisposeProviderRef<String>;
String _$definitionDraftEditorHash() =>
    r'795e10f4c2df70f59335b9db45ad5469c9ceeca8';

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

abstract class _$DefinitionDraftEditor
    extends BuildlessAutoDisposeAsyncNotifier<DefinitionDraft> {
  late final String? draftId;
  late final DefinitionForWrite? initialDefinitionForWrite;

  FutureOr<DefinitionDraft> build(
    String? draftId,
    DefinitionForWrite? initialDefinitionForWrite,
  );
}

/// 一画面の入力を Draft として保持し、部分保存と確定を直列化する。
///
/// Copied from [DefinitionDraftEditor].
@ProviderFor(DefinitionDraftEditor)
const definitionDraftEditorProvider = DefinitionDraftEditorFamily();

/// 一画面の入力を Draft として保持し、部分保存と確定を直列化する。
///
/// Copied from [DefinitionDraftEditor].
class DefinitionDraftEditorFamily extends Family<AsyncValue<DefinitionDraft>> {
  /// 一画面の入力を Draft として保持し、部分保存と確定を直列化する。
  ///
  /// Copied from [DefinitionDraftEditor].
  const DefinitionDraftEditorFamily();

  /// 一画面の入力を Draft として保持し、部分保存と確定を直列化する。
  ///
  /// Copied from [DefinitionDraftEditor].
  DefinitionDraftEditorProvider call(
    String? draftId,
    DefinitionForWrite? initialDefinitionForWrite,
  ) {
    return DefinitionDraftEditorProvider(
      draftId,
      initialDefinitionForWrite,
    );
  }

  @override
  DefinitionDraftEditorProvider getProviderOverride(
    covariant DefinitionDraftEditorProvider provider,
  ) {
    return call(
      provider.draftId,
      provider.initialDefinitionForWrite,
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
  String? get name => r'definitionDraftEditorProvider';
}

/// 一画面の入力を Draft として保持し、部分保存と確定を直列化する。
///
/// Copied from [DefinitionDraftEditor].
class DefinitionDraftEditorProvider
    extends AutoDisposeAsyncNotifierProviderImpl<DefinitionDraftEditor,
        DefinitionDraft> {
  /// 一画面の入力を Draft として保持し、部分保存と確定を直列化する。
  ///
  /// Copied from [DefinitionDraftEditor].
  DefinitionDraftEditorProvider(
    String? draftId,
    DefinitionForWrite? initialDefinitionForWrite,
  ) : this._internal(
          () => DefinitionDraftEditor()
            ..draftId = draftId
            ..initialDefinitionForWrite = initialDefinitionForWrite,
          from: definitionDraftEditorProvider,
          name: r'definitionDraftEditorProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$definitionDraftEditorHash,
          dependencies: DefinitionDraftEditorFamily._dependencies,
          allTransitiveDependencies:
              DefinitionDraftEditorFamily._allTransitiveDependencies,
          draftId: draftId,
          initialDefinitionForWrite: initialDefinitionForWrite,
        );

  DefinitionDraftEditorProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.draftId,
    required this.initialDefinitionForWrite,
  }) : super.internal();

  final String? draftId;
  final DefinitionForWrite? initialDefinitionForWrite;

  @override
  FutureOr<DefinitionDraft> runNotifierBuild(
    covariant DefinitionDraftEditor notifier,
  ) {
    return notifier.build(
      draftId,
      initialDefinitionForWrite,
    );
  }

  @override
  Override overrideWith(DefinitionDraftEditor Function() create) {
    return ProviderOverride(
      origin: this,
      override: DefinitionDraftEditorProvider._internal(
        () => create()
          ..draftId = draftId
          ..initialDefinitionForWrite = initialDefinitionForWrite,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        draftId: draftId,
        initialDefinitionForWrite: initialDefinitionForWrite,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<DefinitionDraftEditor,
      DefinitionDraft> createElement() {
    return _DefinitionDraftEditorProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DefinitionDraftEditorProvider &&
        other.draftId == draftId &&
        other.initialDefinitionForWrite == initialDefinitionForWrite;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, draftId.hashCode);
    hash = _SystemHash.combine(hash, initialDefinitionForWrite.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin DefinitionDraftEditorRef
    on AutoDisposeAsyncNotifierProviderRef<DefinitionDraft> {
  /// The parameter `draftId` of this provider.
  String? get draftId;

  /// The parameter `initialDefinitionForWrite` of this provider.
  DefinitionForWrite? get initialDefinitionForWrite;
}

class _DefinitionDraftEditorProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<DefinitionDraftEditor,
        DefinitionDraft> with DefinitionDraftEditorRef {
  _DefinitionDraftEditorProviderElement(super.provider);

  @override
  String? get draftId => (origin as DefinitionDraftEditorProvider).draftId;
  @override
  DefinitionForWrite? get initialDefinitionForWrite =>
      (origin as DefinitionDraftEditorProvider).initialDefinitionForWrite;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
