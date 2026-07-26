import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teigi_app/util/load_app_dotenv.dart';

void main() {
  group('loadAppDotEnv', () {
    test('EmptyEnvFileError のとき空の env で初期化する', () async {
      var initializedEmpty = false;

      await loadAppDotEnv(
        load: () async => throw EmptyEnvFileError(),
        initializeEmpty: () => initializedEmpty = true,
      );

      expect(initializedEmpty, isTrue);
    });

    test('load 成功時は空初期化しない', () async {
      var loaded = false;
      var initializedEmpty = false;

      await loadAppDotEnv(
        load: () async {
          loaded = true;
        },
        initializeEmpty: () => initializedEmpty = true,
      );

      expect(loaded, isTrue);
      expect(initializedEmpty, isFalse);
    });

    test('FileNotFoundError など他のエラーは再送出する', () async {
      await expectLater(
        () => loadAppDotEnv(
          load: () async => throw FileNotFoundError(),
          initializeEmpty: () {},
        ),
        throwsA(isA<FileNotFoundError>()),
      );
    });
  });
}
