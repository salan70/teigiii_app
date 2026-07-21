import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'definition_guide_repository.g.dart';

@riverpod
DefinitionGuideRepository definitionGuideRepository(
  DefinitionGuideRepositoryRef ref,
) => const DefinitionGuideRepository();

class DefinitionGuideRepository {
  const DefinitionGuideRepository();

  static const _key = 'definition.guideShown';

  Future<bool> shouldShow() async {
    final preferences = await SharedPreferences.getInstance();
    return !(preferences.getBool(_key) ?? false);
  }

  Future<void> markAsShown() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_key, true);
  }
}
