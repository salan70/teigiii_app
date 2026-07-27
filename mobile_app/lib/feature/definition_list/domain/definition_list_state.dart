import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../util/interface/list_state.dart';
import '../../definition/domain/definition.dart';

part 'definition_list_state.freezed.dart';

/// 定義一覧（フィード）の state。
///
/// 一覧 API は定義本体を返すため、ID ではなく [Definition] を保持する。
/// ID しか持たないと各 tile が個別に再取得して N+1 になる。
@freezed
class DefinitionListState
    with _$DefinitionListState
    implements ListState<Definition> {
  const factory DefinitionListState({
    required List<Definition> list,
    required String? nextCursor,
    required bool hasMore,
  }) = _DefinitionListState;
}
