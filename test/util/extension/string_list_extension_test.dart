import 'package:flutter_test/flutter_test.dart';
import 'package:teigi_app/util/extension/string_list_extension.dart';

void main() {
  group('orSingleEmptyStringList', () {
    test('Listが空の場合、空のString（' '）が入ったListを返すことを検証', () {
      // * Arrange
      final emptyList = <String>[];

      // * Act
      final result = emptyList.orSingleEmptyStringList;

      // * Assert
      expect(result, ['']);
    });

    test('Listが空でない場合、そのままのListを返すことを検証', () {
      // * Arrange
      final nonEmptyList = <String>['test1', 'test2'];

      // * Act
      final result = nonEmptyList.orSingleEmptyStringList;

      // * Assert
      expect(result, nonEmptyList);
    });
  });
}
