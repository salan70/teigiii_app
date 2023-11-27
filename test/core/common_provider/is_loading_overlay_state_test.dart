import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:teigi_app/core/common_provider/is_loading_overlay_state.dart';

import 'common_provider_test.mocks.dart';

@GenerateNiceMocks([MockSpec<Listener<bool>>()])

// ignore: one_member_abstracts, unreachable_from_main
abstract class Listener<T> {
// ignore: unreachable_from_main
  void call(T? previous, T next);
}

void main() {
  final listener = MockListener();
  late ProviderContainer container;

  setUp(
    () {
      container = ProviderContainer()
        ..listen(
          isLoadingOverlayNotifierProvider,
          listener,
          fireImmediately: true,
        );
      addTearDown(container.dispose);
    },
  );

  tearDown(() {
    reset(listener);
  });

  group('build()', () {
    test('stateを検証', () {
      // * Arrange
      // * Act
      container.read(isLoadingOverlayNotifierProvider);

      // * Assert
      // stateの検証
      verify(listener.call(null, false));
      // 他にlistenerが発火されないことを検証
      verifyNoMoreInteractions(listener);
    });
  });

  group('startLoading()', () {
    test('stateを検証: false -> true', () {
      // * Arrange
      // * Act
      container.read(isLoadingOverlayNotifierProvider.notifier).startLoading();

      // * Assert
      // stateの検証
      verifyInOrder([
        // build()時
        listener.call(null, false),
        // startLoading()後
        listener.call(false, true),
      ]);
      // 他にlistenerが発火されないことを検証
      verifyNoMoreInteractions(listener);
    });
  });

  group('finishLoading()', () {
    test('stateを検証: false -> false', () {
      // * Arrange
      // * Act
      container.read(isLoadingOverlayNotifierProvider.notifier).finishLoading();

      // * Assert
      // stateの検証
      verifyInOrder([
        // build()時
        listener.call(null, false),
      ]);
      // 他にlistenerが発火されないことを検証
      // stateが変化しないので、listenerは発火されない
      verifyNoMoreInteractions(listener);
    });

    test('stateを検証: true -> false', () {
      // * Arrange
      container.read(isLoadingOverlayNotifierProvider.notifier)
        ..startLoading()

        // * Act
        ..finishLoading();

      // * Assert
      // stateの検証
      verifyInOrder([
        // build()時
        listener.call(null, false),
        // startLoading()後
        listener.call(false, true),
        // finishLoading()後
        listener.call(true, false),
      ]);
      // 他にlistenerが発火されないことを検証
      verifyNoMoreInteractions(listener);
    });
  });
}
