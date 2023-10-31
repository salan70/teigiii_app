import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../util/interface/list_state.dart';

part 'user_id_list_state.freezed.dart';

@freezed
class UserIdListState with _$UserIdListState implements ListState {
  const factory UserIdListState({
    required List<String> userIdList,

    /// 最後に読み取られたQueryDocumentSnapshot
    /// これがnullの場合、1件もuserIdを取得していない（[userIdList]が空）
    required QueryDocumentSnapshot? lastReadQueryDocumentSnapshot,
    required bool hasMore,
  }) = _UserIdListState;
}
