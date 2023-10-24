import 'package:flutter_test/flutter_test.dart';
import 'package:teigi_app/util/extension/date_time_extension.dart';

void main() {
  group('timeAgo()', () {
    final baseTime = DateTime(2023, 4, 15, 15, 30); // 2023年4月15日 15:30を基準時刻とする

    test('returns "1分前" for a date 1 minute ago', () {
      // * Arrange
      final date = baseTime.subtract(const Duration(minutes: 1));

      // * Act
      final expected = date.timeAgo(baseTime);

      // * Assert
      expect(expected, '1分前');
    });

    test('returns "59分前" for a date 59 minutes ago', () {
      // * Arrange
      final date = baseTime.subtract(const Duration(minutes: 59));

      // * Act
      final expected = date.timeAgo(baseTime);

      // * Assert
      expect(expected, '59分前');
    });

    test('returns "1時間前" for a date 1 hour ago', () {
      // * Arrange
      final date = baseTime.subtract(const Duration(hours: 1));

      // * Act
      final expected = date.timeAgo(baseTime);

      // * Assert
      expect(expected, '1時間前');
    });

    test('returns "23時間前" for a date 23 hours ago', () {
      // * Arrange
      final date = baseTime.subtract(const Duration(hours: 23));

      // * Act
      final expected = date.timeAgo(baseTime);

      // * Assert
      expect(expected, '23時間前');
    });

    test('returns "1日前" for a date 1 day ago', () {
      // * Arrange
      final date = baseTime.subtract(const Duration(days: 1));

      // * Act
      final expected = date.timeAgo(baseTime);

      // * Assert
      expect(expected, '1日前');
    });

    test('returns "6日前" for a date 6 days ago', () {
      // * Arrange
      final date = baseTime.subtract(const Duration(days: 6));

      // * Act
      final expected = date.timeAgo(baseTime);

      // * Assert
      expect(expected, '6日前');
    });

    test('returns "1週間前" for a date 7 days ago', () {
      // * Arrange
      final date = baseTime.subtract(const Duration(days: 7));

      // * Act
      final expected = date.timeAgo(baseTime);

      // * Assert
      expect(expected, '1週間前');
    });

    test('returns "4週間前" for a date 28 days ago', () {
      // * Arrange
      final date = baseTime.subtract(const Duration(days: 28));

      // * Act
      final expected = date.timeAgo(baseTime);

      // * Assert
      expect(expected, '4週間前');
    });

    test('returns "1ヶ月前" for a date 30 days ago', () {
      // * Arrange
      final date = baseTime.subtract(const Duration(days: 30));

      // * Act
      final expected = date.timeAgo(baseTime);

      // * Assert
      expect(expected, '1ヶ月前');
    });

    test('returns "11ヶ月前" for a date 330 days ago', () {
      // * Arrange
      final date = baseTime.subtract(const Duration(days: 330));

      // * Act
      final expected = date.timeAgo(baseTime);

      // * Assert
      expect(expected, '11ヶ月前');
    });

    test('returns "1年前" for a date 365 days ago', () {
      // * Arrange
      final date = baseTime.subtract(const Duration(days: 365));

      // * Act
      final expected = date.timeAgo(baseTime);

      // * Assert
      expect(expected, '1年前');
    });
  });

  group('toDisplayFormat', () {
    test('DateTime toCustomFormat test', () {
      // * Arrange
      final testDate = DateTime(2023, 10, 22, 14, 30);

      // * Act
      final expected = testDate.toDisplayFormat();

      // * Assert
      expect(expected, '2023/10/22 14:30');
    });
  });
}
