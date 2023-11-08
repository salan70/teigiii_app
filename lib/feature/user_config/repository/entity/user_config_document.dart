import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../util/constant/firestore_collections.dart';

part 'user_config_document.freezed.dart';

@freezed
class UserConfigDocument with _$UserConfigDocument {
  const factory UserConfigDocument({
    required String id,
    required String appVersion,
    required String osVersion,
    required List<String> mutedUserIdList,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _UserConfigDocument;

  factory UserConfigDocument.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;
    return UserConfigDocument(
      id: doc.id,
      appVersion: data[UserConfigsCollection.appVersion] as String,
      osVersion: data[UserConfigsCollection.osVersion] as String,
      mutedUserIdList: ((data[UserConfigsCollection.mutedUserIdList]) as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      createdAt: (data[createdAtFieldName] as Timestamp).toDate(),
      updatedAt: (data[updatedAtFieldName] as Timestamp).toDate(),
    );
  }
}
