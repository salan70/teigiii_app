import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../util/constant/firestore_collections.dart';
import '../../domain/app_maintenance.dart';

part 'app_config_document.freezed.dart';

@freezed
class AppConfigDocument with _$AppConfigDocument {
  const factory AppConfigDocument({
    required String minAppVersionForIos,
    required String minAppVersionForAndroid,
    required Map<String, Map<String, Object>> maintenanceMap,
  }) = _AppConfigDocument;
  const AppConfigDocument._();

  factory AppConfigDocument.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;

    // maintenanceMapを生成
    // 関数として抽出したいが、factoryメソットから関数を呼び出せないと怒られるため断念
    final rawMaintenanceMap =
        data[AppConfigCollection.maintenanceMap] as Map<String, dynamic>;
    final maintenanceMap = {
      AppConfigCollection.maintenanceMap: {
        AppConfigCollection.inMaintenance:
            rawMaintenanceMap[AppConfigCollection.inMaintenance] as bool,
        AppConfigCollection.scheduledEndTime:
            rawMaintenanceMap[AppConfigCollection.scheduledEndTime] as String,
      },
    };

    return AppConfigDocument(
      minAppVersionForIos:
          data[AppConfigCollection.minAppVersionForIos] as String,
      minAppVersionForAndroid:
          data[AppConfigCollection.minAppVersionForAndroid] as String,
      maintenanceMap: maintenanceMap,
    );
  }

  AppMaintenance toAppMaintenance() {
    final maintenanceMap =
        this.maintenanceMap[AppConfigCollection.maintenanceMap]!;

    return AppMaintenance(
      inMaintenance: maintenanceMap[AppConfigCollection.inMaintenance]! as bool,
      scheduledEndTime:
          maintenanceMap[AppConfigCollection.scheduledEndTime]! as String,
    );
  }
}
