import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../util/constant/firestore_collections.dart';

part 'app_config_document.freezed.dart';

@freezed
class AppConfigDocument with _$AppConfigDocument {
  const factory AppConfigDocument({
    required String minAppVersionForIos,
    required String minAppVersionForAndroid,
  }) = _AppConfigDocument;

  factory AppConfigDocument.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;
    return AppConfigDocument(
      minAppVersionForIos:
          data[AppConfigCollection.minAppVersionForIos] as String,
      minAppVersionForAndroid:
          data[AppConfigCollection.minAppVersionForAndroid] as String,
    );
  }
}
