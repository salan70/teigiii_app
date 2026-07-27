import 'package:flutter_test/flutter_test.dart';
import 'package:teigi_app/feature/definition/application/definition_seed_store.dart';

import '../../../mock/mock_data.dart';

void main() {
  late DefinitionSeedStore store;

  setUp(() => store = DefinitionSeedStore());

  test('seedAll で投入した定義を read できる', () {
    // * Act
    store.seedAll('feed-a', [definitionOf('definition-1')]);

    // * Assert
    expect(store.read('definition-1'), definitionOf('definition-1'));
    expect(store.idsOf('feed-a'), {'definition-1'});
  });

  test('replaceAll は同一フィードから消えた ID のシードを破棄して返す', () {
    // * Arrange
    store.seedAll('feed-a', [
      definitionOf('definition-1'),
      definitionOf('definition-2'),
    ]);

    // * Act
    final removedIds = store.replaceAll('feed-a', [
      definitionOf('definition-1'),
    ]);

    // * Assert
    expect(removedIds, {'definition-2'});
    expect(store.read('definition-1'), isNotNull);
    expect(store.read('definition-2'), isNull);
  });

  test('別フィードの replaceAll は、他フィードのシードを消さない', () {
    // * Arrange
    store.seedAll('feed-a', [definitionOf('definition-1')]);
    store.seedAll('feed-b', [definitionOf('definition-2')]);

    // * Act
    final removedIds = store.replaceAll('feed-b', [
      definitionOf('definition-3'),
    ]);

    // * Assert
    expect(removedIds, {'definition-2'});
    expect(store.read('definition-1'), isNotNull);
    expect(store.read('definition-3'), isNotNull);
  });

  test('他フィードが参照している ID は replaceAll でも破棄されない', () {
    // * Arrange
    // 同じ定義が 2 つのフィードに現れる状況（おすすめとフォロー中の重複）。
    store.seedAll('feed-a', [definitionOf('definition-1')]);
    store.seedAll('feed-b', [definitionOf('definition-1')]);

    // * Act
    final removedIds = store.replaceAll('feed-a', []);

    // * Assert
    expect(removedIds, isEmpty);
    expect(store.read('definition-1'), isNotNull);
  });

  test('remove はシードとフィードの参照の両方から取り除く', () {
    // * Arrange
    store.seedAll('feed-a', [definitionOf('definition-1')]);

    // * Act
    store.remove('definition-1');

    // * Assert
    expect(store.read('definition-1'), isNull);
    expect(store.idsOf('feed-a'), isEmpty);
  });
}
