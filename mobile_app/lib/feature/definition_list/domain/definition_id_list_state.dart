import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../util/interface/list_state.dart';

part 'definition_id_list_state.freezed.dart';

@freezed
class DefinitionIdListState with _$DefinitionIdListState implements ListState {
  const factory DefinitionIdListState({
    required List<String> list,
    required String? nextCursor,
    required bool hasMore,
  }) = _DefinitionIdListState;
}
