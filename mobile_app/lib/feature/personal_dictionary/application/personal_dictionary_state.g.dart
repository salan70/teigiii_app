// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personal_dictionary_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$personalDictionaryOverviewHash() =>
    r'09ba48aa42c4784a7c0ee442291ff796f0d61aaf';

/// See also [personalDictionaryOverview].
@ProviderFor(personalDictionaryOverview)
final personalDictionaryOverviewProvider =
    AutoDisposeFutureProvider<PersonalDictionaryOverview>.internal(
  personalDictionaryOverview,
  name: r'personalDictionaryOverviewProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$personalDictionaryOverviewHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef PersonalDictionaryOverviewRef
    = AutoDisposeFutureProviderRef<PersonalDictionaryOverview>;
String _$definedWordListHash() => r'14b4a7dfe0ddb73600d8c9df1fec9065ff0e8e32';

/// See also [DefinedWordList].
@ProviderFor(DefinedWordList)
final definedWordListProvider = AutoDisposeAsyncNotifierProvider<
    DefinedWordList, PagedItems<DefinedWord>>.internal(
  DefinedWordList.new,
  name: r'definedWordListProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$definedWordListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$DefinedWordList = AutoDisposeAsyncNotifier<PagedItems<DefinedWord>>;
String _$definitionDraftListHash() =>
    r'31d3639a82d35b059779adfe9a347192e49c82b7';

/// See also [DefinitionDraftList].
@ProviderFor(DefinitionDraftList)
final definitionDraftListProvider = AutoDisposeAsyncNotifierProvider<
    DefinitionDraftList, PagedItems<DefinitionDraft>>.internal(
  DefinitionDraftList.new,
  name: r'definitionDraftListProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$definitionDraftListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$DefinitionDraftList
    = AutoDisposeAsyncNotifier<PagedItems<DefinitionDraft>>;
String _$savedWordListHash() => r'e867a1ef7c8d87c8b48ad2ddf5d17491cdebc655';

/// See also [SavedWordList].
@ProviderFor(SavedWordList)
final savedWordListProvider = AutoDisposeAsyncNotifierProvider<SavedWordList,
    PagedItems<SavedWord>>.internal(
  SavedWordList.new,
  name: r'savedWordListProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$savedWordListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SavedWordList = AutoDisposeAsyncNotifier<PagedItems<SavedWord>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
