import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teigi_app/feature/timeline/repository/timeline_tab_repository.dart';

void main() {
  const repository = TimelineTabRepository();

  test('初回は見つけるを返す', () async {
    SharedPreferences.setMockInitialValues({});

    expect(await repository.load(), 0);
  });

  test('最後に開いたタブを保存して復元する', () async {
    SharedPreferences.setMockInitialValues({});

    await repository.save(1);

    expect(await repository.load(), 1);
  });
}
