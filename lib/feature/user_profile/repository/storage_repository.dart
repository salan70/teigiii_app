import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/common_provider/firebase_providers.dart';

part 'storage_repository.g.dart';

@Riverpod(keepAlive: true)
StorageRepository storageRepository(StorageRepositoryRef ref) {
  return StorageRepository(ref.watch(firebaseStorageProvider));
}

class StorageRepository {
  StorageRepository(this.storage);

  final FirebaseStorage storage;

  final _fileName = 'profile_image.png';

  /// [file] をアップロードし、
  /// 完了したらダウンロードURLを返す
  Future<String> uploadFile(String userId, File file) async {
    final storageRef =
        FirebaseStorage.instance.ref().child('users/$userId/$_fileName');
    final metaData = SettableMetadata(contentType: 'image/png');

    final uploadTask = storageRef.putFile(file, metaData);
    final snapshot = await uploadTask.whenComplete(() => null);

    return snapshot.ref.getDownloadURL();
  }
}