import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:teigi_app/core/analytics/analytics_event.dart';
import 'package:teigi_app/feature/definition/application/definition_service.dart';
import 'package:teigi_app/feature/definition/repository/write_definition_repository.dart';

import '../../../mock/fake_analytics.dart';
import '../../../mock/mock_data.dart';
import 'definition_write_service_test.mocks.dart';

@GenerateNiceMocks([MockSpec<WriteDefinitionRepository>()])
void main() {
  final mockWriteDefinitionRepository = MockWriteDefinitionRepository();
  late ProviderContainer container;
  late FakeAnalyticsClient fakeAnalytics;

  setUp(() {
    fakeAnalytics = FakeAnalyticsClient();
    container = ProviderContainer(
      overrides: [
        writeDefinitionRepositoryProvider.overrideWithValue(
          mockWriteDefinitionRepository,
        ),
        ...analyticsTestOverrides(fakeAnalytics),
      ],
    );
    addTearDown(container.dispose);
  });

  tearDown(() => reset(mockWriteDefinitionRepository));

  test('deleteDefinition 成功時に definition_deleted を送る', () async {
    await container
        .read(definitionServiceProvider)
        .deleteDefinition(mockDefinition);

    verify(
      mockWriteDefinitionRepository.deleteDefinition(mockDefinition.id),
    ).called(1);
    expect(
      fakeAnalytics.loggedEvents.single.name,
      AnalyticsEvent.definitionDeleted,
    );
    expect(fakeAnalytics.loggedEvents.single.parameters, {
      AnalyticsParam.definitionId: mockDefinition.id,
      AnalyticsParam.wordId: mockDefinition.wordId,
      AnalyticsParam.wasPublic: mockDefinition.isPublic,
    });
  });

  test('updatePostType 成功時に definition_visibility_changed を送る', () async {
    final definition = mockDefinition.copyWith(isPublic: true);

    await container.read(definitionServiceProvider).updatePostType(definition);

    verify(
      mockWriteDefinitionRepository.updatePostType(
        definitionId: definition.id,
        isPublic: false,
      ),
    ).called(1);
    expect(
      fakeAnalytics.loggedEvents.single.name,
      AnalyticsEvent.definitionVisibilityChanged,
    );
    expect(
      fakeAnalytics.loggedEvents.single.parameters?[AnalyticsParam.isPublic],
      false,
    );
  });
}
