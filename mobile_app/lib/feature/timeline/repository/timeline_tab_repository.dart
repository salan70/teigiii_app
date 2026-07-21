import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'timeline_tab_repository.g.dart';

@riverpod
TimelineTabRepository timelineTabRepository(TimelineTabRepositoryRef ref) =>
    const TimelineTabRepository();

class TimelineTabRepository {
  const TimelineTabRepository();

  static const _key = 'timeline.selectedTab';

  Future<int> load() async {
    final preferences = await SharedPreferences.getInstance();
    final index = preferences.getInt(_key);
    return index == 1 ? 1 : 0;
  }

  Future<void> save(int index) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setInt(_key, index == 1 ? 1 : 0);
  }
}
