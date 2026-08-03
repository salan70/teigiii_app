import 'package:flutter_test/flutter_test.dart';
import 'package:teigi_app/util/extension/string_extension.dart';

void main() {
  group('trimEnd()', () {
    test('末尾の空白を削除する', () {
      expect('Hello World   '.trimEnd(), 'Hello World');
      expect('Some text\n\n'.trimEnd(), 'Some text');
      expect('  A  '.trimEnd(), '  A');
      expect('NoWhitespace'.trimEnd(), 'NoWhitespace');
    });

    test('先頭の空白はそのままにする', () {
      expect('  Hello World'.trimEnd(), '  Hello World');
    });

    test('空文字列の場合は空文字列のままにする', () {
      expect(''.trimEnd(), '');
    });

    test('文字列に空白がない場合はそのままにする', () {
      expect('HelloWorld'.trimEnd(), 'HelloWorld');
    });
  });
}
