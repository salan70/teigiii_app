import 'dart:io';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../auth/application/auth_state.dart';
import '../domain/user_profile.dart';
import '../repository/image_repository.dart';
import '../repository/storage_repository.dart';
import '../repository/user_profile_repository.dart';
import 'user_profile_state.dart';

part 'user_profile_for_write_notifier.g.dart';

/// [UserProfile] の更新に関する処理を行う。
@riverpod
class UserProfileForWriteNotifier extends _$UserProfileForWriteNotifier {
  @override
  FutureOr<UserProfile> build() async {
    final userId = ref.read(userIdProvider)!;
    final initialUserProfile =
        await ref.read(userProfileProvider(userId).future);

    return _initialState = initialUserProfile;
  }

  /// 初期時の [UserProfile]。
  ///
  /// 現在の状態と比較するために使用する。
  late final UserProfile _initialState;

  void updateNameState(String name) =>
      state = AsyncData(state.value!.copyWith(name: name));

  void updateBioState(String bio) =>
      state = AsyncData(state.value!.copyWith(bio: bio));

  void _updateProfileImageUrlState(String profileImageUrl) => state =
      AsyncData(state.value!.copyWith(profileImageUrl: profileImageUrl));

  void updateCroppedFileState(CroppedFile? croppedFile) =>
      state = AsyncData(state.value!.copyWith(croppedFile: croppedFile));

  bool canEdit() => state.value!.isValidAllFields() && isStateChanged();

  /// 初期値と比較して、変更があるかどうか。
  bool isStateChanged() => state.value != _initialState;

  /// 画像を選択し、切り抜き、state を更新する。
  ///
  /// 画像の選択、もしくは、切り抜きがキャンセルされた場合は、
  /// state を更新せずにキャンセルした時点で処理を終える。
  Future<void> pickAndCropImage(ImageSource imageSource) async {
    final pickedFile = await _pickImage(imageSource);

    // 画像が選択されなかった場合は処理を終える。
    if (pickedFile == null) {
      return;
    }

    final croppedFile = await _cropImage(pickedFile.path);

    // 切り抜かれなかった場合は処理を終える。
    if (croppedFile == null) {
      return;
    }
    updateCroppedFileState(croppedFile);
  }

  /// 画像を選択する。
  ///
  /// 途中でキャンセルするなど、画像を選択しなかった場合はnullを返す。
  Future<XFile?> _pickImage(ImageSource imageSource) async =>
      ref.read(imageRepositoryProvider).pickImage(imageSource);

  /// 画像を切り抜く。
  ///
  /// 途中でキャンセルするなど、画像を切り抜かなかった場合はnullを返す。
  Future<CroppedFile?> _cropImage(String path) async =>
      ref.read(imageRepositoryProvider).cropImage(path);

  Future<void> edit() async {
    // 必要があれば画像をアップロードする。
    await _maybeUploadImage();

    // プロフィールを更新する。
    await ref
        .read(userProfileRepositoryProvider)
        .updateUserProfile(state.value!);

    final userId = ref.read(userIdProvider)!;
    ref.invalidate(userProfileProvider(userId));
  }

  /// 必要があれば画像をアップロードし、 state を更新する。
  Future<void> _maybeUploadImage() async {
    // 新たに画像が選択されているかどうか。
    if (state.value!.croppedFile != null) {
      // 画像をアップロードし、stateを更新する。
      final profileImageUrl = await _uploadImage();
      _updateProfileImageUrlState(profileImageUrl);
    }
  }

  /// 画像をアップロードし、ダウンロードURLを返す。
  Future<String> _uploadImage() async {
    final userId = ref.read(userIdProvider)!;
    final file = File(state.value!.croppedFile!.path);
    return ref.read(storageRepositoryProvider).uploadFile(userId, file);
  }
}
