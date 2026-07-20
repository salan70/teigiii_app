import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../util/interface/list_state.dart';

part 'user_id_list_state.freezed.dart';

@freezed
class UserIdListState with _$UserIdListState implements ListState {
  const factory UserIdListState({
    required List<String> list,
    required String? nextCursor,
    required bool hasMore,
  }) = _UserIdListState;
}
