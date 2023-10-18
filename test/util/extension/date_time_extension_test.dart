import 'package:flutter_test/flutter_test.dart';
import 'package:teigi_app/util/extension/date_time_extension.dart';

void main() {
  group('timeAgo()', () {
    final baseTime = DateTime(2023, 4, 15, 15, 30); // 2023年4月15日 15:30を基準時刻とする

    test('returns "1分前" for a date 1 minute ago', () {
      final date = baseTime.subtract(const Duration(minutes: 1));
      expect(date.timeAgo(baseTime), '1分前');
    });

    test('returns "59分前" for a date 59 minutes ago', () {
      final date = baseTime.subtract(const Duration(minutes: 59));
      expect(date.timeAgo(baseTime), '59分前');
    });

    test('returns "1時間前" for a date 1 hour ago', () {
      final date = baseTime.subtract(const Duration(hours: 1));
      expect(date.timeAgo(baseTime), '1時間前');
    });

    test('returns "23時間前" for a date 23 hours ago', () {
      final date = baseTime.subtract(const Duration(hours: 23));
      expect(date.timeAgo(baseTime), '23時間前');
    });

    test('returns "1日前" for a date 1 day ago', () {
      final date = baseTime.subtract(const Duration(days: 1));
      expect(date.timeAgo(baseTime), '1日前');
    });

    test('returns "6日前" for a date 6 days ago', () {
      final date = baseTime.subtract(const Duration(days: 6));
      expect(date.timeAgo(baseTime), '6日前');
    });

    test('returns "1週間前" for a date 7 days ago', () {
      final date = baseTime.subtract(const Duration(days: 7));
      expect(date.timeAgo(baseTime), '1週間前');
    });

    test('returns "4週間前" for a date 28 days ago', () {
      final date = baseTime.subtract(const Duration(days: 28));
      expect(date.timeAgo(baseTime), '4週間前');
    });

    test('returns "1ヶ月前" for a date 30 days ago', () {
      final date = baseTime.subtract(const Duration(days: 30));
      expect(date.timeAgo(baseTime), '1ヶ月前');
    });

    test('returns "11ヶ月前" for a date 330 days ago', () {
      final date = baseTime.subtract(const Duration(days: 330));
      expect(date.timeAgo(baseTime), '11ヶ月前');
    });

    test('returns "1年前" for a date 365 days ago', () {
      final date = baseTime.subtract(const Duration(days: 365));
      expect(date.timeAgo(baseTime), '1年前');
    });
  });
}
