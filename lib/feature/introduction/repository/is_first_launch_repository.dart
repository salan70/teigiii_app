import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'is_first_launch_repository.g.dart';

@riverpod
IsFirstLaunchRepository isFirstLaunchRepository(
  IsFirstLaunchRepositoryRef ref,
) =>
    IsFirstLaunchRepository();

class IsFirstLaunchRepository {
  IsFirstLaunchRepository();

  final _isFirstLaunch = 'isFirstLaunch';

  Future<bool> isFirstLaunch() async {
    final preference = await SharedPreferences.getInstance();
    return preference.getBool(_isFirstLaunch) ?? true;
  }

  Future<void> saveFirstLaunch() async {
    final preference = await SharedPreferences.getInstance();
    await preference.setBool(_isFirstLaunch, false);
  }
}
