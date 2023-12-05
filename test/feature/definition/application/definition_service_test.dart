import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:teigi_app/feature/auth/application/auth_state.dart';
import 'package:teigi_app/feature/definition_like/application/like_definition_service.dart';
import 'package:teigi_app/feature/definition_like/repository/like_definition_repository.dart';

import '../../../mock/mock_data.dart';
import 'definition_service_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<LikeDefinitionRepository>(),
])
void main() {
  final mockLikeDefinitionRepository = MockLikeDefinitionRepository();

  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer(
      overrides: [
        userIdProvider.overrideWith((ref) => 'userId'),
        likeDefinitionRepositoryProvider
            .overrideWithValue(mockLikeDefinitionRepository),
      ],
    );
    addTearDown(container.dispose);
  });

  tearDown(() {
    reset(mockLikeDefinitionRepository);
  });

  group('tapLike()', () {
    test('いいね登録: stateと、想定通りにrepositoryの関数が呼ばれることを検証', () async {
      // * Arrange
      final definitionService = container.read(likeDefinitionServiceProvider);
      // いいね登録のため、isLikedByUserがfalseのDefinitionを用意
      final definition = mockDefinition.copyWith(isLikedByUser: false);

      // * Act
      await definitionService.tapLike(definition);

      // * Assert
      // 想定通りにrepositoryの関数が呼ばれているか検証
      verify(
        mockLikeDefinitionRepository.likeDefinition(definition.id, any),
      ).called(1);

      // 想定外の関数が呼ばれていないか検証
      verifyNever(mockLikeDefinitionRepository.unlikeDefinition(any, any));
    });

    test('いいね解除: stateと、想定通りにrepositoryの関数が呼ばれることを検証', () async {
      // * Arrange
      final definitionService = container.read(likeDefinitionServiceProvider);
      // いいね解除のため、isLikedByUserがtrueのDefinitionを用意
      final definition = mockDefinition.copyWith(isLikedByUser: true);

      // * Act
      await definitionService.tapLike(definition);

      // * Assert
      // 想定通りにrepositoryの関数が呼ばれているか検証
      verify(
        mockLikeDefinitionRepository.unlikeDefinition(definition.id, any),
      ).called(1);

      // 想定外の関数が呼ばれていないか検証
      verifyNever(mockLikeDefinitionRepository.likeDefinition(any, any));
    });

    // TODO(me): definitionProviderが再生成されているか検証するテスト書く
    // providerがinvalidateされたことを検証する方法がわからないため一旦保留
    //
    // test('definitionProviderが再生成されているか検証', () async {});
  });
}
