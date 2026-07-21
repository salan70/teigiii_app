import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teigi_app/feature/introduction/repository/definition_guide_repository.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('初回だけ表示対象になり、表示済み保存後は対象外になる', () async {
    const repository = DefinitionGuideRepository();

    expect(await repository.shouldShow(), isTrue);
    await repository.markAsShown();
    expect(await repository.shouldShow(), isFalse);
  });
}
