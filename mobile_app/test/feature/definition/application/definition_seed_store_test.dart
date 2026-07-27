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

  test('releaseFeed はフィード参照を外し、他から未参照のシードを破棄する', () {
    // * Arrange
    store.seedAll('feed-a', [
      definitionOf('definition-1'),
      definitionOf('definition-2'),
    ]);
    store.seedAll('feed-b', [definitionOf('definition-2')]);

    // * Act
    final removedIds = store.releaseFeed('feed-a');

    // * Assert
    expect(removedIds, {'definition-1'});
    expect(store.idsOf('feed-a'), isEmpty);
    expect(store.read('definition-1'), isNull);
    // feed-b がまだ参照しているため残る。
    expect(store.read('definition-2'), isNotNull);
    expect(store.idsOf('feed-b'), {'definition-2'});
  });

  test('releaseFeed は未登録のフィードに対して空集合を返す', () {
    expect(store.releaseFeed('missing'), isEmpty);
  });

  test('フィード数が上限を超えると古いフィードのシードが破棄される', () {
    // * Arrange / Act
    for (var i = 0; i < DefinitionSeedStore.maxFeedCount; i++) {
      store.seedAll('feed-$i', [definitionOf('definition-$i')]);
    }
    store.seedAll('feed-new', [definitionOf('definition-new')]);

    // * Assert
    expect(store.feedKeys, hasLength(DefinitionSeedStore.maxFeedCount));
    expect(store.feedKeys.first, isNot('feed-0'));
    expect(store.read('definition-0'), isNull);
    expect(store.read('definition-new'), isNotNull);
    // 直近のフィードは残る。
    expect(
      store.read('definition-${DefinitionSeedStore.maxFeedCount - 1}'),
      isNotNull,
    );
  });

  test('最近 touch したフィードは上限超過時も残り、古いものから落ちる', () {
    for (var i = 0; i < DefinitionSeedStore.maxFeedCount; i++) {
      store.seedAll('feed-$i', [definitionOf('definition-$i')]);
    }
    // feed-0 を最近使った扱いにする。
    store.seedAll('feed-0', [definitionOf('definition-0-updated')]);
    store.seedAll('feed-new', [definitionOf('definition-new')]);

    expect(store.read('definition-0-updated'), isNotNull);
    expect(store.read('definition-1'), isNull);
    expect(store.read('definition-new'), isNotNull);
  });
}
