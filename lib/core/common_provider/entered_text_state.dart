import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'entered_text_state.g.dart';

@riverpod
class EnteredTextNotifier extends _$EnteredTextNotifier {
  @override
  String build() {
    return '';
  }

  // ignore: use_setters_to_change_properties
  void updateText(String text) {
    state = text;
  }

  void clearText() {
    state = '';
  }
}
