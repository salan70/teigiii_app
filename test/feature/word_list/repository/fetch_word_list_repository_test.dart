import 'package:flutter_test/flutter_test.dart';
import 'package:teigi_app/feature/word_list/repository/fetch_word_list_repository.dart';

void main() {
  group('aggregateCountOrZero', () {
    test('count が null の場合は 0 を返す', () {
      expect(aggregateCountOrZero(null), 0);
    });

    test('count が存在する場合はその値を返す', () {
      expect(aggregateCountOrZero(3), 3);
    });
  });
}
