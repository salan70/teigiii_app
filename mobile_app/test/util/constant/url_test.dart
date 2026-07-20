import 'package:flutter_test/flutter_test.dart';
import 'package:teigi_app/util/constant/url.dart';

void main() {
  test('contentReportFormUrl は対象種別・対象 ID・報告者・理由を事前入力する', () {
    final url = contentReportFormUrl(
      targetType: ReportTargetType.word,
      targetId: 'word/1',
      currentUserPublicId: '123456789',
      initialReason: '修正提案: 表記',
    );

    final uri = Uri.parse(url);
    expect(uri.queryParameters['entry.1412333435'], 'word:word/1');
    expect(uri.queryParameters['entry.399122039'], '123456789');
    expect(uri.queryParameters['entry.542125213'], '修正提案: 表記');
  });

  test('userReportFormUrl は既存フォームとの互換性を維持する', () {
    final uri = Uri.parse(
      userReportFormUrl(
        targetUserPublicId: '987654321',
        currentUserPublicId: '123456789',
      ),
    );

    expect(uri.queryParameters['entry.1412333435'], '987654321');
  });
}
