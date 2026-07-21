import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:teigi_app/feature/definition/application/definition_draft_editor.dart';
import 'package:teigi_app/feature/definition/domain/definition_draft.dart';
import 'package:teigi_app/feature/definition/repository/definition_draft_repository.dart';
import 'package:teigi_app/feature/personal_dictionary/application/personal_dictionary_state.dart';
import 'package:teigi_app/feature/personal_dictionary/domain/personal_dictionary.dart';
import 'package:teigi_app/feature/personal_dictionary/repository/personal_dictionary_repository.dart';

import '../../personal_dictionary/application/personal_dictionary_state_test.mocks.dart';
import 'definition_draft_editor_test.mocks.dart';

@GenerateNiceMocks([MockSpec<DefinitionDraftRepository>()])
void main() {
  final repository = MockDefinitionDraftRepository();
  final personalRepository = MockPersonalDictionaryRepository();
  late ProviderContainer container;

  setUp(() {
    reset(repository);
    reset(personalRepository);
    when(personalRepository.fetchOverview()).thenAnswer(
      (_) async => const PersonalDictionaryOverview.empty(),
    );
    when(personalRepository.fetchDrafts()).thenAnswer(
      (_) async => const PagedItems<DefinitionDraft>(items: [], nextCursor: null),
    );
    container = ProviderContainer(
      overrides: [
        definitionDraftIdProvider.overrideWithValue(
          '00000000-0000-4000-8000-000000000001',
        ),
        definitionDraftRepositoryProvider.overrideWithValue(repository),
        personalDictionaryRepositoryProvider.overrideWithValue(
          personalRepository,
        ),
      ],
    );
  });

  tearDown(() => container.dispose());

  test('新規画面はクライアント生成 ID の空 Draft で開始する', () async {
    final draft = await container.read(
      definitionDraftEditorProvider(null, null).future,
    );

    expect(draft.id, '00000000-0000-4000-8000-000000000001');
    expect(draft.hasAnyInput, isFalse);
    verifyNever(repository.get(any));
  });

  test('一項目だけ入力した Draft も保存する', () async {
    final provider = definitionDraftEditorProvider(null, null);
    await container.read(provider.future);
    container.read(provider.notifier).changeDefinition('本文だけ');
    final edited = container.read(provider).requireValue;
    when(
      repository.save(edited),
    ).thenAnswer((_) async => edited.copyWith(isPersisted: true));

    final saved = await container.read(provider.notifier).save();

    expect(saved, isTrue);
    expect(container.read(provider).requireValue.isPersisted, isTrue);
    verify(repository.save(edited)).called(1);
  });

  test('保存成功後は辞書 overview と Draft 一覧を再取得する', () async {
    await container.read(personalDictionaryOverviewProvider.future);
    await container.read(definitionDraftListProvider.future);
    clearInteractions(personalRepository);

    final provider = definitionDraftEditorProvider(null, null);
    await container.read(provider.future);
    container.read(provider.notifier).changeDefinition('本文だけ');
    final edited = container.read(provider).requireValue;
    when(
      repository.save(edited),
    ).thenAnswer((_) async => edited.copyWith(isPersisted: true));

    await container.read(provider.notifier).save();
    await container.read(personalDictionaryOverviewProvider.future);
    await container.read(definitionDraftListProvider.future);

    verify(personalRepository.fetchOverview()).called(1);
    verify(personalRepository.fetchDrafts()).called(1);
  });

  test('全項目空の新規 Draft は API に保存しない', () async {
    final provider = definitionDraftEditorProvider(null, null);
    await container.read(provider.future);

    final saved = await container.read(provider.notifier).save();

    expect(saved, isFalse);
    verifyNever(repository.save(any));
  });

  test('投稿時は最新内容を保存してから同じ Draft ID を確定する', () async {
    final provider = definitionDraftEditorProvider(null, null);
    await container.read(provider.future);
    final notifier = container.read(provider.notifier)
      ..changeWord('言葉')
      ..changeWordReading('ことば')
      ..changeDefinition('本文');
    final edited = container.read(provider).requireValue;
    when(
      repository.save(edited),
    ).thenAnswer((_) async => edited.copyWith(isPersisted: true));
    when(
      repository.finalize(edited.id),
    ).thenAnswer((_) async => 'definition-id');

    final definitionId = await notifier.finalize();

    expect(definitionId, 'definition-id');
    verifyInOrder([repository.save(edited), repository.finalize(edited.id)]);
  });
}
