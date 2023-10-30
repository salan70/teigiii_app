import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_id_list_state.freezed.dart';

@freezed
class UserIdListState with _$UserIdListState {
  const factory UserIdListState({
    required List<String> userIdList,

    /// 最後に読み取られたQueryDocumentSnapshot
    /// これがnullの場合、1件もuserIdを取得していない（[userIdList]が空）
    required QueryDocumentSnapshot? lastReadQueryDocumentSnapshot,
    required bool hasMore,
  }) = _UserIdListState;
}
