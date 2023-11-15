import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/common_provider/firebase_providers.dart';
import '../../../util/constant/firestore_collections.dart';
import 'entity/app_config_document.dart';

part 'app_config_repository.g.dart';

@Riverpod(keepAlive: true)
AppConfigRepository appConfigRepository(AppConfigRepositoryRef ref) =>
    AppConfigRepository(ref.watch(firestoreProvider));

class AppConfigRepository {
  AppConfigRepository(this.firestore);

  final FirebaseFirestore firestore;

  CollectionReference get _appConfigCollectionRef =>
      firestore.collection(AppConfigCollection.collectionName);

  Stream<AppConfigDocument> subscribeAppConfig() {
    final snapshot = _appConfigCollectionRef.limit(1).snapshots();

    return snapshot.map(
      (data) => AppConfigDocument.fromFirestore(data.docs.first),
    );
  }
}
